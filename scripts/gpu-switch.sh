#!/data/data/com.termux/files/usr/bin/bash
export TERM=xterm-256color
TMPFILE=$(mktemp)
dialog --clear --title "GPU Driver Switch" --menu "Select GPU driver for next XFCE session:" 15 60 2 \
  1 "Vulkan (PanVK) - default" \
  2 "Panfrost OpenGL - X11 GL on GPU" 2>"$TMPFILE"
rc=$?
CHOICE=$(cat "$TMPFILE")
rm -f "$TMPFILE"
clear
[ $rc -ne 0 ] && exit 0
case "$CHOICE" in
  1) MODE=vulkan ;;
  2) MODE=panfrost ;;
  *) exit 0 ;;
esac
mkdir -p "$HOME/.config"
echo "GPU_MODE=$MODE" > "$HOME/.config/xfce-gpu.conf"
dialog --msgbox "Mode set to: $MODE\nRestart XFCE to apply." 8 40
clear
