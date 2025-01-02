#!/bin/bash

################################################################################
# Arch Linux Post-Installation Script
# Description: Post-installation configuration script (after reboot)
# Version: 1.0
################################################################################

set -e  # Exit on error

# Default values
DEFAULT_USERNAME="ysf"

# Get parameters with defaults
USERNAME="${1:-$DEFAULT_USERNAME}"

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'  # No Color

# Package Groups
SYSTEM_BASE=(
    "base-devel"
    "linux"
    "linux-headers"
    "linux-firmware"
    "mkinitcpio"
    "dkms"
    "fwupd"
)

THINKPAD_PACKAGES=(
    "tp_smapi"
    "acpi_call"
    "hdapsd"
    "fprintd"
    "throttled"
    "touchegg"
    "thinkfan"
)

INTEL_PACKAGES=(
    "intel-ucode"
    "xf86-video-intel"
    "vulkan-intel"
    "intel-media-driver"
    "libva-intel-driver"
    "intel-gpu-tools"
)

STORAGE_PACKAGES=(
    "hdparm"
    "smartmontools"
    "nvme-cli"
    "fstrim"
)

POWER_PACKAGES=(
    "acpi"
    "acpid"
    "thermald"
    "powertop"
    "tlp"
    "tlp-rdw"
)

XORG_PACKAGES=(
    "xorg-server"
    "xorg-xinit"
    "xorg-xrandr"
    "xorg-xsetroot"
    "xorg-xbacklight"
    "xorg-xdpyinfo"
    "xorg-xinput"
    "xorg-xset"
    "xorg-xauth"
    "xorg-xrdb"
    "xf86-input-libinput"
    "xdg-utils"
    "xdg-user-dirs"
    "mesa"
)

I3_PACKAGES=(
    "i3-gaps"
    "i3lock-color"
    "rofi"
    "dunst"
    "polybar"
    "xfce-polkit"
    "kitty"
    "feh"
    "flameshot"
    "maim"
    "xss-lock"
)

AUDIO_PACKAGES=(
    "pipewire"
    "pipewire-alsa"
    "pipewire-pulse"
    "pipewire-jack"
    "wireplumber"
    "sof-firmware"
    "alsa-utils"
    "alsa-plugins"
    "alsa-lib"
    "alsa-firmware"
    "pavucontrol"
)

BLUETOOTH_PACKAGES=(
    "bluez"
    "bluez-libs"
    "bluez-utils"
    "blueman"
)

DEVELOPMENT_PACKAGES=(
    # Version Control
    "git"
    "git-lfs"
    
    # Compilers and build tools
    "cmake"
    "gcc"
    "clang"
    
    # Programming languages
    "python"
    "python-pip"
    "python-virtualenv"
    "nodejs"
    "npm"
    "yarn"
    "go"
    "rust"
    
    # Language servers
    "lua-language-server"
    "pyright"
    "typescript-language-server"
    
    # Container/Cloud
    "docker"
    "docker-compose"
    "kubectl"
    "kubectx"
    "helm"
    "terraform"
)

CLI_TOOLS=(
    "neovim"
    "tmux"
    "lsd"
    "bat"
    "ripgrep"
    "fd"
    "zoxide"
    "fzf"
    "btop"
    "bottom"
    "jq"
    "yq"
    "shellcheck"
    "ctags"
    "global"
)

DEV_ENV_MANAGERS=(
    "pyenv"
    "rbenv"
)

FONT_PACKAGES=(
    "ttf-dejavu"
    "ttf-liberation"
    "ttf-font-awesome"
    "adobe-source-code-pro-fonts"
)

UTILITY_PACKAGES=(
    # CLI utilities
    "zsh"
    "htop"
    "neofetch"
    "tree"
    "wget"
    "curl"
    "rsync"
    "unzip"
    "zip"
    "trash-cli"
    
    # GUI utilities
    "arandr"
    "sxiv"
    "zathura"
    "zathura-pdf-mupdf"
    "meld"
    "timeshift"
    "remmina"
    "barrier"
    "zeal"
)

DEVICE_MOUNT_PACKAGES=(
    "udisks2"
    "udiskie"
    "ntfs-3g"
    "mtpfs"
    "gvfs"
    "gvfs-mtp"
    "gvfs-gphoto2"
    "android-tools"
    "android-udev"
    "libmtp"
)

# AUR packages
AUR_PACKAGES=(
    "picom-ibhagwan-git"
    "ttf-hack-nerd"
    "ttf-jetbrains-mono-nerd"
    "nohang"
    "auto-cpufreq"
    "k9s"
    "brave-bin"
    "downgrade"
    "snapd"
    "google-chrome"
    "spotify"
    "teams"
    "via-bin"
    "vial-appimage"
    "visual-studio-code-bin"
)

log() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARN] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        error "Please run as root"
    fi
}

install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Installing yay dependencies..."
        pacman -S --needed --noconfirm git base-devel go
        
        log "Installing yay AUR helper..."
        install -d -m 755 -o "$USERNAME" /tmp/yay-build
        cd /tmp/yay-build
        
        sudo -u "$USERNAME" git clone https://aur.archlinux.org/yay.git
        cd yay
        sudo -u "$USERNAME" makepkg -si --noconfirm
        
        cd /
        rm -rf /tmp/yay-build
    else
        log "yay is already installed"
    fi
}

install_packages() {
    local packages=("$@")
    for pkg in "${packages[@]}"; do
        pacman -S --needed --noconfirm "$pkg" || warn "Failed to install $pkg, continuing..."
    done
}

install_aur_packages() {
    log "Installing AUR packages..."
    
    # Create a temporary sudo token to avoid multiple password prompts
    sudo -v
    
    # Keep sudo token alive in the background
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
    
    # Install AUR packages
    for pkg in "${AUR_PACKAGES[@]}"; do
        sudo -u "$USERNAME" yay -S --needed --noconfirm "$pkg" || warn "Failed to install AUR package $pkg, continuing..."
    done
}

setup_intel_graphics() {
    log "Configuring Intel graphics..."
    
    if [ -d "/etc/X11" ]; then
        mkdir -p /etc/X11/xorg.conf.d/
        cat > /etc/X11/xorg.conf.d/20-intel.conf << EOL
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree" "true"
    Option      "DRI" "3"
    Option      "AccelMethod" "sna"
EndSection
EOL
    else
        warn "X11 not installed yet, skipping Intel graphics configuration"
    fi
}

setup_thinkpad() {
    log "Configuring ThinkPad-specific settings..."
    
    cat >> /etc/tlp.conf << EOL
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_HWP_ON_AC=performance
CPU_HWP_ON_BAT=balance_power
PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersave

# Battery charge thresholds
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOL

    systemctl enable tlp thermald throttled
}

setup_ssd_optimizations() {
    log "Configuring SSD optimizations..."
    
    systemctl enable fstrim.timer
    
    # Optimize mount options
    if [ -f "/etc/fstab" ]; then
        cp /etc/fstab /etc/fstab.backup
        sed -i 's/relatime/noatime,nodiratime/g' /etc/fstab
    fi
}

setup_shell_config() {
    log "Configuring shell environment..."
    
    mkdir -p /home/$USERNAME/.local/share/Trash
    
    for shell_rc in /home/$USERNAME/.bashrc /home/$USERNAME/.zshrc; do
        if [ -f "$shell_rc" ]; then
            echo 'alias rm="trash-put"' >> "$shell_rc"
        fi
    done
}

configure_services() {
    log "Configuring system services..."
    
    systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service
    
    systemctl enable bluetooth acpid thermald docker fstrim.timer fwupd
    
    usermod -aG docker,video,input,audio "$USERNAME"
}

configure_bluetooth() {
    log "Setting up bluetooth..."
    sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf
}

configure_udev() {
    log "Configuring udev rules..."
    
    cat > /etc/udev/rules.d/99-local.rules << 'EOL'
# Android devices
SUBSYSTEM=="usb", ATTR{idVendor}=="*", MODE="0666"
SUBSYSTEM=="usb_device", ATTR{idVendor}=="*", MODE="0666"

# MTP devices
SUBSYSTEM=="usb", ENV{ID_MTP_DEVICE}=="1", MODE="0666"
EOL
}

main() {
    check_root
    
    log "Starting post-installation configuration..."
    
    # Install yay first
    install_yay
    
    # System update
    log "Updating system..."
    pacman -Syu --noconfirm || warn "System upgrade failed, continuing anyway..."
    
    # Install regular packages
    log "Installing regular packages..."
    install_packages "${SYSTEM_BASE[@]}"
    install_packages "${THINKPAD_PACKAGES[@]}"
    install_packages "${INTEL_PACKAGES[@]}"
    install_packages "${STORAGE_PACKAGES[@]}"
    install_packages "${POWER_PACKAGES[@]}"
    install_packages "${XORG_PACKAGES[@]}"
    install_packages "${I3_PACKAGES[@]}"
    install_packages "${AUDIO_PACKAGES[@]}"
    install_packages "${BLUETOOTH_PACKAGES[@]}"
    install_packages "${DEVELOPMENT_PACKAGES[@]}"
    install_packages "${CLI_TOOLS[@]}"
    install_packages "${DEV_ENV_MANAGERS[@]}"
    install_packages "${FONT_PACKAGES[@]}"
    install_packages "${UTILITY_PACKAGES[@]}"
    install_packages "${DEVICE_MOUNT_PACKAGES[@]}"
    
    # Install AUR packages with single password prompt
    install_aur_packages
    
    # Configure hardware and services
    setup_intel_graphics
    setup_thinkpad
    setup_ssd_optimizations
    configure_services
    configure_bluetooth
    configure_udev
    setup_shell_config
    
    log "Post-installation configuration completed successfully!"
}

# Execute main function
main "$@"
