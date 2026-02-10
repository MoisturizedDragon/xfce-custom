#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Enable System Services

systemctl enable podman.socket

#### Container image signature verification

# Install cosign public key
install -Dm0644 /ctx/signing/policy.json /etc/containers/policy.json
install -Dm0644 /ctx/signing/registries.d/xfce-custom.yaml /etc/containers/registries.d/xfce-custom.yaml
install -Dm0644 /ctx/signing/registries.d/quay.io-toolbx-images.yaml /etc/containers/registries.d/quay.io-toolbx-images.yaml
install -Dm0644 /ctx/cosign.pub /etc/pki/containers/cosign.pub
install -Dm0644 /ctx/signing/quay.io-toolbx-images.pub /etc/pki/containers/quay.io-toolbx-images.pub
