# Various Verification Commands

## Image Build - Local

To build the image locally to verify the Containerfile and build scripts:

```bash
sudo just build
```

## Justfile Formatting

To ensure proper formatting of just files:

### Justfile

```bash
just -f Justfile --fmt
```

### 60-custom.just Formatting

```bash
just -f ./system_files/usr/share/ublue-os/just/60-custom.just --fmt
```
