# Cable (Nix Package)

A PyQt6 application to dynamically modify Pipewire and Wireplumber settings.

## Build Instructions

### Classic Mode
Uses `flake-compat` to build via `nix-build`.
```bash
nix-build
```

### Flake Mode
```bash
nix build
```

## Known Issues

- **Connection Manager**: The connection manager won't open (cause unknown at the moment).
- **JACK Connections**: Won't save/restore JACK connections because the `aj-snapshot` daemon is not running.
