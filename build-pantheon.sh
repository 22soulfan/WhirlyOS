#!/bin/bash
# WhirlyOS v1.1 - AstraShell (Pantheon) Build Script
# Target: elementaryOS ISO (Ubuntu-based)
# Mission: "Elegant, high-tech, and ambassador-class UI."
set -e

# --- STEP 0: ENVIRONMENT ---
export DEBIAN_FRONTEND=noninteractive
echo "🌌 Building WhirlyOS 'AstraShell' (Pantheon) Edition..."

# --- STEP 1: REPOSITORY UPDATES & CORE APPS ---
apt update
# Installing the educational suite and essential WhirlyOS tools
apt install -y git neofetch plymouth-themes dconf-cli \
               gcompris-qt scratch3 tuxmath tuxpaint \
               vlc chromium-browser firefox-esr

# --- STEP 2: WHIRLYOS BRANDING & LOGO REPLACEMENT ---
echo "🌠 Setting up galactic branding..."

# Define paths
LOGO_SOURCE="/root/WhirlyOS/branding/whirlyos.png"
mkdir -p /usr/share/whirlyos

# 1. System-wide Logo Replacement
if [ -f "$LOGO_SOURCE" ]; then
    echo "🎨 Replacing elementaryOS logos with WhirlyOS..."
    cp "$LOGO_SOURCE" /usr/share/whirlyos/logo-main.png
    
    # Replace distributor logos for App Menu and System Settings
    for size in 16 24 32 48 64 128 256; do
        ICON_DEST="/usr/share/icons/hicolor/${size}x${size}/apps/distributor-logo.png"
        mkdir -p "$(dirname "$ICON_DEST")"
        cp "$LOGO_SOURCE" "$ICON_DEST"
        
        # Overwrite elementary theme specifically
        ELEM_PATH="/usr/share/icons/elementary/places/${size}"
        if [ -d "$ELEM_PATH" ]; then
            cp "$LOGO_SOURCE" "$ELEM_PATH/distributor-logo.png"
            rm -f "$ELEM_PATH/distributor-logo.svg" # Force use of our PNG
        fi
    done
    gtk-update-icon-cache /usr/share/icons/hicolor || true
    gtk-update-icon-cache /usr/share/icons/elementary || true
else
    echo "⚠️ Warning: whirlyos.png not found at $LOGO_SOURCE"
fi

# 2. Neofetch ASCII setup
if [ -f "/root/WhirlyOS/logo.txt" ]; then
    cp /root/WhirlyOS/logo.txt /usr/share/whirlyos/logo.txt
else
    echo "WhirlyOS" > /usr/share/whirlyos/logo.txt
fi

mkdir -p /etc/neofetch
cat <<EOF > /etc/neofetch/config.conf
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "DE" de
    info "Memory" memory
}
image_backend="ascii"
image_source="/usr/share/whirlyos/logo.txt"
ascii_colors=(4 7)
EOF

echo "alias neofetch='neofetch --config /etc/neofetch/config.conf'" >> /etc/bash.bashrc
echo "neofetch" >> /etc/skel/.bashrc

# --- STEP 3: ASTRASHELL VISUALS (.jpg version) ---
echo "🖼️ Applying AstraShell UI overrides..."
BG_DIR="/usr/share/wallpapers/whirlyos"
mkdir -p "$BG_DIR"

# Copy the JPG wallpaper
cp /root/WhirlyOS/whirlyos-official-wallpaper.jpg "$BG_DIR/" 2>/dev/null || true

# Pantheon/Gala Specific Settings (via GSchema)
cat <<EOF > /usr/share/glib-2.0/schemas/99_astrashell.gschema.override
[org.gnome.desktop.background]
picture-uri='file://$BG_DIR/whirlyos-official-wallpaper.jpg'
picture-options='zoom'

[io.elementary.desktop.wingpanel]
use-transparency=true

[org.pantheon.desktop.gala.appearance]
button-layout='close:menu'

[net.launchpad.plank.dock.settings]
icon-size=48
theme='Transparent'
hide-mode=1
EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

# --- STEP 4: CLEANUP ---
echo "🧹 Final cleanup..."
apt purge -y elementary-wallpapers elementary-icon-theme-dark || true
apt autoremove -y

echo "------------------------------------------------"
echo "✅ WhirlyOS AstraShell (Pantheon) Build Complete!"
echo "------------------------------------------------"

# Test Neofetch display
neofetch --config /etc/neofetch/config.conf
