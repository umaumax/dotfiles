#!/usr/bin/env python2

import gdb
import sys
import tempfile


class HelloWorld(gdb.Command):
    """Greet the whole world."""

    def __init__(self):
        # you can use 'hello-world' command
        super(HelloWorld, self).__init__("hello-world", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print("Hello, World!", "python version is ", sys.version)


HelloWorld()


class Pipe(gdb.Command):
    def __init__(self):
        super(Pipe, self).__init__("pipe", gdb.COMMAND_USER)

        self.verbose = False

    def help(self):
        print('e.g. pipe info locals | fzf -m')
        print('e.g. pipe help > help.log')

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if self.verbose:
            print("input args:", args)
        if '|' not in args:
            if '>' not in args:
                self.help()
                return
            index = args.index('>')
            gdb_command = ' '.join(args[:index])
            shell_command = ''
            if len(args) <= index + 1:
                self.help()
                return
            filename = args[index + 1]
        else:
            index = args.index('|')
            gdb_command = ' '.join(args[:index])
            shell_command = ' '.join(args[index + 1:])
            filename = ''

        if self.verbose:
            print("input gdb command:", gdb_command)
        output = gdb.execute(gdb_command, to_string=True)

        if filename:
            with open(filename, 'w') as fp:
                fp.writelines(output)
            return

        with tempfile.NamedTemporaryFile() as fp:
            fp.writelines(output)
            fp.flush()
            if self.verbose:
                print("shell_command:", '[', shell_command, ']')
            gdb_shell_command = "shell cat '" + fp.name + "' | " + shell_command
            if self.verbose:
                print("gdb_shell_command:", '[', gdb_shell_command, ']')
            output = gdb.execute(
                gdb_shell_command,
                to_string=True)
            print(output)


Pipe()
