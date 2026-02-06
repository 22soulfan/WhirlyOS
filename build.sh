#!/bin/bash
# ---------------------------------------------------------
# WhirlyOS v1 Gibberlink - SoulFrame Workstation
# ---------------------------------------------------------
set -e 

echo "🚀 Starting the WhirlyOS Workstation Build..."

# --- 1. SYSTEM PREP & REPAIR ---
apt-get update
apt-get install -f -y
apt-get install -y wget gpg apt-transport-https

# --- 2. ADD VS CODE REPOSITORY ---
echo "🔑 Adding VS Code Repo..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
rm -f packages.microsoft.gpg
apt-get update

# --- 3. PURGE OLD/UNWANTED PACKAGES ---
echo "🧹 Removing non-essential packages..."
apt-get purge -y scratch tuxmath tuxpaint gcompris-qt libreoffice-common
apt-get autoremove -y

# --- 4. INSTALL APPS (Workstation Suite) ---
echo "📦 Installing MuseScore, VLC, and VS Code..."
apt-get install -y \
    musescore3 \
    vlc \
    code \
    gimp \
    neofetch git curl dconf-cli plymouth

# --- 5. INSTALL LIBREOFFICE (Specific Tools) ---
echo "📝 Adding Writer, Calc, and Math..."
apt-get install -y libreoffice-writer libreoffice-calc libreoffice-math libreoffice-gtk3

# --- 6. WHIRLYOS BRANDING ---
echo "🆔 Applying WhirlyOS Identity..."
echo "whirlyos" > /etc/hostname
sed -i 's/Debian/WhirlyOS/g' /etc/os-release

# --- 7. ASSETS & UI ---
W_DIR="/usr/share/backgrounds/whirlyos"
mkdir -p "$W_DIR"
cp ./assets/*.jpg "$W_DIR/"
cp ./assets/*.png "$W_DIR/"

# Use whirlyos.png for Login and Boot
mkdir -p /usr/share/icons/vendor
cp ./assets/whirlyos.png /usr/share/icons/vendor/whirlyos-logo.png
ln -sf /usr/share/icons/vendor/whirlyos-logo.png /usr/share/icons/gnome-logo-text.png

# (Insert Plymouth logic and GSchema override here)

# --- 8. FINAL CLEANUP ---
echo "🧹 Cleaning up..."
apt-get autoremove --purge -y
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

echo "✅ WhirlyOS Gibberlink with VS Code is Ready! Boom."
