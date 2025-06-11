#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default config
CONFIG_FILE="config.cfg"
TEMP_CONFIG="config.temp"

# Initialize temp config
echo "# FFmpeg Camera Switcher Configuration" > $TEMP_CONFIG

# Function to display menu
show_menu() {
    clear
    echo -e "${GREEN}FFmpeg Camera Switcher Setup${NC}"
    echo "1. Configure HDMI Output"
    echo "2. Configure Audio Devices"
    echo "3. Configure Video Inputs"
    echo "4. Configure GPIO Pins"
    echo "5. Configure Switching Parameters"
    echo "6. Review Configuration"
    echo "7. Install with Current Configuration"
    echo "8. Exit"
    echo -n "Choose an option [1-8]: "
}

# Function to detect HDMI devices
detect_hdmi() {
    echo -e "\n${YELLOW}Detecting HDMI displays...${NC}"
    tvservice -l
    echo ""
    echo "Possible options:"
    echo "1. Auto configure (recommended)"
    echo "2. Manual HDMI mode setting"
    echo "3. Keep current settings"
    echo -n "Choose HDMI configuration [1-3]: "
    read choice
    
    case $choice in
        1)
            tvservice -p
            fbset -depth 32
            fbset -g 1920 1080 1920 1080 32
            echo "HDMI_MODE=auto" >> $TEMP_CONFIG
            ;;
        2)
            echo -n "Enter HDMI mode (e.g., 'DMT 82' for 1080p): "
            read hdmi_mode
            tvservice -e "$hdmi_mode"
            fbset -depth 32
            fbset -g 1920 1080 1920 1080 32
            echo "HDMI_MODE=manual" >> $TEMP_CONFIG
            ;;
        *)
            echo "HDMI_MODE=current" >> $TEMP_CONFIG
            ;;
    esac
}

# Function to detect audio devices
detect_audio() {
    echo -e "\n${YELLOW}Detecting audio devices...${NC}"
    arecord -l | grep card
    echo ""
    
    for i in 0 1 2 3; do
        echo "Select audio device for Camera $i:"
        arecord -l | grep card
        echo -n "Enter card number (e.g., 1) for Camera $i: "
        read card_num
        echo -n "Enter device number (e.g., 0) for Camera $i: "
        read device_num
        echo "AUDIO$i=hw:$card_num,$device_num" >> $TEMP_CONFIG
    done
    
    # Output audio
    aplay -l | grep card
    echo -n "Enter output audio device (e.g., hw:1,0): "
    read audio_out
    echo "AUDIO_OUT=$audio_out" >> $TEMP_CONFIG
}

# Function to detect video inputs
detect_video() {
    echo -e "\n${YELLOW}Detecting video devices...${NC}"
    v4l2-ctl --list-devices
    
    for i in 0 1 2 3; do
        echo -n "Enter video device path for Camera $i (e.g., /dev/video0): "
        read video_dev
        echo "VIDEO$i=$video_dev" >> $TEMP_CONFIG
        
        # Test resolution
        echo -e "${YELLOW}Testing supported resolutions for $video_dev...${NC}"
        v4l2-ctl -d $video_dev --list-formats-ext | grep -A 10 '1920x1080'
        
        echo "Select resolution for Camera $i:"
        echo "1. 1920x1080 (1080p)"
        echo "2. 1280x720 (720p)"
        echo "3. Other (manual input)"
        echo -n "Choose [1-3]: "
        read res_choice
        
        case $res_choice in
            1)
                echo "RESOLUTION$i=1920x1080" >> $TEMP_CONFIG
                echo "FRAMERATE$i=30" >> $TEMP_CONFIG
                ;;
            2)
                echo "RESOLUTION$i=1280x720" >> $TEMP_CONFIG
                echo "FRAMERATE$i=60" >> $TEMP_CONFIG
                ;;
            3)
                echo -n "Enter width: "
                read width
                echo -n "Enter height: "
                read height
                echo -n "Enter framerate: "
                read fps
                echo "RESOLUTION$i=${width}x${height}" >> $TEMP_CONFIG
                echo "FRAMERATE$i=$fps" >> $TEMP_CONFIG
                ;;
        esac
    done
}

# Function to configure GPIO
configure_gpio() {
    echo -e "\n${YELLOW}Current GPIO pin usage:${NC}"
    gpio readall
    
    echo -e "\n${YELLOW}Configure GPIO pins:${NC}"
    pins=("LED1" "LED2" "LED3" "LED4" "MODE_SWITCH" "MANUAL_BUTTON" "POTENTIOMETER")
    descriptions=(
        "LED for Camera 1" 
        "LED for Camera 2"
        "LED for Camera 3"
        "LED for Camera 4"
        "Mode switch (voice/beat)"
        "Manual override button"
        "Potentiometer for speed control"
    )
    
    for i in ${!pins[@]}; do
        echo -n "Enter BCM pin number for ${descriptions[$i]} (current ${pins[$i]}): "
        read pin_num
        echo "${pins[$i]}=$pin_num" >> $TEMP_CONFIG
    done
}

# Function to configure switching
configure_switching() {
    echo -e "\n${YELLOW}Configure switching parameters:${NC}"
    
    echo -n "Enter audio activation threshold (0.01-1.0, default 0.1): "
    read threshold
    echo "AUDIO_THRESHOLD=${threshold:-0.1}" >> $TEMP_CONFIG
    
    echo -n "Enter minimum switch duration in seconds (0.1-5.0, default 0.5): "
    read min_duration
    echo "MIN_SWITCH_DURATION=${min_duration:-0.5}" >> $TEMP_CONFIG
    
    echo -n "Enable audio normalization? [y/N]: "
    read normalize
    if [[ "$normalize" =~ ^[Yy] ]]; then
        echo "AUDIO_NORMALIZE=1" >> $TEMP_CONFIG
    else
        echo "AUDIO_NORMALIZE=0" >> $TEMP_CONFIG
    fi
}

# Function to review config
review_config() {
    clear
    echo -e "${GREEN}Current Configuration:${NC}"
    echo "--------------------------------"
    cat $TEMP_CONFIG
    echo "--------------------------------"
    echo -n "Press Enter to continue..."
    read
}

# Function to install
install_software() {
    echo -e "\n${YELLOW}Installing dependencies...${NC}"
    sudo apt-get update
    sudo apt-get install -y ffmpeg \
                           alsa-utils \
                           libasound2-dev \
                           v4l-utils \
                           libv4l-dev \
                           raspberrypi-kernel-headers \
                           wiringpi
    
    echo -e "\n${YELLOW}Setting up udev rules...${NC}"
    # Create consistent device naming
    for i in 0 1 2 3; do
        video_var="VIDEO$i"
        video_dev=${!video_var}
        vendor_id=$(udevadm info --name=$video_dev | grep ID_VENDOR_ID | cut -d= -f2)
        product_id=$(udevadm info --name=$video_dev | grep ID_MODEL_ID | cut -d= -f2)
        
        if [[ -n "$vendor_id" && -n "$product_id" ]]; then
            echo "SUBSYSTEM==\"video4linux\", ATTRS{idVendor}==\"$vendor_id\", ATTRS{idProduct}==\"$product_id\", SYMLINK+=\"video_cam$i\"" | sudo tee -a /etc/udev/rules.d/99-camera.rules
        fi
    done
    
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    
    echo -e "\n${YELLOW}Finalizing configuration...${NC}"
    mv $TEMP_CONFIG $CONFIG_FILE
    
    echo -e "\n${GREEN}Installation complete!${NC}"
    echo "Run ./camera_switcher.sh to start the system"
}

# Main menu loop
while true; do
    source $TEMP_CONFIG 2>/dev/null
    show_menu
    read choice
    
    case $choice in
        1) detect_hdmi ;;
        2) detect_audio ;;
        3) detect_video ;;
        4) configure_gpio ;;
        5) configure_switching ;;
        6) review_config ;;
        7) 
            review_config
            echo -n "Proceed with installation? [y/N]: "
            read confirm
            if [[ "$confirm" =~ ^[Yy] ]]; then
                install_software
                exit 0
            fi
            ;;
        8) exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
done