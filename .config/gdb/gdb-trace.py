#!/usr/bin/env python

import gdb

import re


class Executor:
    def __init__(self, cmds):
        self.__cmds = cmds

    def __call__(self):
        for cmd in self.__cmds:
            gdb.execute(cmd, from_tty=True, to_string=False)


class FunctionEnterBreakpoint(gdb.Breakpoint):
    def __init__(self, spec, hook_spec=""):
        self._function_name = spec
        self._hook_function_name = hook_spec
        self._hooking = False
        super(FunctionEnterBreakpoint, self).__init__(spec, internal=True)

    def stack_depth(self):
        depth = -1
        frame = gdb.newest_frame()
        while frame:
            # NOTE: you can get function name by frame.name()
            frame = frame.older()
            depth += 1
        return depth

    def stop(self):
        args = []
        info_args = gdb.execute('info args', from_tty=False, to_string=True)
        if info_args != 'No arguments.\n':
            # NOTE: filter non args output
            # e.g. 'Current language:  auto, The current source language is
            # "auto; currently c++".'
            args = list(filter(lambda l: "=" in l, info_args.splitlines()))
        info_args_str = ', '.join(args)

        # NOTE: _hooking is used for avoiding circular call from hooked
        # function
        if self._hook_function_name and not self._hooking:
            self.hook(args)
        else:
            gdb.write('%s%s (%s)\n' % ('  ' * self.stack_depth(),
                                       self._function_name, info_args_str), gdb.STDLOG)
        # WARN: if return True,
        # hookでhook元の関数を呼び出した時にgdb.execute中にinteractive状態になる?ことになるので、エラーとなる
        return False  # continue immediately:

    def hook(self, args):
        # arg name list
        arg_names_str = ', '.join(
            list(map(lambda s: s.split(" = ", 1)[0], args)))
        # WARN: manage _hooking flag by thread id hash map for multi-thread app
        self._hooking = True
        cmd = 'return {}({})'.format(self._hook_function_name, arg_names_str)
        gdb.execute(cmd, from_tty=False, to_string=False)
        self._hooking = False

    # WARN: trace function is WIP
    def trace(self, args):
        # traced
        # WARN: finishをcallするとframeを抜けてしまうので、arg nameは利用できず、関数が呼ばれた際の引数のvalueを利用するケース
        # arg value list
        arg_values_str = ', '.join(
            list(map(lambda s: s.split(" = ", 1)[1], args)))
        # WARN: そもそも、breakpointが貼られていても、このハンドラが呼ばれた際に、途中で止まってしまい、continueで無理やり再開してしまうので、
        # 現在の状態を監視する必要があるが、finishするまでに、他のハンドラが反応してしまうとpost_eventの整合性がおかしくなるのでは?
        cmds = ['finish', 'call {}({})'.format(
            self._hook_function_name, arg_values_str), 'continue']
        # NOTE:
        # use post_event: to avoid 'gdb.error: Cannot execute this command while the selected thread is running.'
        # don't call post_event more once
        gdb.post_event(Executor(cmds))
        return True  # stop here for post_event


class TraceFunctionCommand(gdb.Command):
    breakpoints = []

    def __init__(self):
        super(TraceFunctionCommand, self).__init__(
            'trace-functions',
            gdb.COMMAND_SUPPORT,
            gdb.COMPLETE_NONE,
            True)

    @staticmethod
    def extract_function_names():
        info_functions = gdb.execute(
            'info functions', from_tty=False, to_string=True)
        result = []
        current_file = None
        for line in info_functions.splitlines():
            if line.startswith('File '):
                current_file = line[5:-1]
            elif line.startswith('Non-debugging'):
                break
            elif current_file:
                match = re.search(r'[\s*]([^\s*]+)\(', line)
                if match and current_file.find('/usr/include') == -1:
                    function_name = match.group(1)
                    result.append(function_name)
        return result

    def invoke(self, arg, from_tty):
        if not arg:
            gdb.write("1st arg: regex function filter\n")
            gdb.write("if 1st arg is 'clear': clear breakpoints\n")
            return
        if arg == 'clear':
            gdb.write("clear breakpoints\n")
            [bp.delete() for bp in TraceFunctionCommand.breakpoints]
            return

        p = re.compile(arg)

        function_names = self.extract_function_names()
        filtered_function_names = function_names
        filtered_function_names = [n for n in function_names if p.fullmatch(n)]
        count = 0
        verbose = (len(filtered_function_names) > 1000)
        hook_suffix = "_hook"
        for name in filtered_function_names:
            hook_name = ""
            if name.endswith(hook_suffix):
                base_name = name[:-len(hook_suffix)]
                if base_name in function_names:
                    hook_name = name
                    name = base_name
            bp = FunctionEnterBreakpoint(name, hook_name)
            TraceFunctionCommand.breakpoints.append(bp)
            count += 1
            if count < 128:
                if hook_name:
                    gdb.write('[Hooked]: %s\n' % (hook_name), gdb.STDERR)
                else:
                    gdb.write('[Traced]: %s\n' % (name), gdb.STDERR)
            if verbose and count % 128 == 0:
                gdb.write('\r%d / %d breakpoints set' %
                          (count, len(function_names)),
                          gdb.STDERR)
        if verbose:
            gdb.write('\r%(n)d / %(n)d breakpoints set\n' %
                      {'n': len(function_names)}, gdb.STDERR)


TraceFunctionCommand()
