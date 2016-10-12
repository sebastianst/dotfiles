[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xhost +si:localuser:$USER
setxkbmap -layout us,de -option grp:menu_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp
#pulseaudio
compton -b
unclutter &
udiskie -as &
exec i3
