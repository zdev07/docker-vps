#!/bin/bash

# Clear locks
rm -rf /tmp/.X*

# Start VNC Server (low resolution to save memory)
vncserver :1 -geometry 1024x768 -depth 16

# Start noVNC on Port 8080 (Standard for Koyeb)
websockify --web /usr/share/novnc 8080 localhost:5901 &

sleep 5

# Launch Firefox in optimized mode
# --no-remote and memory limits help 512MB RAM last longer
DISPLAY=:1 firefox-esr https://studio.firebase.google.com/your-url \
    --width 1024 --height 768 --no-remote &

# Keep-alive loop
while true
do
    echo "Koyeb VPS Heartbeat - $(date)"
    # Auto-restart Firefox if it crashes due to low memory
    pgrep firefox-esr > /dev/null || DISPLAY=:1 firefox-esr https://studio.firebase.google.com/your-url --no-remote &
    sleep 60
done
