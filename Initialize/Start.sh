declare -A BatLinux
BatLinux=(
    ["Main_DIR"]="BatLinux"
    ["HandShakes_DIR"]="Handshakes"
    ["Mac_File"]="Mac_List.csv"
    ["Networks_File"]="Networks_List.csv"
    ["WPS_List_File"]="WPS_List.csv"
    ["Settings_File"]="Settings.csv"
    ["TextForg"]="97"
    ["Background"]="41"
    ["SelectionIcon"]=">"
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

# Check if the file exists, if not, create it
if [ ! -f "${BatLinux["Main_DIR"]}/${BatLinux["Settings_File"]}" ]; then
    echo "Option,Value" > "${BatLinux["Main_DIR"]}/${BatLinux["Settings_File"]}"
    echo "Key,null" >> "${BatLinux["Main_DIR"]}/${BatLinux["Settings_File"]}"
fi

if [ ! -f "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}" ]; then
    echo "BSSID,ESSID,Channel,WPS,Note" > "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    echo "Batlinux,C0:E3:FB:BF:F0:9E,1,No,This simple note" >> "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
    echo "Clown_Donald_trump,98:DA:C4:C7:6A:D8,8,Yes,This Bssid WPS Enabled" >> "${BatLinux["Main_DIR"]}/${BatLinux["Networks_File"]}"
fi