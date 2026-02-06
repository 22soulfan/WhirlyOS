#!/bin/bash
# ---------------------------------------------------------
# WhirlyOS v1 Gibberlink - SoulFrame Edition Build Script
# ---------------------------------------------------------
set -e 

echo "🚀 Starting the WhirlyOS 'Boom' Build..."

# 1. UPDATES & CORE APPS
apt-get update
apt-get install -y gimp musescore3 vlc scratch tuxmath tuxpaint gcompris-qt \
                   neofetch git wget curl dconf-cli plymouth plymouth-themes

# 2. OVERWRITE IDENTITY
echo "whirlyos" > /etc/hostname
sed -i 's/Debian/WhirlyOS/g' /etc/os-release
sed -i 's/debian/whirlyos/g' /etc/os-release

# 3. WALLPAPERS (The 'Spark' Collection)
W_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$W_DIR"
cp ./assets/*.jpg "$W_DIR/"
cp ./assets/*.png "$W_DIR/"

# 4. GNOME UI SETTINGS
cat << 'EOF' > /usr/share/glib-2.0/schemas/10_whirlyos.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/whirlyos/whirlyos-wallpaper.png'
picture-options='zoom'

[org.gnome.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/whirlyos/great_before_pixos.jpg'

[org.gnome.desktop.interface]
gtk-theme='Adwaita-dark'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 5. BOOT SPLASH (Plymouth)
THEME_DIR="/usr/share/plymouth/themes/whirlyos"
mkdir -p "$THEME_DIR"
cp ./assets/whirlyos.png "$THEME_DIR/splash.png"

cat << 'EOF' > "$THEME_DIR/whirlyos.plymouth"
[Plymouth Theme]
Name=WhirlyOS
Description=Celestial Boot
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/whirlyos
ScriptFile=/usr/share/plymouth/themes/whirlyos/whirlyos.script
EOF

cat << 'EOF' > "$THEME_DIR/whirlyos.script"
logo_image = Image("splash.png");
logo_sprite = Sprite(logo_image);
logo_sprite.SetX(Window.GetWidth() / 2 - logo_image.GetWidth() / 2);
logo_sprite.SetY(Window.GetHeight() / 2 - logo_image.GetHeight() / 2);
EOF

update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth "$THEME_DIR/whirlyos.plymouth" 100
plymouth-set-default-theme whirlyos

# 6. LOGIN LOGO (GDM3)
mkdir -p /usr/share/icons/vendor
cp ./assets/whirlyos.png /usr/share/icons/vendor/whirlyos-logo.png
ln -sf /usr/share/icons/vendor/whirlyos-logo.png /usr/share/icons/gnome-logo-text.png

# 7. TERMINAL ASCII
mkdir -p /usr/share/whirlyos/ascii
cp ./assets/logo.txt /usr/share/whirlyos/ascii/
echo "neofetch --ascii_distro /usr/share/whirlyos/ascii/logo.txt" >> /etc/skel/.bashrc

# 8. CLEANUP (Keep the 6.1GB ISO stable)
apt-get autoremove -y && apt-get clean
rm -rf /tmp/* /var/lib/apt/lists/*

echo "✅ WhirlyOS Gibberlink SoulFrame Beta is Ready!"
