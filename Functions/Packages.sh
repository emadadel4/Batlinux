function Packages() {

    selected=0

   # Packages

    total_lines=${#Packages[@]}

    # Function to draw menu
    Draw_Package_menu() {
        clear
        echo "=== Packages ==="
        echo "---------------------------------------------------"
        for i in "${!Packages[@]}"; do
            IFS=':' read -r Name APT Description <<< "${Packages[$i]}"
            if [ $i -eq $selected ]; then
                echo -e "\e[97;41m> $Name ($APT)\e[0m"
                selected_description="$Description"
            else
                echo -e "$Name ($APT)"
            fi
        done
        echo "---------------------------------------------------"
        echo "$selected_description"
    }

    function Install() {
        IFS=':' read -r Name PKG Description <<< "${Packages[$selected]}"
        echo "Installing $PKG"
        sudo apt-get install $PKG
        read -n1 -p "Press any key to continue..."
    }

    # Handle keyboard input
    while true; do
        Draw_Package_menu
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
                Install
                ;;
            [qQ]) # Quit
                clear
                return
                ;;
        esac
    done
}