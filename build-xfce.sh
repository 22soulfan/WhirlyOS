#!/bin/bash
# WhirlyOS v1.1 Public Beta - MeiLite (XFCE) Build Script
# Target: Debian Stable amd64 (64-bit)
# Mission: "Express yourself. Be the chaos."
set -e

# --- STEP 0: NON-INTERACTIVE SETUP ---
export DEBIAN_FRONTEND=noninteractive

echo "🏮 Starting WhirlyOS 'MeiLite' Build (XFCE amd64)..."

# --- STEP 1: REPOSITORY & SYSTEM PREP ---
echo "🛡️ Clearing conflicts and updating package lists..."
rm -f /etc/apt/sources.list.d/vscode.list /etc/apt/sources.list.d/vscode.sources
apt update

# --- STEP 2: INSTALL XFCE SUITE & EDUCATION APPS ---
echo "📦 Installing WhirlyOS MeiLite Software..."
# Installing XFCE4 and lightdm instead of GNOME/GDM
apt install -y xfce4 xfce4-goodies lightdm git make curl neofetch \
               gcompris-qt scratch3 tuxmath tuxpaint \
               gimp musescore3 vlc dconf-cli \
               chromium-browser firefox-esr

# --- STEP 3: PERMANENT NEOFETCH BRANDING ---
echo "🎨 Customizing Neofetch for the MeiLite vibe..."

mkdir -p /usr/share/whirlyos
if [ -f "/root/WhirlyOS/logo.txt" ]; then
    cp /root/WhirlyOS/logo.txt /usr/share/whirlyos/logo.txt
    chmod 644 /usr/share/whirlyos/logo.txt
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
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "Terminal" term
    info "Memory" memory
}
image_backend="ascii"
image_source="/usr/share/whirlyos/logo.txt"
# Red (1) and White (7) to match the Turning Red / MeiLite theme
ascii_colors=(1 7)
EOF

echo "alias neofetch='neofetch --config /etc/neofetch/config.conf'" >> /etc/bash.bashrc
echo "neofetch" >> /etc/skel/.bashrc

# --- STEP 4: XFCE WALLPAPER & PANEL SETUP ---
echo "🖼️ Applying MeiLite Aesthetics..."
BG_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$BG_DIR"

# Copy wallpapers from the cloned Git repo
cp /root/WhirlyOS/*.jpg "$BG_DIR/" 2>/dev/null || true
cp /root/WhirlyOS/*.png "$BG_DIR/" 2>/dev/null || true

# XFCE uses xfconf instead of gsettings for wallpapers
# We set this for the default user profile
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cat <<EOF > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="string" value="$BG_DIR/whirlyos-wallpaper.png"/>
        <property name="last-image" type="string" value="$BG_DIR/whirlyos-wallpaper.png"/>
      </property>
    </property>
  </property>
</channel>
EOF

# --- STEP 5: CLEANUP & FINAL SYNC ---
echo "✨ Finalizing MeiLite sync..."
apt autoremove -y
update-initramfs -u -k all || true

echo "------------------------------------------------"
echo "✅ WhirlyOS MeiLite (XFCE) Build Complete!"
echo "------------------------------------------------"

neofetch --config /etc/neofetch/config.conf
