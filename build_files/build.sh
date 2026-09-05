#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# Make module scripts executable
chmod +x "$(dirname "$0")/modules"/*.sh

# Run identity script
"$(dirname "$0")/modules/identity.sh"

# Run package installation script
"$(dirname "$0")/modules/packages.sh"

# Run font installation script
"$(dirname "$0")/modules/fonts.sh"

# Run system configuration script
"$(dirname "$0")/modules/system.sh"

# Run signature verification script
"$(dirname "$0")/modules/signature.sh"