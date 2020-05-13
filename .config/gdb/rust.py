#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys
import tempfile
import gdb
import subprocess
import re


class SetRustSubStitutePath(gdb.Command):
    def __init__(self):
        super(
            SetRustSubStitutePath,
            self).__init__(
            "set-rust-substitute-path",
            gdb.COMMAND_USER)

        self.verbose = False

    def help(self):
        print("e.g. set-rust-substitute-path # used target from 'info target'")
        print("e.g. set-rust-substitute-path 'target_rust_exe_file'")

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if self.verbose:
            print("input args:", args)

        rustc_sysroot = subprocess.run(
            "rustc --print=sysroot",
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE).stdout.decode('utf-8').strip()
        if len(rustc_sysroot) == 0:
            print(
                "failed 'rustc --print=sysroot'")
            self.help()
            return

        target = None
        if len(args) >= 1:
            target = args[0]
        else:
            output = gdb.execute("info target", to_string=True)

            m = re.compile(
                r'^Symbols from "(?P<symbol>.*)"\.$|^ *`(?P<local_exec_file>.*)\', .*$',
                re.MULTILINE).search(output)
            if m:
                target = m.group('symbol')
                if target is None:
                    target = m.group('local_exec_file')
            if target is None:
                print('cannot found target file automatically')
                self.help()
                return

        command = r"strings {} | grep -o '^/rustc/[^/]\+/' | uniq".format(
            target)
        debug_srcpath = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE).stdout.decode('utf-8').strip()
        if len(debug_srcpath) == 0:
            print(
                "cannot extract rust substitute-path from '{}' automatically".format(target))
            self.help()
            return
        gdb_set_debug_src_command = "set substitute-path {} {}/lib/rustlib/src/rust/".format(
            debug_srcpath, rustc_sysroot)
        print("[log] {}".format(gdb_set_debug_src_command))
        gdb.execute(gdb_set_debug_src_command)


SetRustSubStitutePath()
