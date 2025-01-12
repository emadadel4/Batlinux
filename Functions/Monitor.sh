function Monitor_Mode() {

    airmon-ng check kill

    # Extract device information
    local device_info=$(dmesg | grep -i "RTL8188EU" | tail -n 1)
        
    if [ -n "$device_info" ]; then
        echo "Getting USB path of the Wi-Fi adapter..."
        USB_PATH=$(echo "$device_info" | grep -oE 'usb [0-9]+-[0-9]+(\.[0-9]+)*' | awk '{print $2}')
        echo "Found USB device at path: $USB_PATH"
    else
        echo "USB Wi-Fi adapter not found. Please check the device name."
        exit 1
    fi

    # Unbind the device
    if echo "$USB_PATH" | sudo tee /sys/bus/usb/drivers/usb/unbind > /dev/null; then
        echo "Disconnecting USB device at $USB_PATH..."
    else
        echo "Failed to disconnect USB device. Please check the USB path."
        exit 1
    fi

    sleep 5 

    # Rebind the device
    if echo "$USB_PATH" | sudo tee /sys/bus/usb/drivers/usb/bind > /dev/null; then
        echo "Reconnecting USB device..."
    else
        echo "Failed to reconnect USB device. Please check the USB path."
        exit 1
    fi

    airmon-ng start wlan0
    iwconfig
    echo -e "\033[32m[i] Successfully switched to Monitor Mode\033[0m"
    read -n1 -p "Press any key to continue"
}
