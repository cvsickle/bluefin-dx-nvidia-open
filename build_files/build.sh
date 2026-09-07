#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# Run package installation script
bash "$(dirname "$0")/modules/packages.sh"

# Run font installation script
bash "$(dirname "$0")/modules/fonts.sh"

# Run system configuration script
bash "$(dirname "$0")/modules/system.sh"

# Run signature verification script
bash "$(dirname "$0")/modules/signature.sh"

# Run cleanup script
bash "$(dirname "$0")/modules/cleanup.sh"

# Run identity script LAST so os-release changes don't get overwritten by package updates
bash "$(dirname "$0")/modules/identity.sh"