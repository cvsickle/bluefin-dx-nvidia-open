#!/bin/bash

set -ouex pipefail

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Install packages
dnf5 -y copr enable \
  dejan/lazygit \
  imput/helium
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
  xz \
  sassc \
  sass \
  helium-bin
dnf5 -y copr disable \
  dejan/lazygit \
  imput/helium

# Remove unnecessary packages
dnf5 -y remove \
  gnome-tour \
  malcontent-control
