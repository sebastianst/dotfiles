#!/usr/bin/python3
# from http://www.janjachnik.com/python/tea/timer/2015/09/21/python-tea-timer/
# argparse and Timer input extended by me, Sebastian
import gi
gi.require_version('Notify', '0.7')
from gi.repository import Notify
import sys
import time
import argparse
import tkinter as tk
from tkinter import simpledialog as sd

notify_title = 'Tea time!'
notify_body = 'Your tea is ready, go get it!'
notify_icon = 'dialog-information'

### Parse arguments
parser = argparse.ArgumentParser(description='Tea timer :)')
parser.add_argument('time', type=float, default=120, nargs='?',
        help='Time in seconds or minutes (see -m)')
parser.add_argument('-m', '--minutes', action='store_true',
        help='Switch whether time is given in minutes, not seconds')
parser.add_argument('-d', '--dialog', action='store_true',
        help='Show graphical dialog for time entry')
args = parser.parse_args()

wait_time = args.time

### Create time input dialogue if requested
if args.dialog:
    root = tk.Tk()
    root.withdraw()
    unit = 'minutes' if args.minutes else 'seconds'
    wait_time = sd.askfloat('Tea Timer', 'Time in ' + unit + ':')
    if not wait_time: exit(1)

# Adjust time to seconds
if args.minutes:
    wait_time *= 60
time.sleep(wait_time)

Notify.init("Tea timer")
notification=Notify.Notification.new(notify_title, notify_body, notify_icon)
notification.show()
