#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /
chmod 0755 /usr/local/bin/sync-gtk4-theme
install -d /etc/systemd/user/default.target.wants
ln -sfn /usr/lib/systemd/user/sync-gtk4-theme.service \
  /etc/systemd/user/default.target.wants/sync-gtk4-theme.service

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Install terminal packages
dnf5 -y copr enable dejan/lazygit
dnf5 -y install \
  tmux \
  neovim \
  git \
  lazygit \
  tree-sitter-cli \
  fzf \
  ripgrep \
  fd-find \
  gcc \
  gcc-c++ \
  curl \
  make \
  unzip \
  xz
dnf5 -y copr disable dejan/lazygit

# Install Catppuccin GTK themes system-wide.
theme_dir="/usr/share/themes"
catppuccin_version="v1.0.1"
catppuccin_sha256="5281b4e3d387cc14bac96c8ee20ee276209b582470f9771c15d94855f1713f81"
catppuccin_archive="Catppuccin.tar.xz"
catppuccin_url="https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme/releases/download/${catppuccin_version}/${catppuccin_archive}"

curl -fL --retry 3 -o "/tmp/${catppuccin_archive}" "${catppuccin_url}"
printf '%s  %s\n' "${catppuccin_sha256}" "/tmp/${catppuccin_archive}" | sha256sum -c -
install -d "${theme_dir}"
tar -xJf "/tmp/${catppuccin_archive}" -C "${theme_dir}"
rm -f "/tmp/${catppuccin_archive}"

# Install JetBrains Mono Nerd Font from the official Nerd Fonts release.
font_dir="/usr/share/fonts/jetbrains-mono-nerd-fonts"
font_version="v3.5.1"
font_sha256="04d5e8f903693f9dd13e16f867e994834e681eb3c72c0d337a770dcda09010cf"
font_archive="JetBrainsMono.tar.xz"
font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${font_version}/${font_archive}"

curl -fL --retry 3 -o "/tmp/${font_archive}" "${font_url}"
printf '%s  %s\n' "${font_sha256}" "/tmp/${font_archive}" | sha256sum -c -
install -d "${font_dir}"
tar -xJf "/tmp/${font_archive}" -C "${font_dir}"
find "${font_dir}" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec chmod 0644 {} +
rm -f "/tmp/${font_archive}"
fc-cache -f "${font_dir}"

# Install Helium browser
dnf5 -y copr enable imput/helium
dnf5 -y install helium-bin
dnf5 -y copr disable imput/helium

#### Example for enabling a System Unit File

systemctl enable podman.socket

# Update policy.json to include signature verification for this image
jq '.transports.docker["ghcr.io/cvsickle/bluefin-dx-nvidia-open"] = [
  {
    "type": "sigstoreSigned",
    "keyPath": "/usr/share/pki/containers/cvsickle.pub",
    "signedIdentity": {"type": "matchRepository"}
  }
]' /etc/containers/policy.json > /tmp/policy.json.tmp && \
mv /tmp/policy.json.tmp /etc/containers/policy.json