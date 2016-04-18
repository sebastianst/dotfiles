[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xresources.solarized.light ]] && xrdb -merge ~/.Xresources.solarized.light
setxkbmap -layout us -option caps:swapescape
#pulseaudio
compton -b
unclutter &
udiskie -as &
exec i3
