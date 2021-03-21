FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV SHELL=/bin/bash

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

# Install Basic Packages
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc \
        vim firefox ttf-ubuntu-font-family ttf-wqy-zenhei  \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install Desktop
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Locales
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
    && locale-gen
ENV LANG=en_US.UTF-8

# Install VNC Server
RUN apt-get install tightvncserver xfonts-base

# Install noVNC
RUN apt -y install novnc \
    && websockify \
    && python-numpy
