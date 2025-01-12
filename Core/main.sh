options=(
    "Monitor Mode" 
    "Start Airgeddon" 
    "Change MAC"
    "Network Monitoring"
    "Capture Handshake"
    "WPS Attack"
    "Install Packages" 
    "Restart Network Manager" 
    "Settings" 
    "About"
    "Exit"
)
descriptions=(
    "Put interface in monitor mode"
    "Launch Airgeddon wireless auditing tool."
    "Change MAC."
    "Monitor wireless networks."
    "Capture WPA/WPA2 handshakes from networks."
    "(bully) Bruteforce PIN attack."
    "List of popular packages."
    "Put interface in managed mode"
    "Edit csv files & update script"
    "
⠈⠙⠲⢶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⡀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⣼⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⠟⠓⠉
⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⢀⣧⣶⣦⣇⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣾⣿⣿⣿⣿⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠟⠛⠛⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
BatLinux developed by Emad Adel, known as 'Dark Knight.'\nYou can find the source code for this script and more projects on his GitHub: emadadel4."
    "Exit from script."
)
selected=0

# Functions
###########################################
Draw_Main_Menu() {
    echo -e "\033[0;33m[i] Use ↑/↓ or W/S to navigate, Enter/Space to select\033[0m"
    echo ""
    
    # Display menu options with selection indicator
    for i in ${!options[@]}; do
        if [ $i -eq $selected ]; then
            echo -e "\e[96m> ${options[$i]}\e[0m"
        else
            echo "  ${options[$i]}"
        fi
    done
    
    # Display description of selected option
    echo "----------------------------------------"
    echo -e "${descriptions[$selected]}"
}

# Handle menu selection
Handle_Main_Selection() {
    case $selected in
        0) # Monitor Mode
           Monitor_Mode
           ;;
        1) # Start Airgeddon
           x-terminal-emulator -e airgeddon
           ;;
        2) # Change MAC address
           MAC_change
           ;;
        3) # Network Monitoring
           Network_Monitoring
           ;;
        4) # Capture Handshake
           Capture_Handshake
           ;;
        5) # WPS
            Crack_WPS
            ;;   
        6) # Install required packages
            Packages
           ;;
        7) # Restart NetworkManager
           airmon-ng stop wlan0
           NetworkManager restart
           ;;
        8) # Settings
            Settings_Loop
           ;;
        9) # About
           xdg-open "https://github.com/emadadel4"
           return
           ;;
        10) # Exit program
           exit 0
           ;;
    esac
}

Main_Loop() {
    while true; do
        clear
        HEADER
        Draw_Main_Menu
        read -rsn1 key
        case "$key" in
            $'\x1B')  # Handle arrow keys
                read -rsn2 key
                case "$key" in
                    "[A") # Up arrow
                        ((selected--))
                        [ $selected -lt 0 ] && selected=$((${#options[@]}-1))
                        ;;
                    "[B") # Down arrow
                        ((selected++))
                        [ $selected -ge ${#options[@]} ] && selected=0
                        ;;
                esac
                ;;
            [wW]) # W key - Move up
                ((selected--))
                [ $selected -lt 0 ] && selected=$((${#options[@]}-1))
                ;;
            [sS]) # S key - Move down
                ((selected++))
                [ $selected -ge ${#options[@]} ] && selected=0
                ;;
            "") # Enter key - Select option
                Handle_Main_Selection
                ;;
            [fF]) # F key - Select option
                Handle_Main_Selection
                ;;
        esac
    done
}

# Start the main loop
Check_Dependencies
Main_Loop