[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap -layout us,de -option grp:menu_toggle -option caps:swapescape
#pulseaudio
compton -b
unclutter &
udiskie -as &
exec i3
