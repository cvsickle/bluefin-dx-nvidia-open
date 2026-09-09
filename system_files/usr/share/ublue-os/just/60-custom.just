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

    if [[ ! -r "${SRC}/brew.list" ]]; then
        echo "Cannot read ${SRC}/brew.list" >&2
        exit 1
    fi

    echo "Installing brew apps..."
    mkdir -p "${APPS_DIR}" "${ICONS_DIR}"
    mapfile -t ENTRIES < "${SRC}/brew.list"

    pkg_count=0
    app_count=0

    for entry in "${ENTRIES[@]}"; do
        entry="${entry%$'\r'}"
        [[ -z "${entry//[[:space:]]/}" || "${entry}" =~ ^[[:space:]]*# ]] && continue

        IFS=':' read -r pkg desktop icon <<< "${entry}"
        pkg="${pkg//[[:space:]]/}"
        desktop="${desktop//[[:space:]]/}"
        icon="${icon//[[:space:]]/}"

        [[ -z "${pkg}" ]] && continue

        echo "Installing ${pkg}..."
        brew install "${pkg}"
        (( ++pkg_count ))

        # Skip menu/icon installation if desktop or icon fields are empty
        if [[ -z "${desktop}" || -z "${icon}" ]]; then
            continue
        fi

        install -m 0644 "${SRC}/icons/${icon}" "${ICONS_DIR}/${icon}"

        sed -e "s|@BINDIR@|${BINDIR}|g" \
            -e "s|@ICONS@|${ICONS_DIR}|g" \
            "${SRC}/applications/${desktop}" > "${APPS_DIR}/${desktop}"
        chmod 0644 "${APPS_DIR}/${desktop}"
        (( ++app_count ))
    done

    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
    echo "Done. ${pkg_count} package(s) installed, ${app_count} launcher(s) created."

# Remove cvsickle's curated app set
[group('Apps')]
uninstall-cvsickle-apps:
    #!/usr/bin/bash
    set -euo pipefail

    APPS_DIR="${HOME}/.local/share/applications"
    ICONS_DIR="${HOME}/.local/share/icons"
    SRC="{{ CVSICKLE_SHARE }}"

    if [[ ! -r "${SRC}/brew.list" ]]; then
        echo "Cannot read ${SRC}/brew.list" >&2
        exit 1
    fi

    read -rp "Remove cvsickle apps and their launchers? [y/N] " reply
    case "${reply}" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Cancelled."; exit 0 ;;
    esac

    mapfile -t ENTRIES < "${SRC}/brew.list"

    for entry in "${ENTRIES[@]}"; do
        entry="${entry%$'\r'}"
        [[ -z "${entry//[[:space:]]/}" || "${entry}" =~ ^[[:space:]]*# ]] && continue

        IFS=':' read -r pkg desktop icon <<< "${entry}"
        pkg="${pkg//[[:space:]]/}"
        desktop="${desktop//[[:space:]]/}"
        icon="${icon//[[:space:]]/}"

        [[ -z "${pkg}" ]] && continue

        if command -v brew >/dev/null 2>&1; then
            brew uninstall "${pkg}" || true
        fi

        # Skip menu/icon removal if desktop or icon fields are empty
        if [[ -z "${desktop}" || -z "${icon}" ]]; then
            continue
        fi

        rm -f "${APPS_DIR}/${desktop}" "${ICONS_DIR}/${icon}"
    done

    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
    echo "Removed."
