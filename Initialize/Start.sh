declare -A BatLinux
BatLinux=(
    ["Main_DIR"]="BatLinux"
    ["HandShakes_DIR"]="Handshakes"
    ["Mac_File"]="Mac_List.csv"
    ["Networks_File"]="Networks_List.csv"
    ["WPS_List_File"]="WPS_List.csv"
)

if [ ! -d "${BatLinux["Main_DIR"]}" ]; then
    mkdir "${BatLinux["Main_DIR"]}"
fi

if [ ! -d "${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}" ]; then
    mkdir "${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}"
fi

# Check if the file exists, if not, create it
if [ ! -f "${BatLinux["Main_DIR"]}/${BatLinux["Mac_File"]}" ]; then
    echo "Device,Mac,Note" > "${BatLinux["Main_DIR"]}/${BatLinux["Mac_File"]}"
    echo "Glaxy Note,7E:27:3C:87:EF:CC,This simple note" >> "${BatLinux["Main_DIR"]}/${BatLinux["Mac_File"]}"
fi

if [ ! -f "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}" ]; then
    echo "BSSID,ESSID,Channel,WPS,Note" > "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    echo "Batlinux,C0:E3:FB:BF:F0:9E,1,No,This simple note" >> "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    echo "i have plan,98:DA:C4:C7:6A:D8,8,Yes,This Bssid WPS Enabled" >> "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
fi

Check_Dependencies() {
    
    local deps=("airgeddon")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}Missing dependencies: ${missing[*]}${NC}"
        echo "Please installing.. missing dependencies."
        apt install "${missing[@]}" -y
        read -n 1 -s -r -p "Press any key to continue..."
        return 1
    fi
    return 0
}