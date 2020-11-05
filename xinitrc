[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xhost +si:localuser:$USER
xset s off // disable screen saver
xset dpms 0 0 5400 // dmps screen blank after 90 min
setxkbmap -layout us,de -option grp:menu_toggle -option terminate:ctrl_alt_bksp
unclutter -b # remember to install unclutter-xfixes-git from AUR!
udiskie -As &
# https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
exec i3
