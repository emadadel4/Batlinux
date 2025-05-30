function Network_Monitoring(){

    CSV_FILE="${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    selected=0
    IFS=$'\n' read -d '' -r -a lines < <(tail -n +2 "$CSV_FILE")
    total_lines=${#lines[@]}
    Draw_Network_Menu() {
    clear
    echo "=== Network Monitoring ==="
    echo "---------------------------------------------------"
    printf " %-25s %-20s %-8s %-4s\n" "ESSID" "BSSID" "Channel" "WPS"
    echo ""

        for i in "${!lines[@]}"; do
            IFS=',' read -r ESSID BSSID Channel WPS Note <<< "${lines[$i]}"
            if [ $i -eq $selected ]; then
                printf "\e[${BatLinux[TextForg]};${BatLinux[Background]}m${BatLinux[SelectionIcon]} %-24s %-20s %-8s %-4s\e[0m\n" "$ESSID" "$BSSID" "$Channel" "$WPS"
                selected_note="$Note"
            else
                printf " %-25s %-20s %-8s %-4s\n" "$ESSID" "$BSSID" "$Channel" "$WPS"
            fi
        done
        echo ""
        echo "---------------------------------------------------"
        echo "[Note] $selected_note"
    }

function Monitoring() {
    clear
    IFS=',' read -r ESSID BSSID Channel Note <<< "${lines[$selected]}"
    x-terminal-emulator -e airodump-ng wlan0 --bssid $BSSID --channel $Channel
    wait
    Network_Monitoring
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
            Monitoring
            break 
            ;;
        [qQ]) # Quit
            clear
            return
            ;;
    esac
    done

}