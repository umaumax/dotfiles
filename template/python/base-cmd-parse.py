#!/usr/bin/env python3
import argparse


def write_file(file_name, text):
    with open(file_name, 'w') as f:
        f.write(text)
        f.truncate()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-option-xxx', default='')
    parser.add_argument('required-arg')

    args, extra_args = parser.parse_known_args()
    # args.option_xxx
    # args.required_arg


if __name__ == "__main__":
    main()
