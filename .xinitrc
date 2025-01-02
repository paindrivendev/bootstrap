export DISPLAY=:0
dbus-update-activation-environment --systemd DISPLAY
exec i3
