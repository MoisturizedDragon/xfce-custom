FROM scratch AS ctx
COPY build_files /
COPY cosign.pub /cosign.pub

FROM quay.io/fedora/fedora-bootc:43

# Remove server/cloud packages not needed for desktop
RUN dnf5 remove -y \
    WALinuxAgent-udev \
    NetworkManager-cloud-setup \
    stalld \
    sg3_utils \
    kexec-tools \
    makedumpfile \
    kdump-utils \
    console-login-helper-messages-issuegen \
    console-login-helper-messages-profile \
    sssd-client \
    sssd-ad \
    sssd-ipa \
    sssd-krb5 \
    sssd-ldap \
    libsss_sudo \
    sos \
    python3-rpm \
    iptables-services \
    && dnf5 clean all

# Install XFCE desktop environment and desktop essentials
RUN dnf5 install -y \
    @base-x \
    @xfce-desktop \
    @xfce-apps \
    @xfce-extra-plugins \
    fedora-release-xfce \
    lightdm \
    lightdm-gtk \
    gnome-keyring-pam \
    xdg-desktop-portal-gtk \
    xclip \
    firewalld \
    flatpak \
    zram-generator-defaults \
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
    --exclude=NetworkManager-fortisslvpn-gnome \
    --exclude=NetworkManager-iodine-gnome \
    --exclude=NetworkManager-l2tp-gnome \
    --exclude=NetworkManager-libreswan-gnome \
    --exclude=NetworkManager-sstp-gnome \
    --exclude=NetworkManager-strongswan-gnome \
    --exclude=alsa-utils \
    --exclude=openssh-askpass \
    --exclude=vim-enhanced \
    && dnf5 clean all

# Enable desktop services, disable SSH server
RUN systemctl enable lightdm && \
    systemctl enable firewalld && \
    systemctl disable sshd.service && \
    systemctl set-default graphical.target

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
