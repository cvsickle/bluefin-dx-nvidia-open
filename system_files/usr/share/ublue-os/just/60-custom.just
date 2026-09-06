# 60-custom.just

# Install CVSickle curated app set.
install-cvsickle-apps:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    set -euo pipefail

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. It is provisioned on first boot;"
        echo "if this is a fresh install, reboot and try again."
        exit 1
    fi

    APPS_DIR="${HOME}/.local/share/applications"
    ICONS_DIR="${HOME}/.local/share/icons"
    mkdir -p "${APPS_DIR}" "${ICONS_DIR}"

    echo "Installing lazydocker..."
    brew install jesseduffield/lazydocker/lazydocker

    LAZYDOCKER_BIN="$(command -v lazydocker)"

    echo "Downloading icon..."
    curl -fsSL --retry 3 \
        "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/podman.svg" \
        -o "${ICONS_DIR}/podman.svg"

    echo "Writing desktop entry..."
    cat > "${APPS_DIR}/lazydocker.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=Lazydocker
    Comment=Terminal UI for Docker and Podman
    Icon=${ICONS_DIR}/podman.svg
    TryExec=${LAZYDOCKER_BIN}
    Exec=${LAZYDOCKER_BIN}
    Terminal=true
    Categories=Development;
    StartupNotify=false
    Keywords=docker;podman;containers;terminal;compose;
    EOF

    update-desktop-database "${APPS_DIR}" || true
    echo "Done."

# Remove cvsickle's curated app set
uninstall-cvsickle-apps:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    set -euo pipefail

    APPS_DIR="${HOME}/.local/share/applications"
    ICONS_DIR="${HOME}/.local/share/icons"

    CONFIRM=$(ugum choose "Yes" "No" --header "Remove cvsickle apps and their launchers?")
    [[ "${CONFIRM}" == "Yes" ]] || exit 0

    if command -v brew >/dev/null 2>&1; then
        brew uninstall jesseduffield/lazydocker/lazydocker || true
    fi

    rm -f "${APPS_DIR}/lazydocker.desktop"
    rm -f "${ICONS_DIR}/Podman.svg"

    update-desktop-database "${APPS_DIR}" || true
    echo "Removed."
