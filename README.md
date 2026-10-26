# Termux Desktop Environment (termux-de)

A reproducible setup for a touch-friendly XFCE desktop on Android/Termux with:
- Mali PanVK Vulkan driver (zenithblue RC4)
- Panfrost OpenGL driver (Termux X11)
- GPU driver switcher (Vulkan / Panfrost)
- Steam ARM64 (bionic) support
- Touch-friendly XFCE theme (Fluent + Plank dock)

## One-click install

```sh
curl -fsSL https://raw.githubusercontent.com/Raj-Kashyap001/termux-de/main/setup.sh | bash
```

## Manual install

1. Transfer this folder to your device (e.g. `~/termux-de`).
2. In Termux:
   ```sh
   cd ~/termux-de
   chmod +x setup.sh
   ./setup.sh
   ```
3. Launch desktop:
   ```sh
   ~/start-xfce.sh
   ```
   Or use the Termux:Widget shortcut.

## Contents
- `setup.sh` — installs packages, drivers, scripts, themes
- `scripts/` — start-xfce, start-steam-bigpicture, apply-xfce-touch, gpu-switch
- `drivers/` — PanVK (zenithblue) + Panfrost tarball
- `desktop/` — app launcher + plank autostart
- `config/` — GPU mode + updated Steam lock

## Notes
- Steam ARM64 requires the updated lock file (included) due to Valve manifest changes.
- GPU acceleration on X11 is limited: Panfrost works for X11 GL apps; Vulkan/X11 presentation is not yet available. Android-surface apps can use PanVK.
