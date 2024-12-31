#!/bin/bash

install_base_packages() {
    local REAL_USER=$1

    # Install yay if not present
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}Installing yay...${NC}"
        pacman -S --needed --noconfirm git base-devel
        # Install yay as the real user, not root
        su - "$REAL_USER" -c "
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay
            makepkg -si --noconfirm
        "
        rm -rf /tmp/yay
    fi

    # Define package arrays
    local CORE_PACKAGES=(
        "base-devel"
        "linux-headers"
        "neovim"
        "git"
        "reflector"
        "sudo"
        "wget"
        "curl"
        "unzip"
        "zip"
        "p7zip"
        "htop"
        "neofetch"
    )

    local WM_PACKAGES=(
        "xorg"
        "xorg-server"
        "xorg-xinit"
        "xorg-xrandr"
        "xorg-xbacklight"
        "xorg-xsetroot"
        "xorg-xdpyinfo"
        "xclip"
        "xsel"
        "i3-gaps"
        "i3blocks"
        "i3lock-color"
        "polybar"
        "picom-ibhagwan-git"
        "rofi"
        "dunst"
        "feh"
        "maim"
        "arandr"
        "flameshot"
        "redshift"
        "light"
    )

    local AUDIO_PACKAGES=(
        "pipewire"
        "pipewire-pulse"
        "pipewire-alsa"
        "pipewire-jack"
        "wireplumber"
        "pamixer"
        "pavucontrol"
        "playerctl"
        "bluez"
        "bluez-utils"
        "blueman"
        "sof-firmware"
        "alsa-utils"
        "alsa-plugins"
    )

    local SYSTEM_PACKAGES=(
        "acpi"
        "acpid"
        "thermald"
        "tlp"
        "tlp-rdw"
        "powertop"
        "power-profiles-daemon"
        "brightnessctl"
        "lm_sensors"
        "nvme-cli"
        "smartmontools"
        "upower"
    )

    local TOOLS_PACKAGES=(
        "kitty"
        "zsh"
        "tmux"
        "bat"
        "lsd"
        "fzf"
        "ripgrep"
        "fd"
        "tree"
        "the_silver_searcher"
        "ranger"
        "ncdu"
        "mlocate"
        "tldr"
        "jq"
        "seahorse"
        "z"
        "sd"
    )

    local FILE_PACKAGES=(
        "thunar"
        "thunar-archive-plugin"
        "thunar-volman"
        "thunar-media-tags-plugin"
        "gvfs"
        "gvfs-mtp"
        "gvfs-afc"
        "gvfs-smb"
        "udiskie"
        "udisks2"
        "ntfs-3g"
        "android-tools"
        "android-udev"
        "mtpfs"
        "tumbler"
        "ffmpegthumbnailer"
        "file-roller"
    )

    local NETWORK_PACKAGES=(
        "networkmanager"
        "network-manager-applet"
        "networkmanager-openvpn"
        "nm-connection-editor"
        "wpa_supplicant"
        "dialog"
        "openssh"
        "rsync"
        "wget"
        "bind"
        "traceroute"
        "wireshark-qt"
    )

    local DEV_PACKAGES=(
        "docker"
        "docker-compose"
        "nodejs"
        "npm"
        "python"
        "python-pip"
        "go"
        "visual-studio-code-bin"
        "github-cli"
        "git-lfs"
    )

    local FONT_PACKAGES=(
        "ttf-font-awesome"
        "ttf-hack-nerd"
        "ttf-jetbrains-mono-nerd"
        "ttf-dejavu"
        "ttf-liberation"
        "noto-fonts"
        "noto-fonts-emoji"
        "ttf-roboto"
        "adobe-source-code-pro-fonts"
    )

    local APPEARANCE_PACKAGES=(
        "arc-gtk-theme"
        "papirus-icon-theme"
        "lxappearance"
        "qt5ct"
        "adwaita-qt5"
        "adwaita-qt6"
    )

    local APP_PACKAGES=(
        "firefox"
        "brave-bin"
        "vlc"
        "libreoffice-still"
        "zathura"
        "zathura-pdf-mupdf"
        "gpicview"
    )

    # Install packages as the real user (for AUR access)
    su - "$REAL_USER" -c "yay -S --needed --noconfirm \
        ${CORE_PACKAGES[*]} \
        ${WM_PACKAGES[*]} \
        ${AUDIO_PACKAGES[*]} \
        ${SYSTEM_PACKAGES[*]} \
        ${TOOLS_PACKAGES[*]} \
        ${FILE_PACKAGES[*]} \
        ${NETWORK_PACKAGES[*]} \
        ${DEV_PACKAGES[*]} \
        ${FONT_PACKAGES[*]} \
        ${APPEARANCE_PACKAGES[*]} \
        ${APP_PACKAGES[*]}"
}

