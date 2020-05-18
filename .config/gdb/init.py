import os
import sys

# NOTE: don't use append
sys.path.extend(
    [
        os.environ['HOME'] +
        '/.pyenv/versions/2.7.15/lib/python2.7/site-packages',
        '/usr/local/lib/python2.7/site-packages/',
    ]
)
