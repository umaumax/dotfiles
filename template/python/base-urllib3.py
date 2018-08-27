#!/usr/bin/env python3

import os
import urllib3


def main():
    http_proxy = os.getenv("http_proxy")
    option = {'': ''}
    http = urllib3.ProxyManager(http_proxy, **option) if http_proxy else urllib3.PoolManager(**option)
    r = http.request('GET', 'http://httpbin.org/get')
    print("{0}".format(r.data.decode("utf-8")))


if __name__ == '__main__':
    main()
