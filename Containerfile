FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/base-main:latest

RUN dnf5 install -y \
    @xfce-desktop \
    @xfce-apps \
    @xfce-extra-plugins \
    fedora-release-xfce \
    lightdm \
    lightdm-gtk \
    gnome-keyring-pam \
    xdg-desktop-portal-gtk \
    xclip \
    --exclude=abrt-desktop \
    --exclude=dnfdragora-updater \
    --exclude=claws-mail \
    --exclude='claws-mail-plugins-*' \
    --exclude=catfish \
    --exclude=geany \
    --exclude=pidgin \
    --exclude=seahorse \
    --exclude=transmission \
    --exclude=fros-recordmydesktop \
    --exclude=tumbler \
    --exclude=NetworkManager-fortisslvpn-gnome \
    --exclude=NetworkManager-iodine-gnome \
    --exclude=NetworkManager-l2tp-gnome \
    --exclude=NetworkManager-libreswan-gnome \
    --exclude=NetworkManager-sstp-gnome \
    --exclude=NetworkManager-strongswan-gnome \
    --exclude=alsa-utils \
    --exclude=firewall-config \
    --exclude=openssh-askpass \
    --exclude=vim-enhanced \
    && dnf5 clean all

RUN systemctl enable lightdm && \
    systemctl set-default graphical.target

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
