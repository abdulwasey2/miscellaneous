#!/bin/bash

# 1. Folder jahan snippets hain
SNIPPET_DIR="$HOME/mysnippets"

# 2. Rofi menu se file select karein
SELECTION=$(ls "$SNIPPET_DIR" | rofi -dmenu -i -p "Search Abbreviation:")

# 3. Agar file select hui hai toh:
if [ -n "$SELECTION" ]; then
    CONTENT=$(cat "$SNIPPET_DIR/$SELECTION")
    
    # Rofi menu band hone ka intezar
    sleep 0.3

    # Ye logic text aur keys ko alag alag karega
    # Hum content ko split karenge jahan {} brackets hain
    echo "$CONTENT" | sed 's/{\([^}]*\)}/\nKEY:\1\n/g' | while read -r line; do
        if [[ "$line" == KEY:* ]]; then
            # Agar line KEY: se shuru ho rahi hai toh wo key press karega
            KEY_NAME=${line#KEY:}
            xdotool key "$KEY_NAME"
        elif [ -n "$line" ]; then
            # Warna normal text type karega
            xdotool type "$line"
        fi
    done
fi