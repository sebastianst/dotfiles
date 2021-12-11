#!/bin/sh
# WM agnostic script to start up common applications
clipster -d &
nm-applet &
redshift-gtk &
#xidlehook --not-when-audio --not-when-fullscreen --timer 120 "i3lock -c 003366" "" &
#thunderbird &
#rambox &
spotify &
#protonmail-bridge & # Protonmail
