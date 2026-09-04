# Bluefin DX (Nvidia)

[![Build container image](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/build.yml/badge.svg)](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/build.yml) [![Dependabot Updates](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/dependabot/dependabot-updates) [![Repo sync (GitHub -> Codeberg)](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/sync_codeberg.yaml/badge.svg)](https://github.com/cvsickle/bluefin-dx-nvidia-open/actions/workflows/sync_codeberg.yaml)

This repository is a custom [bootc](https://github.com/bootc-dev/bootc) image, built on [Bluefin-DX](https://github.com/ublue-os/bluefin).

This repository is based on the [ublue-os/image-template](https://github.com/ublue-os/image-template) repo. See there for information on how to create your own.

## Changes made

The following packages were added:

- [Tmux](https://github.com/tmux/tmux)
- Everything needed for [LazyVim](https://github.com/lazyvim/lazyvim)
  - [Neovim](https://github.com/neovim/neovim)
  - [LazyGit](https://github.com/jesseduffield/lazygit)
  - JetBrains Mono Nerd Font from [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
  - Etc.
- [Helium Browser](https://github.com/imputnet/helium)

## Installation

Here is the recommened installation process.

- Flash the Stable Bluefin ISO for Nvidia GPUS from [projectbluefin.io](https://projectbluefin.io/) onto a USB.
- Boot from the USB and install Bluefin.
- Boot into Bluefin and switch it to developer mode.

```bash
# Switch to developer mode.
ujust devmode
# Reboot when done.
systemctl reboot
```

- Once in developer mode, switch to this image.

```bash
sudo bootc switch ghcr.io/cvsickle/bluefin-dx-nvidia-open:latest
# Reboot when done.
systemctl reboot
```

- Once booted into this image, enable signing verification.

```bash
sudo bootc switch --enforce-container-policy ghcr.io/cvsickle/bluefin-dx-nvidia-open:latest
```

## Repository Mirrors

- GitHub - [https://github.com/cvsickle/bluefin-dx-nvidia-open](https://github.com/cvsickle/bluefin-dx-nvidia-open)
- Codeberg - [https://codeberg.org/cvsickle/bluefin-dx-nvidia-open](https://codeberg.org/cvsickle/bluefin-dx-nvidia-open)
- Forgejo (Mirror) - [https://git.cvsickle.com/cvsickle/bluefin-dx-nvidia-open](https://git.cvsickle.com/cvsickle/bluefin-dx-nvidia-open)
