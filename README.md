FFmpeg Camera Switcher - README
https://via.placeholder.com/150 (Replace with your actual logo)

A Raspberry Pi-based camera switcher using FFmpeg and GPIO controls

This project allows you to switch between multiple camera inputs on a Raspberry Pi using FFmpeg for video processing and GPIO pins for hardware control.

Technologies Used

<div align="center"> <!-- Raspberry Pi --> <img src="https://www.raspberrypi.org/app/uploads/2018/03/RPi-Logo-Reg-SCREEN.png" width="120" alt="Raspberry Pi">  <h3> <span style="color:#c51a4a">Raspberry Pi</span> | <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/FFmpeg_Logo_new.svg/448px-FFmpeg_Logo_new.svg.png" height="40" alt="FFmpeg"> | <span style="color:#f14e32">Git</span> | WiringPi | V4L2 </h3> </div>



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
