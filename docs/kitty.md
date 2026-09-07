# Recommended Kitty Settings

## Theme

Set a theme that corresponds to the system theme with:

```bash
kitten theme
```

## Hide Window Decorations

Hide the window decorations by setting this in `~/.config/kitty/kitty.conf`:

```txt
hide_window_decorations yes
```

## Disable Closing Confirmations

Disable the confirmation prompt when closing a terminal window with an active process by setting this in `~/.config/kitty/kitty.conf`.

```txt
confirm_os_window_close 0
```

## Set as Default Terminal

This is taken care of with the `ujust install-cvsickle-apps` recipe, but can also be done manually by creating or editing `~/.config/xdg-terminals.list`.

```txt
kitty.desktop

```
