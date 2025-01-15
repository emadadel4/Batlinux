S_Options=(
    "Edit Networks_List file" 
    "Edit Mac_List file" 
    "Get latest Update"
)
S_Descriptions=(
    "Add or update Networks"
    "Add or update Mac's"
    "Get latest update from repo"
)
S_Selected=0

# Functions
###########################################
Draw_Settings_Menu() {
    echo -e "\033[0;33m[i] Use ↑/↓ or W/S to navigate, Enter/Space to select\033[0m"
    echo ""
    
    # Display menu options with selection indicator
    for i in ${!S_Options[@]}; do
        if [ $i -eq $S_Selected ]; then
            echo -e "\e[${BatLinux[TextForg]};${BatLinux[Background]}m${BatLinux[SelectionIcon]} ${S_Options[$i]}\e[0m"
        else
            echo "${S_Options[$i]}"
        fi
    done
    
    # Display description of selected option
    echo "----------------------------------------"
    echo -e "${S_Descriptions[$S_Selected]}"
}

# Handle menu selection
Handle_Settings_Selection() {
    case $S_Selected in
        0) # maclist file
            mousepad "${BatLinux["Main_DIR"]}/${BatLinux["Mac_File"]}"
           ;;
        1) # Networks file
            mousepad "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
           ;;
        2) # Update
            clear
            echo "Getting Update.."
            curl -LO https://github.com/emadadel4/Batlinux/releases/latest/download/Batlinux.sh; chmod 777 ./Batlinux.sh; ./Batlinux.sh
            echo "Update Done!"
            ;;
    esac
}

Settings_Loop() {
    while true; do
        clear
        HEADER
        Draw_Settings_Menu
        read -rsn1 key
        case "$key" in
            $'\x1B')  # Handle arrow keys
                read -rsn2 key
                case "$key" in
                    "[A") # Up arrow
                        ((S_Selected--))
                        [ $S_Selected -lt 0 ] && S_Selected=$((${#S_Options[@]}-1))
                        ;;
                    "[B") # Down arrow
                        ((S_Selected++))
                        [ $S_Selected -ge ${#S_Options[@]} ] && S_Selected=0
                        ;;
                esac
                ;;
            [wW]) # W key - Move up
                ((S_Selected--))
                [ $S_Selected -lt 0 ] && S_Selected=$((${#S_Options[@]}-1))
                ;;
            [sS]) # S key - Move down
                ((S_Selected++))
                [ $S_Selected -ge ${#S_Options[@]} ] && S_Selected=0
                ;;
            "") # Enter key - Select option
                Handle_Settings_Selection
                ;;
            [fF]) # F key - Select option
                Handle_Settings_Selection
                ;;
            "q") # Quit
                clear
                return
            ;;
        esac
    done
}

