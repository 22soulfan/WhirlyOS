#!/bin/bash
# WhirlyOS v1.1 - AstraShell (Pantheon) Build Script
# Target: elementaryOS ISO (Final Hardware Test Version)
set -e

export DEBIAN_FRONTEND=noninteractive
echo "🌌 Building WhirlyOS 'AstraShell' for Real Hardware..."

# --- STEP 1: APPS & REMOVALS ---
apt update
# Install WhirlyOS Suite (Minus Plymouth/Firefox as requested)
apt install -y git neofetch dconf-cli \
               gcompris-qt scratch3 tuxmath tuxpaint \
               vlc chromium-browser

# --- STEP 2: SYSTEM-WIDE LOGO REPLACEMENT ---
LOGO_SOURCE="/root/WhirlyOS/branding/whirlyos.png"
if [ -f "$LOGO_SOURCE" ]; then
    echo "🎨 Overwriting elementaryOS branding..."
    for size in 16 24 32 48 64 128 256; do
        ICON_DEST="/usr/share/icons/hicolor/${size}x${size}/apps/distributor-logo.png"
        mkdir -p "$(dirname "$ICON_DEST")"
        cp "$LOGO_SOURCE" "$ICON_DEST"
        
        ELEM_PATH="/usr/share/icons/elementary/places/${size}"
        if [ -d "$ELEM_PATH" ]; then
            cp "$LOGO_SOURCE" "$ELEM_PATH/distributor-logo.png"
            rm -f "$ELEM_PATH/distributor-logo.svg" 
        fi
    done
    gtk-update-icon-cache /usr/share/icons/hicolor || true
    gtk-update-icon-cache /usr/share/icons/elementary || true
    
    # LOCK THE BRANDING: This prevents updates from reverting the logo
    apt-mark hold elementary-icon-theme
fi

# --- STEP 3: NEOFETCH & BASH BRANDING ---
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

# --- STEP 4: ASTRASHELL UI (JPG WALLPAPER) ---
BG_DIR="/usr/share/wallpapers/whirlyos"
mkdir -p "$BG_DIR"
cp /root/WhirlyOS/whirlyos-official-wallpaper.jpg "$BG_DIR/" 2>/dev/null || true

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

# --- STEP 5: CLEANUP ---
# Purge the stuff you don't want
apt purge -y elementary-wallpapers elementary-icon-theme-dark \
           plymouth plymouth-themes firefox-esr firefox || true
apt autoremove -y

echo "✅ AstraShell is ready for real hardware!"
