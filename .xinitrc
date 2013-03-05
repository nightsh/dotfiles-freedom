DEFAULT_SESSION=awesome
/usr/bin/numlockx on
exec awesome
#exec mate-session
xrdb ~/.Xresources &
xsetroot -cursor_name left_ptr
xsetroot -cursor_name left_ptr_watch
xset b off

#case $1 in
#kde)
#	exec startkde
#	;;
#xfce4)
#	exec startxfce4
#	;;
#fluxbox)
#	exec startfluxbox
#	;;
#awesome)
#	exec awesome
#	;;
#i3)
#	exec i3
#	;;
#xmonad
#	exec xmonad
#	;;
#*)
#	exec $DEFAULT_SESSION
#	;;
#esac
