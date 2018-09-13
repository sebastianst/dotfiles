#!/bin/bash

setxkbmap -layout us,de -option -option grp:menu_toggle -option terminate:ctrl_alt_bksp
echo $1
[[ $1 == normal ]] && setxkbmap -option caps:swapescape -option altwin:swap_lalt_lwin
