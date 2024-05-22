#!/usr/bin/env python3

import sys
import datetime
import locale

start_date_str = sys.argv[1] if len(
    sys.argv) > 1 else "today"
if start_date_str in ["today", "now"]:
    start_date_str = datetime.datetime.now().strftime("%m/%d")

period_days = int(sys.argv[2]) if len(
    sys.argv) > 2 else 5

locale.setlocale(locale.LC_TIME, 'ja_JP.UTF-8')

date_list = [
    (datetime.datetime.strptime(
        start_date_str,
        "%m/%d").replace(
            year=datetime.datetime.now().year) +
     datetime.timedelta(
        days=i)).strftime("# %m/%d(%a)") for i in range(period_days)]

print("\n\n".join(date_list))
