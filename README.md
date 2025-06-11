FFmpeg Camera Switcher - README
https://via.placeholder.com/150 (Replace with your actual logo)

A Raspberry Pi-based camera switcher using FFmpeg and GPIO controls

This project allows you to switch between multiple camera inputs on a Raspberry Pi using FFmpeg for video processing and GPIO pins for hardware control.

Technologies Used

<div align="center"> <img src="https://www.raspberrypi.com/app/uploads/2022/02/COLOUR-RPi-Logo.png" width="100" alt="Raspberry Pi"> <img src="https://ffmpeg.org/ffmpeg-logo.svg" width="100" alt="FFmpeg"> <img src="https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png" width="100" alt="Git"> <img src="https://i0.wp.com/www.wiringpi.com/wp-content/uploads/2013/03/WiringPi-Logo-300.png" width="100" alt="WiringPi"> <img src="https://linuxtv.org/images/v4l2.png" width="100" alt="V4L2"> </div>

Installation

Run the following command to install all dependencies and set up the camera switcher:

bash
sudo apt-get update && sudo apt-get install -y git ffmpeg alsa-utils libasound2-dev v4l-utils libv4l-dev raspberrypi-kernel-headers wiringpi && git clone https://github.com/LabToys/ffmpeg-camera-switcher.git && cd ffmpeg-camera-switcher && chmod +x install.sh camera_switcher.sh gpio_control.sh && sudo ./install.sh && sudo ./camera_switcher.sh
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
Documentation

For detailed setup instructions and configuration options, please visit the project documentation.

Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

License

MIT
