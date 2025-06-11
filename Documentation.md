<div align="center"><img src="https://raw.githubusercontent.com/LabToys/ffmpeg-camera-switcher/refs/heads/main/ToyLabs_logo.png" width="50%" alt="ToyLabs Logo">
  
WORK IN PROCCESS ----- FFmpeg Camera Switcher - Documentation</div>

GitHub Documentation for FFmpeg Camera Switcher

markdown
# FFmpeg Camera Switcher 🎥⇄🎚️

**Turn your Raspberry Pi into a professional multi-camera production switcher!** This project combines 4 video inputs and 4 audio sources into a configurable grid layout with audio-activated switching capabilities.

```bash
git clone https://github.com/LabToys/ffmpeg-camera-switcher.git
cd ffmpeg-camera-switcher
chmod +x install.sh
./install.sh
Features ✨

4-Camera Video Grid - Simultaneous display of multiple camera feeds
Audio-Activated Switching - Automatically switch cameras based on audio input levels
Hardware Control - GPIO support for physical buttons, LEDs, and potentiometers
Custom Layouts - Configure resolutions, frame rates, and grid positioning
Audio Normalization - Dynamic audio leveling for consistent volume
Raspberry Pi Optimized - Uses hardware acceleration via h264_v4l2m2m
System Architecture 🧠

Diagram
Code
Installation Guide 🛠️

1. Prerequisites

Raspberry Pi 3B+/4 (OS: Raspberry Pi OS Bullseye)
2-4 USB cameras (tested with Logitech C920/C922)
Microphones or audio input devices
Optional: GPIO components (buttons, LEDs, potentiometer)
2. Setup Process

Run the interactive installer:

bash
./install.sh
The installer will guide you through:

HDMI output configuration
Audio device detection
Video input setup
GPIO pin mapping
Switching parameters
3. Dependencies

The script automatically installs:

FFmpeg with v4l2m2m hardware acceleration
ALSA utilities for audio control
v4l-utils for camera management
WiringPi for GPIO access
Configuration ⚙️

Core Settings (config.cfg)

ini
# VIDEO SETTINGS
VIDEO0="/dev/video0"
RESOLUTION0="1920x1080"
FRAMERATE0="30"

# AUDIO SETTINGS
AUDIO0="hw:1,0"
AUDIO_NORMALIZE="1"

# SWITCHING PARAMETERS
AUDIO_THRESHOLD="0.1"
MIN_SWITCH_DURATION="0.5"

# GPIO MAPPING
LED1=17
MANUAL_BUTTON=24
Customization Options

Video Layouts:
bash
# Change in camera_switcher.sh:
[cam0][cam1][cam2][cam3]xstack=inputs=4:layout=0_0|w0_0|0_h0|w0_h0
Supported layouts: 0_0|w0_0|0_h0|w0_h0 (2x2 grid), 0_0|w0_0 (side-by-side)
Audio Processing:
Enable/disable normalization in config
Adjust RMS threshold for activation
Usage Instructions 🚀

Starting the Switcher

bash
./camera_switcher.sh
Control Methods:

Automatic Switching:
Camera switches based on audio input levels
Configure threshold in config.cfg
Manual Control:
Press GPIO button to cycle cameras
Active camera highlighted via LED
Hybrid Mode:
Use potentiometer to blend between auto/manual
Output Options:

HDMI Display - Real-time preview
Stream Recording (Add to FFmpeg command):
bash
-f segment -segment_time 900 %Y%m%d%H%M%S.mkv
GPIO Reference 🔌

Component	Default Pin	Function
LED1-4	GPIO 17-20	Camera activity indicators
MODE_SWITCH	GPIO 22	Auto/manual toggle
MANUAL_BUTTON	GPIO 24	Manual camera selection
POTENTIOMETER	GPIO 26	Switching sensitivity control
Troubleshooting 🐛

Issue	Solution
No video devices detected	Check v4l2-ctl --list-devices
Audio sync issues	Adjust buffer sizes in ALSA configuration
High CPU usage	Lower resolutions/frame rates
GPIO not responding	Verify wiring with gpio readall
Optimization Tips 🚀

Use MJPEG cameras to reduce CPU load
Lower resolutions (1280x720 recommended)
Enable hardware encoding:
bash
-c:v h264_v4l2m2m
Reduce frame rates to 15-25 FPS
Contributing 👥

Fork repository
Create feature branch (git checkout -b feature)
Commit changes (git commit -am 'Add feature')
Push to branch (git push origin feature)
Open pull request
License 📄

MIT License - See LICENSE for details
