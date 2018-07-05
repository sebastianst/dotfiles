#!/bin/sh
RFID=1

if systemctl is-active --quiet bluetooth; then
  pkill blueman-applet
  sudo systemctl stop bluetooth
  rfkill block $RFID
else
  rfkill unblock $RFID
  sudo systemctl start bluetooth
  blueman-applet
fi
