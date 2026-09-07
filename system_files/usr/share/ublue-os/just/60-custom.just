# vim: set ft=make :
# 60-custom.just

CVSICKLE_SHARE := "/usr/share/cvsickle"

# Install CVSickle curated app set.
[group('Apps')]
install-cvsickle-apps:
    #!/usr/bin/bash
    set -euo pipefail

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. It is provisioned on first boot;"
        echo "if this is a fresh install, reboot and try again."
        exit 1
    fi

    BINDIR="$(dirname "$(command -v brew)")"
    APPS_DIR="${HOME}/.local/share/applications"
    ICONS_DIR="${HOME}/.local/share/icons"
    SRC="{{ CVSICKLE_SHARE }}"

    mkdir -p "${APPS_DIR}" "${ICONS_DIR}"

    while IFS=':' read -r pkg desktop icon; do
        [[ -z "${pkg}" || "${pkg}" =~ ^[[:space:]]*# ]] && continue

        echo "Installing ${pkg}..."
        brew install "${pkg}"

        install -m 0644 "${SRC}/icons/${icon}" "${ICONS_DIR}/${icon}"

        sed -e "s|@BINDIR@|${BINDIR}|g" \
            -e "s|@ICONS@|${ICONS_DIR}|g" \
            "${SRC}/applications/${desktop}" > "${APPS_DIR}/${desktop}"
        chmod 0644 "${APPS_DIR}/${desktop}"
    done < "${SRC}/brew.list"

    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
    echo "Done."

# Remove cvsickle's curated app set
[group('Apps')]
uninstall-cvsickle-apps:
    #!/usr/bin/bash
    set -euo pipefail

    APPS_DIR="${HOME}/.local/share/applications"
    ICONS_DIR="${HOME}/.local/share/icons"
    SRC="{{ CVSICKLE_SHARE }}"

    read -rp "Remove cvsickle apps and their launchers? [y/N] " reply
    case "${reply}" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Cancelled."; exit 0 ;;
    esac

    while IFS=':' read -r pkg desktop icon; do
        [[ -z "${pkg}" || "${pkg}" =~ ^[[:space:]]*# ]] && continue

        if command -v brew >/dev/null 2>&1; then
            brew uninstall "${pkg}" || true
        fi

        rm -f "${APPS_DIR}/${desktop}" "${ICONS_DIR}/${icon}"
    done < "${SRC}/brew.list"

    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
    echo "Removed."
