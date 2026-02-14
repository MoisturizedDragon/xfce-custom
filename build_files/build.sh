#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
dnf5 install -y tmux rofi slock distrobox vim

# VS Code from Microsoft repo
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/vscode.repo
dnf5 -y install --enablerepo=code code

#### Enable System Services

systemctl enable podman.socket

#### Configure Flathub

mkdir -p /etc/flatpak/remotes.d
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

#### Bootc update timer (fetch-only, no auto-reboot)

install -Dm0644 /ctx/systemd/bootc-fetch.service /usr/lib/systemd/system/bootc-fetch.service
install -Dm0644 /ctx/systemd/bootc-fetch.timer /usr/lib/systemd/system/bootc-fetch.timer
systemctl mask bootc-fetch-apply-updates.timer
systemctl enable bootc-fetch.timer

#### Container image signature verification

# Install cosign public key
install -Dm0644 /ctx/signing/policy.json /etc/containers/policy.json
install -Dm0644 /ctx/signing/registries.d/xfce-custom.yaml /etc/containers/registries.d/xfce-custom.yaml
install -Dm0644 /ctx/signing/registries.d/quay.io-toolbx-images.yaml /etc/containers/registries.d/quay.io-toolbx-images.yaml
install -Dm0644 /ctx/cosign.pub /etc/pki/containers/cosign.pub
install -Dm0644 /ctx/signing/quay.io-toolbx-images.pub /etc/pki/containers/quay.io-toolbx-images.pub
