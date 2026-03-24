#!/bin/bash
# WhirlyOS v1.1 Public Beta - Color Synced Build
set -e

echo "🚀 Starting WhirlyOS 'Boom' Build..."

# --- STEP 0: RESOLVE APT CONFLICTS ---
echo "🛡️ Clearing APT repository conflicts..."
rm -f /etc/apt/sources.list.d/vscode.list /etc/apt/sources.list.d/vscode.sources
rm -f /etc/apt/keyrings/packages.microsoft.gpg /usr/share/keyrings/microsoft.gpg

# --- STEP 1: UPDATE SYSTEM ---
echo "🌐 Updating package lists..."
apt update
apt install -y git make plymouth plymouth-themes curl

# --- STEP 2: NEOFETCH FROM GITHUB ---
echo "📦 Installing latest Neofetch from GitHub..."
rm -rf /tmp/neofetch
git clone https://github.com/dylanaraps/neofetch.git /tmp/neofetch
cd /tmp/neofetch && make install && cd -

# --- STEP 3: BRANDING & LOGO ---
echo "🎨 Applying WhirlyOS Branding..."

# 1. Move the logo to a public system directory so students can see it
# (Assuming your logo.txt is currently in the folder where you run the script)
mkdir -p /usr/share/whirlyos
cp logo.txt /usr/share/whirlyos/logo.txt || echo "⚠️ logo.txt not found in current directory!"

# 2. Create the global Neofetch configuration
mkdir -p /etc/neofetch
cat <<EOF > /etc/neofetch/config.conf
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "Terminal" term
    info "Memory" memory
}
image_backend="ascii"
image_source="/usr/share/whirlyos/logo.txt"
# Colors: 6 (Cyan), 7 (White)
ascii_colors=(6 7)
EOF

# 3. FIX: Create a system-wide ALIAS so typing 'neofetch' always uses your config
# We put this in /etc/bash.bashrc so it applies to EVERY user automatically
cat <<EOF >> /etc/bash.bashrc

# WhirlyOS Custom Neofetch Alias
alias neofetch='neofetch --config /etc/neofetch/config.conf'
EOF

# 4. Ensure it runs automatically on login for the 'Student' user
# Adding it to /etc/skel ensures every NEW user gets this behavior
echo "neofetch" >> /etc/skel/.bashrc

# --- STEP 4: WALLPAPER SETUP ---
echo "🖼️ Migrating Wallpapers..."
BG_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$BG_DIR"

# Copy default images from main folder
cp /root/WhirlyOS/whirlyos-official-wallpaper.jpg "$BG_DIR/"
cp /root/WhirlyOS/whirlyos-wallpaper.png "$BG_DIR/"

# Copy extra wallpapers from sub-folder
cp /root/WhirlyOS/wallpapers/*.jpg "$BG_DIR/" 2>/dev/null || true

# Register wallpapers in GNOME menu
mkdir -p /usr/share/gnome-background-properties
cat <<EOF > /usr/share/gnome-background-properties/whirlyos.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper><name>WhirlyOS Official</name><filename>$BG_DIR/whirlyos-official-wallpaper.jpg</filename><options>zoom</options></wallpaper>
  <wallpaper><name>Carebit Garden</name><filename>$BG_DIR/carebit_garden.jpg</filename><options>zoom</options></wallpaper>
  <wallpaper><name>Pixos Legacy</name><filename>$BG_DIR/great_before_pixos.jpg</filename><options>zoom</options></wallpaper>
  <wallpaper><name>Luxi Study</name><filename>$BG_DIR/luxi_study_glow.jpg</filename><options>zoom</options></wallpaper>
  <wallpaper><name>Pixi Forest</name><filename>$BG_DIR/pixi_forest.jpg</filename><options>zoom</options></wallpaper>
  <wallpaper><name>Wave Ocean</name><filename>$BG_DIR/wave_ocean_deck.jpg</filename><options>zoom</options></wallpaper>
</wallpapers>
EOF

# Set Default Wallpaper via GSchema
cat <<EOF > /usr/share/glib-2.0/schemas/99_whirlyos.gschema.override
[org.gnome.desktop.background]
picture-uri='file://$BG_DIR/whirlyos-official-wallpaper.jpg'
picture-uri-dark='file://$BG_DIR/whirlyos-official-wallpaper.jpg'
[org.gnome.desktop.screensaver]
picture-uri='file://$BG_DIR/whirlyos-official-wallpaper.jpg'
EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

# --- STEP 5: FINAL SYSTEM SYNC ---
echo "✨ Updating Initramfs & Plymouth..."
plymouth-set-default-theme -R spinner || true
update-initramfs -u -k all

echo "------------------------------------------------"
echo "✅ WhirlyOS Build Complete!"
echo "------------------------------------------------"

# --- SHOW LOGO IMMEDIATELY AFTER COMPLETION ---
neofetch --config /etc/neofetch/config.conf
