#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setterm -powersave off -blank 0

export GDK_BACKEND=x11
export XDG_SESSION_TYPE=x11

exec gnome-session
#exec startplasma-x11
#exec startxfce4

###############################################
######## Tiling Window Managers ###############
###############################################

#exec herbstluftwm
#exec xmonad
#dbus-launch --exit-with-session i3
#exec awesome
#exec qtile
#exec spectrwm
