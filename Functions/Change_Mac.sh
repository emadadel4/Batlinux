function MAC_change() {
CSV_FILE="${BatLinux["Main_DIR"]}/${BatLinux["Mac_File"]}"
selected=0
IFS=$'\n' read -d '' -r -a lines < <(tail -n +2 "$CSV_FILE")
total_lines=${#lines[@]}

# Function to draw MAC selection menu
Draw_Mac_Menu() {
    clear
    echo "=== MAC Address ==="
    echo "----------------------------------------"
    printf " %-20s %-20s\n" "Device" "MAC"
    echo ""
    for i in "${!lines[@]}"; do
        IFS=',' read -r Device Mac Note <<< "${lines[$i]}"
        if [ $i -eq $selected ]; then
            printf "\e[${BatLinux[TextForg]};${BatLinux[Background]}m${BatLinux[SelectionIcon]} %-19s %-20s\e[0m\n" "$Device" "$Mac"
            selected_note="$Note"
        else
            printf " %-20s %-20s\n" "$Device" "$Mac"
        fi
    done
    echo ""
    echo "----------------------------------------"
    echo "[Note] $selected_note"
}

Change_mac() {
    clear
    IFS=',' read -r Device Mac Note <<< "${lines[$selected]}"
    ifconfig wlan0 down
    macchanger -m "$Mac" wlan0
    echo "Changing MAC address to: $Mac"
    echo "Bringing the interface wlan0 up..."
    ifconfig wlan0 up
    macchanger -s wlan0
    echo "MAC address changed successfully."
    read -n1 -p "Press any key to continue"
}

# Handle keyboard input
while true; do
    Draw_Mac_Menu
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
            Change_mac
            break 
            ;;
        [qQ]) # Quit
            clear
            return
            ;;
    esac
done
}