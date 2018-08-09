#!/usr/bin/env python3
import sys


def main():
    lines = sys.stdin.readlines()
    for i, line in enumerate(lines):
        line = line.strip("\n")
        print("{0}:{1}".format(i + 1, line))


if __name__ == "__main__":
    main()
