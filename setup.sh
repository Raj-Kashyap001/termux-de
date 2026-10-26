#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
HOME="${HOME:-/data/data/com.termux/files/home}"

# Ensure git is available
if ! command -v git >/dev/null 2>&1; then
  pkg update -y >/dev/null 2>&1 || true
  pkg install -y git
fi

# If running via curl | bash, fetch the repo first
if [ ! -f "$PWD/drivers/libvulkan_panfrost-zenithblue.so" ]; then
  if [ ! -d "$HOME/termux-de/.git" ]; then
    git clone https://github.com/Raj-Kashyap001/termux-de.git "$HOME/termux-de"
  fi
  cd "$HOME/termux-de"
fi

echo "=== Termux Desktop Environment Setup ==="

# --- Repos ---
pkg update -y
pkg install -y x11-repo tur-repo
# glibc repo for box64/steam
pkg install -y glibc-repo

# --- Core packages ---
pkg install -y \
  xfce4 xfce4-goodies termux-x11-nightly dbus \
  mesa mesa-demos pulseaudio \
  vulkan-tools vulkan-loader-generic \
  fluent-gtk-theme fluent-icon-theme plank-reloaded lxappearance \
  zenity dialog termux-api \
  adwaita-icon-theme

# --- Optional: Steam ARM64 ---
if [ "${INSTALL_STEAM:-1}" = "1" ]; then
  echo "=== Configuring Steam ARM64 repo ==="
  if [ ! -f "$PREFIX/etc/apt/sources.list.d/steam-arm64-termux.list" ]; then
    curl -fsSL https://raw.githubusercontent.com/moio9/steam-arm64-termux/main/setup-apt-repository.sh | bash
  fi
  pkg install -y box64-glibc hangover-wine hangover-wine-steamswap hangover-wowbox64 hangover-libwow64fex 2>/dev/null || true
  pkg install -y steam-arm64 || true
  # Apply updated Valve lock (fixes manifest size mismatch)
  LOCK="$HOME/.local/share/steam-arm64-termux/reference-steamclienttermux/config/steam-arm64-bootstrap-lock.json"
  if [ -f "$LOCK" ]; then
    cp "$LOCK" "$LOCK.bak.$(date +%s)" 2>/dev/null || true
  fi
  mkdir -p "$(dirname "$LOCK")"
  if [ -f "$PWD/config/steam-arm64-bootstrap-lock.json" ]; then
    cp "$PWD/config/steam-arm64-bootstrap-lock.json" "$LOCK"
  fi
fi

# --- Install GPU drivers ---
echo "=== Installing GPU drivers ==="
mkdir -p "$HOME/drivers"
cp "$PWD/drivers/libvulkan_panfrost-zenithblue.so" "$PREFIX/lib/libvulkan_panfrost.so"
cp "$PWD/drivers/panvk_icd-zenithblue.json" "$PREFIX/share/vulkan/icd.d/panvk_icd.aarch64.json"
# Fix ICD library path
sed -i "s|/usr/local/lib64/libvulkan_panfrost.so|$PREFIX/lib/libvulkan_panfrost.so|" \
  "$PREFIX/share/vulkan/icd.d/panvk_icd.aarch64.json"

# Panfrost OpenGL driver
if [ -f "$PWD/drivers/panfrost-driver-termux.tar.xz" ]; then
  rm -rf "$HOME/panfrost"
  mkdir -p "$HOME/panfrost"
  tar -xJf "$PWD/drivers/panfrost-driver-termux.tar.xz" -C "$HOME"
fi

# --- Install scripts ---
echo "=== Installing scripts ==="
cp "$PWD/scripts/"*.sh "$HOME/"
chmod +x "$HOME"/*.sh

# --- Desktop entries ---
mkdir -p "$HOME/.local/share/applications" "$HOME/.config/autostart" "$HOME/.config"
cp "$PWD/desktop/gpu-switch.desktop" "$HOME/.local/share/applications/"
cp "$PWD/desktop/plank.desktop" "$HOME/.config/autostart/"
cp "$PWD/config/xfce-gpu.conf" "$HOME/.config/xfce-gpu.conf"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

# --- Touch-friendly XFCE defaults ---
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml" 2>/dev/null || true

# --- Shell env (Panfrost available in terminals) ---
if ! grep -q "panfrost/lib" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'BASHRC'

# Panfrost OpenGL for Mali (X11)
export LD_LIBRARY_PATH=/system/lib64:$HOME/panfrost/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export LIBGL_DRIVERS_PATH=$HOME/panfrost/lib/dri
export MESA_LOADER_DRIVER_OVERRIDE=panfrost
BASHRC
fi

echo "=== Setup complete ==="
echo "Run: ~/start-xfce.sh"
