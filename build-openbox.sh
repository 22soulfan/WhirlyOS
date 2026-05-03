#!/bin/bash
# WhirlyOS v1.1 - SeaWave (Openbox) Build Script
# Target: BunsenLabs (Debian-based)
# Mission: "Minimalist, poetic, and focused."
set -e

# --- STEP 0: ENVIRONMENT ---
export DEBIAN_FRONTEND=noninteractive
echo "🌊 Building WhirlyOS 'SeaWave' (Openbox) Edition..."

# --- STEP 1: APPS & REMOVALS ---
apt update
# Install WhirlyOS suite (minus Firefox/Plymouth as requested)
apt install -y git neofetch dconf-cli \
               gcompris-qt scratch3 tuxmath tuxpaint \
               vlc chromium-browser

# --- STEP 2: WHIRLYOS BRANDING & LOGO ---
echo "🎨 Applying WhirlyOS Branding..."
LOGO_SOURCE="/root/WhirlyOS/branding/whirlyos.png"
mkdir -p /usr/share/whirlyos

if [ -f "$LOGO_SOURCE" ]; then
    cp "$LOGO_SOURCE" /usr/share/whirlyos/logo-main.png
    # BunsenLabs uses hicolor for the menu icons
    cp "$LOGO_SOURCE" /usr/share/icons/hicolor/64x64/apps/distributor-logo.png
    gtk-update-icon-cache /usr/share/icons/hicolor || true
fi

# Neofetch Configuration
mkdir -p /etc/neofetch
cat <<EOF > /etc/neofetch/config.conf
print_info() {
    info title
    info underline
    info "OS" distro
    info "Kernel" kernel
    info "WM" wm
    info "Memory" memory
}
image_backend="ascii"
image_source="/usr/share/whirlyos/logo.txt"
ascii_colors=(6 7) # Cyan and White for SeaWave
EOF

echo "alias neofetch='neofetch --config /etc/neofetch/config.conf'" >> /etc/bash.bashrc
echo "neofetch" >> /etc/skel/.bashrc

# --- STEP 3: OPENBOX / TINT2 OVERRIDES ---
echo "🖼️ Customizing the SeaWave Interface..."
BG_DIR="/usr/share/wallpapers/whirlyos"
mkdir -p "$BG_DIR"
cp /root/WhirlyOS/whirlyos-official-wallpaper.jpg "$BG_DIR/" 2>/dev/null || true

# BunsenLabs uses 'nitrogen' or 'bl-wallpaper' for backgrounds.
# We will force the default for new users in the autostart.
mkdir -p /etc/skel/.config/openbox
cat <<EOF >> /etc/skel/.config/openbox/autostart
# WhirlyOS SeaWave Autostart
feh --bg-fill $BG_DIR/whirlyos-official-wallpaper.jpg &
EOF

# --- STEP 4: CLEANUP & PURGE ---
echo "🧹 Removing unwanted packages..."
apt purge -y plymouth plymouth-themes firefox-esr firefox \
           bunsen-wallpapers || true
apt autoremove -y

echo "------------------------------------------------"
echo "✅ WhirlyOS SeaWave (Openbox) Build Complete!"
echo "------------------------------------------------"

# Preview
neofetch --config /etc/neofetch/config.conf
