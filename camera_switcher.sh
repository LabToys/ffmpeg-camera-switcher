#!/bin/bash

# Load configuration
source config.cfg

# Verify 1080p output
if [ "$HDMI_MODE" == "auto" ]; then
    tvservice -p
    fbset -depth 32
    fbset -g 1920 1080 1920 1080 32
elif [ "$HDMI_MODE" == "manual" ]; then
    tvservice -e "$HDMI_MODE_SETTING"
    fbset -depth 32
    fbset -g 1920 1080 1920 1080 32
fi

# Build FFmpeg command
FFMPEG_CMD="ffmpeg "

# Add video inputs
for i in 0 1 2 3; do
    video_var="VIDEO$i"
    res_var="RESOLUTION$i"
    fps_var="FRAMERATE$i"
    
    FFMPEG_CMD+="-f v4l2 -input_format mjpeg -video_size ${!res_var} -framerate ${!fps_var} -i ${!video_var} "
done

# Add audio inputs
for i in 0 1 2 3; do
    audio_var="AUDIO$i"
    FFMPEG_CMD+="-f alsa -i ${!audio_var} "
done

# Complex filter
FFMPEG_CMD+="-filter_complex \""

# Video processing
for i in 0 1 2 3; do
    res_var="RESOLUTION$i"
    FFMPEG_CMD+="[$i:v] setpts=PTS-STARTPTS, scale=${!res_var} [cam$i]; "
done

# Audio processing
for i in 0 1 2 3; do
    if [ "$AUDIO_NORMALIZE" == "1" ]; then
        FFMPEG_CMD+="[$((i+4)):a] dynaudnorm=r=1:c=1 [a$i]; "
    else
        FFMPEG_CMD+="[$((i+4)):a] asplit [a$i][a${i}out]; "
    fi
done

# Audio analysis
FFMPEG_CMD+="[a1] astats=measure_perchannel=none:measure_overall=RMS_level, ametadata=mode=print:key=lavfi.astats.Overall.RMS_level [a1meta]; "
FFMPEG_CMD+="[a2] astats=measure_perchannel=none:measure_overall=RMS_level, ametadata=mode=print:key=lavfi.astats.Overall.RMS_level [a2meta]; "
FFMPEG_CMD+="[a3] astats=measure_perchannel=none:measure_overall=RMS_level, ametadata=mode=print:key=lavfi.astats.Overall.RMS_level [a3meta]; "

# Video mixing
FFMPEG_CMD+="[cam0][cam1][cam2][cam3] xstack=inputs=4:layout=0_0|w0_0|0_h0|w0_h0[video]; "

# Audio mixing
FFMPEG_CMD+="[a0out][a1out][a2out][a3out] amix=inputs=4[audio]\" "

# Output configuration
FFMPEG_CMD+="-map \"[video]\" -c:v h264_v4l2m2m -b:v 8M -pix_fmt yuv420p "
FFMPEG_CMD+="-map \"[audio]\" -c:a aac -b:a 192k -ac 2 "
FFMPEG_CMD+="-f sdl \"Camera Switcher\""

# Execute FFmpeg
eval $FFMPEG_CMD