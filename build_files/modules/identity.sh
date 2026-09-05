#!/bin/bash

set -ouex pipefail

# Set the operating system identity shown by bootc and the boot menu.
image_version="$(date -u +%Y%m%d)"
sed -i \
  -e 's/^NAME=.*/NAME="CVSickle Bluefin DX"/' \
  -e "s/^VERSION=.*/VERSION=\"${image_version}\"/" \
  -e "s/^PRETTY_NAME=.*/PRETTY_NAME=\"CVSickle Bluefin DX (${image_version})\"/" \
  /usr/lib/os-release
