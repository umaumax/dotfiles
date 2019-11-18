#!/usr/bin/env python3

import argparse
import re
import sys

"""
    # vars
    line - Current line text, including newline.
    l - Current line text, excluding newline.
    n - The current 1-based line number.
    f - Fields of the line (split by the field separator -F).
    nf - Number of fields in this line.
    m - Tuple of match regular expression capture groups, if any.

    # In the context of the -E block:
    t - The entire input text up to the current cursor position.

    # original var
    d - Dictionary of match regular expression capture groups, if any.
"""


def parse_options():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    # parser.add_argument('-I', '--in_place',
    # help='modify given input file in-place')
    parser.add_argument('-F', '--delim', help='input delimiter', default=' +')
    # parser.add_argument('-H', '--header', action='store_true',
    # help='use first row as field variable names in subsequent rows')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='enable verbose log output')
    parser.add_argument('files', nargs='*')
    return parser.parse_known_args()


def run(options, input):
    #### begin block ####

    #### begin block ####

    m = ()
    d = {}
    line = ''

    def filter(pat):
        nonlocal m, d, line
        match_ret = re.search(pat, line)
        m = match_ret.groups() if match_ret else ()
        d = match_ret.groupdict() if match_ret else ()
        return match_ret

    n = 0
    t = ''
    while True:
        l = input.readline()
        if not l:
            break
        t += l
        n += 1
        line = l.strip()
        f = re.split(options.delim, line)
        nf = len(f)
        # WARN: tricy way to allow to access index out of range
        f_max = 99
        f += [""] * (f_max - len(f) if len(f) < f_max else 0)

        if options.verbose:
            print("line:", line, file=sys.stderr)
            print("l:", l, file=sys.stderr)
            print("n:", n, file=sys.stderr)
            print("f:", f, file=sys.stderr)
            print("nf:", nf, file=sys.stderr)
            print("m:", m, file=sys.stderr)
            print("d:", d, file=sys.stderr)

        #### line block ####
        if filter(r'^#(?P<comment>.*)'):
            pass
        if not filter(r'^#'):
            pass
        #### line block ####

    #### end block ####

    #### end block ####

    if options.verbose:
        print("t:", t, end="", file=sys.stderr)


def main():
    options, _ = parse_options()
    if len(options.files) == 0:
        input = sys.stdin
        run(options, input)
        return

    for file in options.files:
        with open(file, 'r') as f:
            run(options, f)


if __name__ == '__main__':
    main()
