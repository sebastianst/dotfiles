#!/bin/sh
RFID=bluetooth

if systemctl is-active --quiet bluetooth; then
  pkill blueman-applet
  sudo systemctl stop bluetooth
  sudo rfkill block $RFID
else
  sudo rfkill unblock $RFID
  sudo systemctl start bluetooth
  blueman-applet
fi
