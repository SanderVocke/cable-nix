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

## Disclaimer

- I hope someone finds this as useful as myself.
- I take no credit for the software being packaged.
- I also take no credit for the creation of these package scripts, as they were mostly AI-generated given the Arch repositories' PKGBUILDs.
