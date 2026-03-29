#!/bin/bash
# WhirlyOS v1.1 Public Beta - SoulFrame (GNOME) Build Script
# Target: Debian Stable amd64 (64-bit)
# Mission: "Find your spark. Find your way."
set -e

# --- STEP 0: NON-INTERACTIVE SETUP ---
# Prevents the build from hanging in Cubic terminal
export DEBIAN_FRONTEND=noninteractive

echo "🌀 Starting WhirlyOS 'SoulFrame' Build (amd64)..."

# --- STEP 1: REPOSITORY & SYSTEM PREP ---
echo "🛡️ Clearing conflicts and updating package lists..."
# Remove known conflicting third-party repo files if they exist
rm -f /etc/apt/sources.list.d/vscode.list /etc/apt/sources.list.d/vscode.sources
apt update

# --- STEP 2: INSTALL CORE SUITE & DEPENDENCIES ---
echo "📦 Installing WhirlyOS Software Suite..."
# Includes Learning, Creative, and System tools
apt install -y git make curl plymouth plymouth-themes dconf-cli neofetch \
               gcompris-qt scratch3 tuxmath tuxpaint \
               gimp musescore3 vlc gnome-shell-extension-prefs \
               chromium-browser firefox-esr

# --- STEP 3: PERMANENT NEOFETCH BRANDING ---
echo "🎨 Customizing Neofetch for all users..."

# 1. Create a public directory for the WhirlyOS logo
# (Moving out of /root so standard users have permission to see it)
mkdir -p /usr/share/whirlyos

if [ -f "/root/WhirlyOS/logo.txt" ]; then
    cp /root/WhirlyOS/logo.txt /usr/share/whirlyos/logo.txt
    chmod 644 /usr/share/whirlyos/logo.txt
else
    # Fallback if the file is missing during build
    echo "WhirlyOS" > /usr/share/whirlyos/logo.txt
fi

# 2. Create the Global Configuration
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
# Cyan (6) and White (7) to match the Soul/WhirlyOS theme
ascii_colors=(6 7)
EOF

# 3. Apply System-wide Alias
# This ensures 'neofetch' always uses our config, even for new users
echo "alias neofetch='neofetch --config /etc/neofetch/config.conf'" >> /etc/bash.bashrc

# 4. Auto-run Neofetch on terminal start for all new accounts
echo "neofetch" >> /etc/skel/.bashrc

# --- STEP 4: WALLPAPER & GNOME BRANDING ---
echo "🖼️ Applying SoulFrame Aesthetics..."
BG_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$BG_DIR"

# Copy wallpapers from the cloned Git repo
cp /root/WhirlyOS/*.jpg "$BG_DIR/" 2>/dev/null || true
cp /root/WhirlyOS/*.png "$BG_DIR/" 2>/dev/null || true

# Set Default Wallpaper via GSchema Override
cat <<EOF > /usr/share/glib-2.0/schemas/99_whirlyos.gschema.override
[org.gnome.desktop.background]
picture-uri='file://$BG_DIR/whirlyos-official-wallpaper.jpg'
picture-uri-dark='file://$BG_DIR/whirlyos-official-wallpaper.jpg'

[org.gnome.desktop.screensaver]
picture-uri='file://$BG_DIR/whirlyos-official-wallpaper.jpg'

[org.gnome.shell]
favorite-apps=['chromium-browser.desktop', 'org.kde.gcompris.desktop', 'scratch3.desktop', 'org.gnome.Nautilus.desktop']
EOF

# Compile the new settings into the system
glib-compile-schemas /usr/share/glib-2.0/schemas

# --- STEP 5: CLEANUP & FINAL SYNC ---
echo "✨ Finalizing system sync..."
apt autoremove -y
update-initramfs -u -k all || true

echo "------------------------------------------------"
echo "✅ WhirlyOS SoulFrame (amd64) Build Complete!"
echo "------------------------------------------------"

# Run once at the end of the script to show the result
neofetch --config /etc/neofetch/config.conf
