#!/bin/sh
xset +fp ~/.fonts
xset +fp /usr/share/fonts/tamsyn-font-1.10
xset +fp /usr/share/fonts/tewi-font
xset +fp /usr/share/fonts/xbmicons
xset +fp /usr/share/fonts/TTF
xset +fp /usr/share/fonts/uushi
xrdb ~/.Xresources
feh --bg-fill ~/Pictures/frac.jpg
sh ~/.fehbg &
sh ~/.xsetroot.sh
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
compton -b
exec dwm


