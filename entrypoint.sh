#!/bin/bash

# Entrypoint

# Use a Xvfb Virtual Display
Xvfb :0 -screen 0 1024x768x24 &
export DISPLAY=:0

# Run the VNC Server
x11vnc -forever -rfbauth ~/.vnc/passwd &

# Run noVNC
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 0.0.0.0:5900 &

# Expose
yarn global add localtunnel
lt --port 6080
