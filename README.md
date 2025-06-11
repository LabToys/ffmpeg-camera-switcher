FFmpeg Camera Switcher - README
https://via.placeholder.com/150 (Replace with your actual logo)

A Raspberry Pi-based camera switcher using FFmpeg and GPIO controls

This project allows you to switch between multiple camera inputs on a Raspberry Pi using FFmpeg for video processing and GPIO pins for hardware control.

Technologies Used

<div align="center"> <img src="https://upload.wikimedia.org/wikipedia/commons/d/dd/Raspberry_Pi_Logo.svg" width="100" alt="Raspberry Pi"> <img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/Ffmpeg_icon.svg" width="100" alt="FFmpeg"> <img src="https://upload.wikimedia.org/wikipedia/commons/f/f4/Git_logo.svg" width="100" alt="Git"> <img src="https://upload.wikimedia.org/wikipedia/commons/9/9e/WiringPi-Logo.png" width="100" alt="WiringPi"> <img src="https://upload.wikimedia.org/wikipedia/commons/8/87/V4L2_Logo.png" width="100" alt="V4L2"> </div>
Installation

Run the following command to install all dependencies and set up the camera switcher:



sudo apt-get update && sudo apt-get install -y git ffmpeg alsa-utils libasound2-dev v4l-utils libv4l-dev raspberrypi-kernel-headers wiringpi && git clone https://github.com/toylabs/ffmpeg-camera-switcher.git && cd ffmpeg-camera-switcher && chmod +x install.sh camera_switcher.sh gpio_control.sh && sudo ./install.sh && sudo ./camera_switcher.sh
Features

Switch between multiple camera inputs seamlessly
GPIO hardware control interface
FFmpeg-based video processing
Optimized for Raspberry Pi hardware
Requirements

Raspberry Pi (3/4 recommended)
Raspberry Pi OS (latest)
Compatible USB cameras or Pi Camera modules
Basic GPIO components (buttons, LEDs, etc.)
Usage

After installation, the system will be ready to use. Configure your camera sources in the configuration file and use the GPIO controls to switch between them.

Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

License

MIT

*© 2023 ToyLabs - Innovative Raspberry Pi Projects*
