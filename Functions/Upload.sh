function Upload_Handshake() {
    local key=$1
    local handshake=$2


    # Now ask if the user wants to upload the .cap file
    read -p "Do you want to upload the .cap file? (y/n): " upload_choice

    if [[ "$upload_choice" == "y" || "$upload_choice" == "Y" ]]; then

        echo "Proceeding with upload..."

        curl -F "file=@${BatLinux["Main_DIR"]}/${BatLinux["HandShakes_DIR"]}/Bebo.cap" -F "key=$key" https://wpa-sec.stanev.org/
        # Check if the upload was successful (exit status of curl)
        if [ $? -eq 0 ]; then
            echo "Upload successful!"
        else
            echo "Upload failed!"
        fi

        read -n1 -p "Press any key to continue"

    elif [[ "$upload_choice" == "n" || "$upload_choice" == "N" ]]; then
    
        echo "You chose not to upload the file."
    else
        echo "Invalid choice. Please enter 'y' or 'n'."
    fi

}