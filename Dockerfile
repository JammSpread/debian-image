FROM debian

ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash

# Install Basic Packages
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils locales gpg-agent \
        mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc \
        vim ttf-wqy-zenhei  \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# Install Desktop
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# Locales
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
    && locale-gen
ENV LANG=en_US.UTF-8

# Configure VNC
RUN mkdir ~/.vnc
RUN printf '%s\n' '$PASSWORD' '$PASSWORD' 'y' | \
   script -q -c 'x11vnc -storepasswd ~/.vnc/passwd' /dev/null

# Install noVNC
RUN apt-get update \
    && apt-get -y install novnc \
    websockify \
    python-numpy \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt-get update \
    && sudo apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# Install Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENV PORT 6080

ENTRYPOINT ["/tini", "--", "/usr/bin/entrypoint.sh"]
