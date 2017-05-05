[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xhost +si:localuser:$USER
setxkbmap -layout us,de -option grp:menu_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp -option altwin:swap_lalt_lwin
#pulseaudio
compton -b
unclutter -b # remember to install unclutter-xfixes-git from AUR!
udiskie -As &
# https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
exec i3
