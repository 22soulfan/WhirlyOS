#!/bin/bash

# --- COLOR CODES FOR ERRORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting WhirlyOS Build & Validation...${NC}"

# --- 1. PATH VALIDATION & CREATION ---
paths=(
    "/usr/share/whirlyos/ascii"
    "/usr/share/backgrounds/whirlyos"
    "/etc/skel/.config/neofetch"
    "/usr/share/glib-2.0/schemas"
)

for path in "${paths[@]}"; do
    if [ ! -d "$path" ]; then
        echo "Creating path: $path"
        mkdir -p "$path" || { echo -e "${RED}ERROR: Failed to create $path${NC}"; exit 1; }
    fi
done

# --- 2. DEPENDENCIES ---
apt-get update
apt-get install -y git wget curl make gcompris scratch tuxmath tuxpaint \
    gimp mu-editor musescore3 vlc dconf-cli gnome-shell-extension-prefs || { echo -e "${RED}ERROR: Package installation failed.${NC}"; exit 1; }

# --- 3. NEOFETCH INSTALLATION ---
if ! command -v neofetch &> /dev/null; then
    echo "Neofetch not found. Installing from GitHub..."
    git clone https://github.com/dylanaraps/neofetch /tmp/neofetch
    cd /tmp/neofetch && make install || { echo -e "${RED}ERROR: Neofetch build failed.${NC}"; exit 1; }
    cd -
fi

# --- 4. LOGO & CONFIG DEPLOYMENT ---
cat << 'EOF' > /usr/share/whirlyos/ascii/logo.txt
@@@@@@@@@#BP5YJJJYYPG#@@@@@@@@
@@@@@&GY?77!77777!!!77?5B@@@@@
@@@&P?!7J5PGB###BGPY?7!!7JG@@@
@@B?7YG&@@@@@&&&@@@@&BJ777!Y@@
@G7Y#@@@@&PY?777?J5#@@@P777!5@
#JB@@@@@P7777Y55J7!7B@@@J777?&
&&@@@@@P!77?#@&&&?7!G@@@Y777?&
@@@@@@@Y777J@@#YJ?YG@@@G77775@
@@@@@@@#?7775#@@@@@@&BY7777Y&@
@@@@@@@@#J7777JY555Y?7777?G@@@
@@@@@@@@@@B5J?7777777?J5B&@@@@
@@@@@@@@@@@@@&BGGGGBB&@@@@@@@@
EOF

cat << 'EOF' > /etc/skel/.config/neofetch/config.conf
print_info() {
    info title
    info underline
    info "OS" distro
    info "Kernel" kernel
    info "Memory" memory
    echo
    info "Motto" "Find your spark. Find your way."
}
image_backend="ascii"
ascii_distro="/usr/share/whirlyos/ascii/logo.txt"
ascii_colors=(4 6 7 4 4 7)
EOF

# --- 5. WALLPAPER CHECK ---
echo "Checking wallpaper assets..."
# List of expected wallpapers
wallpapers=("carebit_garden.jpg" "great_before_pixos.jpg" "luxi_study_glow.jpg" "pixi_forest.jpg" "wave_ocean_deck.jpg" "whirlyos-wallpaper.png")

if [ -d "./wallpapers" ]; then
    cp ./wallpapers/* /usr/share/backgrounds/whirlyos/
else
    echo -e "${RED}WARNING: Local wallpapers folder not found. Assets may be missing!${NC}"
fi

# Verification of existence
for wall in "${wallpapers[@]}"; do
    if [ -f "/usr/share/backgrounds/whirlyos/$wall" ]; then
        echo -e "${GREEN}[OK]${NC} Found $wall"
    else
        echo -e "${RED}[MISSING]${NC} $wall is not in /usr/share/backgrounds/whirlyos/"
    fi
done

# --- 6. GSETTINGS & BASHRC ---
cat << 'EOF' > /usr/share/glib-2.0/schemas/10_whirlyos.gschema.override
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/whirlyos/whirlyos-wallpaper.png'
picture-options='zoom'
EOF

glib-compile-schemas /usr/share/glib-2.0/schemas/ || echo -e "${RED}ERROR: Schema compilation failed.${NC}"

if ! grep -q "neofetch" /etc/skel/.bashrc; then
    echo "neofetch" >> /etc/skel/.bashrc
fi

# --- 7. FINAL TEST OUTPUT ---
echo -e "\n${GREEN}--- NEOFETCH OUTPUT TEST ---${NC}"
neofetch --config /etc/skel/.config/neofetch/config.conf --ascii_distro /usr/share/whirlyos/ascii/logo.txt

echo -e "\n${GREEN}Build process finished.${NC}"
