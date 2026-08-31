#!/bin/bash
# Battery Full Notification Script

NOTIFIED=false

while true; do
    STATUS=$(cat /sys/class/power_supply/BAT0/status)
    CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

    # Agar battery charge ho rahi hai aur 95% se upar hai
    if [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
        if [ "$CAPACITY" -ge 95 ] && [ "$NOTIFIED" = false ]; then
            notify-send -u critical -i battery-full "Battery Alert!" "Battery is at ${CAPACITY}%. Please unplug the charger."
            # Optional: Agar sound alert bhi chahiye toh niche wali line se '#' hata dein
            # spd-say "Battery full"
            NOTIFIED=true
        fi
    fi

    # Jab charger unplug ho jaye toh flag reset kar dein
    if [ "$STATUS" = "Discharging" ]; then
        NOTIFIED=false
    fi

    # Har 60 seconds baad check karega
    sleep 60
done
