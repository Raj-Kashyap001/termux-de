#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock >/dev/null 2>&1 || true
nohup "$HOME/start-xfce.sh" >/dev/null 2>&1 &
disown
