#!/bin/bash
MON=$(xrandr | grep " connected" | cut -d" " -f1 | head -n1)
KBD=$(xinput list | grep -i "AT Translated" | grep -o "id=[0-9]*" | cut -d= -f2 | head -n1)
[ -z "$KBD" ] && KBD=$(xinput list | grep -i keyboard | grep -o "id=[0-9]*" | cut -d= -f2 | head -n1)

while true; do
  CUR=$(xrandr --verbose | grep -i brightness | awk '{print $2}' | head -n1)
  NEW=$(echo "$CUR - 0.05" | bc -l)
  if [ $(echo "$NEW < 0.1" | bc -l) -eq 1 ]; then NEW=0.1; xrandr --output $MON --brightness $NEW; break; fi
  xrandr --output $MON --brightness $NEW
  sleep 0.25
  xinput query-state $KBD 2>/dev/null | grep -Eq "key\[133\]=down|key\[134\]=down" || break
done
