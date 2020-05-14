import sys


class pycolor:
    C_BLACK = '30'
    C_RED = '31'
    C_GREEN = '32'
    C_YELLOW = '33'
    C_BLUE = '34'
    C_PURPLE = '35'
    C_CYAN = '36'
    C_WHITE = '37'
    C_RESET = '0'
    C_UNDERLINE = '4'
    C_INVISIBLE = '08'
    C_REVERCE = '07'
    ERROR = C_RED
    WARN = C_YELLOW
    VERBOSE = C_PURPLE
    INFO = C_CYAN

    @classmethod
    def ansi_wrap(cls, string, style):
        return '\x1b[{}m{}\x1b[0m'.format(style, string)

    @classmethod
    def log_error(cls, string):
        print(cls.ansi_wrap(string, cls.ERROR), file=sys.stderr)

    @classmethod
    def log_warn(cls, string):
        print(cls.ansi_wrap(string, cls.WARN), file=sys.stderr)

    @classmethod
    def log_verbose(cls, string):
        print(cls.ansi_wrap(string, cls.VERBOSE), file=sys.stderr)

    @classmethod
    def log_info(cls, string):
        print(cls.ansi_wrap(string, cls.INFO), file=sys.stderr)
