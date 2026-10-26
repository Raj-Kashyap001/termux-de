#!/data/data/com.termux/files/usr/bin/bash
# Start a Termux-X11 + XFCE4 session.

# Start the X server if not already running.
if ! pgrep -x termux-x11 >/dev/null 2>&1; then
    termux-x11 :0 >/dev/null 2>&1 &
    sleep 2
fi

# Open the Termux:X11 viewer app.
am start -n com.termux.x11/.MainActivity >/dev/null 2>&1 || true

export DISPLAY=:0

# GPU driver selection
GPU_MODE="vulkan"
if [ -f "$HOME/.config/xfce-gpu.conf" ]; then
    . "$HOME/.config/xfce-gpu.conf"
fi

if [ "$GPU_MODE" = "panfrost" ]; then
    export LD_LIBRARY_PATH=/system/lib64:$HOME/panfrost/lib
    export LIBGL_DRIVERS_PATH=$HOME/panfrost/lib/dri
    export MESA_LOADER_DRIVER_OVERRIDE=panfrost
else
    unset LD_LIBRARY_PATH LIBGL_DRIVERS_PATH MESA_LOADER_DRIVER_OVERRIDE
fi

export WSI_X11_TERMUX=1
export PANVK_KBASE_DRI3=raw

# Make the installed Mali PanVK driver discoverable for Vulkan apps.
export VK_ICD_FILENAMES="$PREFIX/share/vulkan/icd.d/panvk_icd.aarch64.json"

(sleep 6; $HOME/apply-xfce-touch.sh) &
dbus-run-session startxfce4
