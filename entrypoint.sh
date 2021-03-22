#!/bin/bash

# Entrypoint

# Run the VNC Server
x11vnc -forever -rfbauth ~/.vnc/passwd

# Run noVNC
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 localhost:5901
