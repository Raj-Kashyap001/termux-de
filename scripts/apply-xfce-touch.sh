#!/data/data/com.termux/files/usr/bin/bash
# Apply touch-friendly XFCE settings (run inside an XFCE session).
sleep 4
xfconf-query -c xsettings -p /Net/ThemeName -s "Fluent" 2>/dev/null || true
xfconf-query -c xsettings -p /Net/IconThemeName -s "Fluent" 2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 13" 2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 12" 2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Adwaita" 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/theme -s "Default" 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/title_font -s "Sans Bold 13" 2>/dev/null || true
# Enlarge panel if present
for p in /panels/panel-1 /panels/panel-2; do
    xfconf-query -c xfce4-panel -p "/size" -s 52 2>/dev/null || true
    xfconf-query -c xfce4-panel -p "/icon-size" -s 32 2>/dev/null || true
done
# Plank dock autostart
mkdir -p /data/data/com.termux/files/home/.config/autostart
cat > /data/data/com.termux/files/home/.config/autostart/plank.desktop <<DESKTOP
[Desktop Entry]
Type=Application
Name=Plank
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
DESKTOP
echo "Touch-friendly XFCE settings applied."
