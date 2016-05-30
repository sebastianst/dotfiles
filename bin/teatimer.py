#!/usr/bin/python3
# from http://www.janjachnik.com/python/tea/timer/2015/09/21/python-tea-timer/
from gi.repository import Notify
import sys
import time

notify_title = 'Tea time!'
notify_body = 'Your tea is ready, go get it!'
notify_icon = 'dialog-information'

default_wait_time = 120

def usage():
    print("Usage: ",sys.argv[0],"<wait_duration_in_seconds>")

if len(sys.argv)>2:
    usage()
    sys.exit()

wait_time = default_wait_time
if len(sys.argv)>1:
    try:
        wait_time = int(sys.argv[1])
    except ValueError:
        usage()
        print("Duration must be integer")
        sys.exit()

time.sleep(wait_time)

Notify.init("Tea timer")
notification=Notify.Notification.new(notify_title, notify_body, notify_icon)
notification.show()
