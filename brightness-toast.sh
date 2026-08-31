#!/bin/bash
# up ya down
DIR=$1
STEP=2

if [ "$DIR" = "up" ]; then
  /usr/bin/brightnessctl -c backlight set ${STEP}%+ -q
else
  /usr/bin/brightnessctl -c backlight set ${STEP}%- -q
fi

# current % nikalo
PERCENT=$(brightnessctl -c backlight -m | cut -d, -f4 | tr -d %)
# 0.0 se 1.0 ke liye level
LEVEL=$(awk "BEGIN {print $PERCENT/100}")

# Asal GNOME OSD dikhao - yehi woh toast hai jo 1 sec rehta hai aur update hota hai
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.ShowOSD "{'icon': <'display-brightness-symbolic'>, 'level': <$LEVEL>, 'label': <'Brightness: $PERCENT%'>}" > /dev/null 2>&1

# Agar ShowOSD fail ho to fallback notification jo same jagah update hoga
if [ $? -ne 0 ]; then
  notify-send -h string:x-canonical-private-synchronous:brightness -h int:value:$PERCENT -i display-brightness-symbolic "Brightness $PERCENT%"
fi
