#!/bin/bash
# ---------------------------------------------------------
# WhirlyOS v1 Gibberlink - SoulFrame Workstation
# ---------------------------------------------------------
set -e 

echo "🚀 Starting the WhirlyOS 'Boom' Build with Custom Neofetch..."

# --- 1. SYSTEM & VS CODE REPO ---
apt-get update
apt-get install -y wget gpg apt-transport-https
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
rm -f packages.microsoft.gpg
apt-get update

# --- 2. CLEANUP & PURGE ---
# Clearing out the 'Tux' games and old office bits
apt-get purge -y scratch tuxmath tuxpaint gcompris-qt libreoffice-common
apt-get autoremove -y

# --- 3. INSTALL WORKSTATION SUITE ---
echo "📦 Installing MuseScore, VLC, VS Code, and Neofetch..."
apt-get install -y \
    musescore3 vlc code gimp neofetch \
    libreoffice-writer libreoffice-calc libreoffice-math libreoffice-gtk3 \
    git curl dconf-cli plymouth

# --- 4. DEPLOY ASSETS & WALLPAPER ---
W_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$W_DIR"
cp ./assets/*.jpg "$W_DIR/"
cp ./assets/*.png "$W_DIR/"

# --- 5. NEOFETCH CUSTOM LOGO CONFIG ---
echo "🎨 Setting up WhirlyOS ASCII Logo..."
mkdir -p /usr/share/whirlyos/ascii
# Copy your logo.txt to the system folder
cp ./assets/logo.txt /usr/share/whirlyos/ascii/logo.txt

# Force Neofetch to use the custom ASCII logo on every terminal launch
# We add it to /etc/skel/.bashrc so every new user gets it automatically
cat << 'EOF' >> /etc/skel/.bashrc

# WhirlyOS Terminal Greeting
if [ -f /usr/share/whirlyos/ascii/logo.txt ]; then
    neofetch --ascii /usr/share/whirlyos/ascii/logo.txt --ascii_colors 4 5
else
    neofetch
fi
EOF

# --- 6. UI & BRANDING OVERRIDES ---
echo "🆔 Applying SoulFrame Identity..."
echo "whirlyos" > /etc/hostname
sed -i 's/Debian/WhirlyOS/g' /etc/os-release

# Set official wallpaper as default
cat << 'EOF' > /usr/share/glib-2.0/schemas/10_whirlyos.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/whirlyos/whirlyos_official_wallpaper.jpg'
picture-options='zoom'
[org.gnome.desktop.interface]
gtk-theme='Adwaita-dark'
EOF
glib-compile-schemas /usr/share/glib-2.0/schemas/

# --- 7. LOGIN & SPLASH ---
# Use whirlyos.png for login branding
mkdir -p /usr/share/icons/vendor
cp ./assets/whirlyos.png /usr/share/icons/vendor/whirlyos-logo.png
ln -sf /usr/share/icons/vendor/whirlyos-logo.png /usr/share/icons/gnome-logo-text.png

# --- 8. FINAL CLEANUP ---
apt-get autoremove --purge -y && apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/*

echo "✅ WhirlyOS Gibberlink: Build Complete. Terminal Logo Active. Boom."
