#!/bin/bash

set -ouex pipefail

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
