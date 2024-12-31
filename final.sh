#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log() {
    echo -e "${GREEN}[+] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[!] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# Check if running with sudo/root
if [ "$EUID" -ne 0 ]; then 
    error "Please run as root"
fi

# Package groups
SYSTEM_BASE=(
    "base-devel"
    "linux"
    "linux-headers"
    "linux-firmware"
    "mkinitcpio"
    "dkms"
    "fwupd"              # Firmware updates
)

# ThinkPad specific packages
THINKPAD_PACKAGES=(
    "tp_smapi"           # ThinkPad-specific ACPI interface
    "acpi_call"          # ThinkPad-specific ACPI calls
    "hdapsd"             # Hard Drive Active Protection System
    "fprintd"            # Fingerprint reader support
    "throttled"          # ThrottleD for Lenovo throttling fix
    "touchegg"           # Touchpad gestures
    "thinkfan"           # ThinkPad fan control
)

# Intel specific packages
INTEL_PACKAGES=(
    "intel-ucode"        # Microcode updates
    "xf86-video-intel"   # Intel video driver
    "vulkan-intel"       # Vulkan support
    "intel-media-driver" # Hardware video acceleration
    "libva-intel-driver" # VA-API support
    "intel-gpu-tools"    # Intel GPU utilities
)

# Storage and performance packages
STORAGE_PACKAGES=(
    "hdparm"            # Disk parameters tool
    "smartmontools"     # S.M.A.R.T. monitoring
    "nvme-cli"         # NVMe management
    "fstrim"           # SSD TRIM support
)

PERFORMANCE_PACKAGES=(
    "irqbalance"        # IRQ balancing
    "iotop"             # I/O monitoring
    "nohang"            # OOM handler
    "preload"           # Adaptive readahead daemon
)

# Power management
POWER_PACKAGES=(
    "acpi"
    "acpid"
    "thermald"
    "powertop"
    "tlp"
    "tlp-rdw"
    "auto-cpufreq"
)

# Display server
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

# Window Manager
I3_PACKAGES=(
    "i3-gaps"
    "i3blocks"
    "i3lock-color"
    "i3status"
    "rofi"
    "dunst"
    "picom-ibhagwan-git"
    "polybar"
    "xfce-polkit"
    "kitty"
    "feh"
    "flameshot"
    "maim"
    "xss-lock"
    "autotiling"
    "i3-layouts"
    "i3-resurrect"
)

# Audio
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

# Networking
NETWORK_PACKAGES=(
    "networkmanager"
    "network-manager-applet"
    "nm-connection-editor"
    "wpa_supplicant"
    "openssh"
    "iw"
    "wireless_tools"
)

# Bluetooth
BLUETOOTH_PACKAGES=(
    "bluez"
    "bluez-libs"
    "bluez-utils"
    "blueman"
)

# Development tools
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
    
    # Databases
    "postgresql"
    "mysql"
    "redis"
    "dbeaver"
    
    # Container/Cloud
    "docker"
    "docker-compose"
    "kubectl"
    "kubectx"
    "k9s"
    "helm"
    "terraform"
    "aws-cli"
)

# Modern CLI tools
CLI_TOOLS=(
    "neovim"
    "tmux"
    "zellij"
    "eza"
    "bat"
    "ripgrep"
    "fd"
    "zoxide"
    "fzf"
    "btop"
    "bottom"
    "lazygit"
    "delta"
    "jq"
    "yq"
    "shellcheck"
    "ctags"
    "global"
)

# Development environment managers
DEV_ENV_MANAGERS=(
    "asdf"
    "pyenv"
    "nvm"
    "rbenv"
)

# Container tools
CONTAINER_TOOLS=(
    "distrobox"
    "podman"
    "buildah"
)

# Fonts
FONT_PACKAGES=(
    "ttf-dejavu"
    "ttf-liberation"
    "ttf-hack-nerd"
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "adobe-source-code-pro-fonts"
)

# Utilities
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

# Device mounting
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

# Install yay if not present
install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Installing yay..."
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        cd /tmp/yay-bin
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay-bin
    else
        log "yay is already installed"
    fi
}

# Configure Intel Graphics
setup_intel_graphics() {
    log "Configuring Intel graphics..."
    cat > /etc/X11/xorg.conf.d/20-intel.conf << EOL
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree" "true"
    Option      "DRI" "3"
    Option      "AccelMethod" "sna"
EndSection
EOL
}

# Configure ThinkPad-specific settings
setup_thinkpad() {
    log "Configuring ThinkPad-specific settings..."
    
    # TLP Configuration
    cat >> /etc/tlp.conf << EOL
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_HWP_ON_AC=performance
CPU_HWP_ON_BAT=balance_power
PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersave

# Battery charge thresholds (important for battery longevity)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOL

    # Enable ThinkPad services
    systemctl enable tlp
    systemctl enable thermald
    systemctl enable throttled
}

# Configure SSD optimizations
setup_ssd_optimizations() {
    log "Setting up SSD optimizations..."
    
    # Enable TRIM
    systemctl enable fstrim.timer
    
    # Optimize SSD mount options in fstab
    cp /etc/fstab /etc/fstab.backup
    sed -i 's/relatime/noatime,nodiratime/g' /etc/fstab
}

# Setup hibernation
setup_hibernation() {
    log "Setting up hibernation..."
    
    # Get UUID of swap partition/file
    SWAP_UUID=$(findmnt -no UUID -T /swap || findmnt -no UUID -T /swapfile)
    
    # Update kernel parameters for hibernation
    if [ -n "$SWAP_UUID" ]; then
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=$SWAP_UUID /" /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        
        # Update initramfs hook
        sed -i 's/HOOKS=(base udev/HOOKS=(base udev resume/g' /etc/mkinitcpio.conf
        mkinitcpio -P
    fi
}

# Main system setup
setup_system() {
    log "Updating system..."
    pacman -Syu --noconfirm

    log "Installing package groups..."
    pacman -S --needed --noconfirm \
        "${SYSTEM_BASE[@]}" \
        "${THINKPAD_PACKAGES[@]}" \
        "${INTEL_PACKAGES[@]}" \
        "${STORAGE_PACKAGES[@]}" \
        "${PERFORMANCE_PACKAGES[@]}" \
        "${POWER_PACKAGES[@]}" \
        "${XORG_PACKAGES[@]}" \
        "${I3_PACKAGES[@]}" \
        "${AUDIO_PACKAGES[@]}" \
        "${NETWORK_PACKAGES[@]}" \
        "${BLUETOOTH_PACKAGES[@]}" \
        "${DEVELOPMENT_PACKAGES[@]}" \
        "${CLI_TOOLS[@]}" \
        "${DEV_ENV_MANAGERS[@]}" \
        "${CONTAINER_TOOLS[@]}" \
        "${FONT_PACKAGES[@]}" \
        "${UTILITY_PACKAGES[@]}" \
        "${DEVICE_MOUNT_PACKAGES[@]}"

    log "Setting up services..."
    # Audio
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    systemctl --user enable wireplumber.service

    # System services
    systemctl enable NetworkManager
    systemctl enable bluetooth
    systemctl enable acpid
    systemctl enable thermald
    systemctl enable docker
    systemctl enable fstrim.timer
    systemctl enable fwupd
    
    # Add user to necessary groups
    usermod -aG docker,video,input,audio $SUDO_USER

    # Configure bluetooth
    sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf
    
    # Set up udev rules for device mounting
    cat > /etc/udev/rules.d/99-local.rules << 'EOL'
# Rules for Android devices
SUBSYSTEM=="usb", ATTR{idVendor}=="*", MODE="0666"
SUBSYSTEM=="usb_device", ATTR{idVendor}=="*", MODE="0666"

# Rules for MTP devices
SUBSYSTEM=="usb", ENV{ID_MTP_DEVICE}=="1", MODE="0666"
EOL

    # Setup trash-cli for safer file deletion
    mkdir -p ~/.local/share/Trash
    echo 'alias rm="trash-put"' >> /home/$SUDO_USER/.bashrc
    echo 'alias rm="trash-put"' >> /home/$SUDO_USER/.zshrc

    # Reload udev rules
    udevadm control --reload-rules
    udevadm trigger
}

# Install AUR packages
install_aur_packages() {
    local YAY_PACKAGES=(
        # Browsers
        "brave-bin"
        "google-chrome"
        
        # Development tools
        "visual-studio-code-bin"
        "terraform-ls"
        "postman-bin"
        "insomnia"
        
        # Communication & Media
        "spotify"
        "discord"
        "teams"
        
        # System Tools
        "i3lock-color"
        "picom-ibhagwan-git"
        "polybar"
        "downgrade"
    )

    log "Installing AUR packages..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
}

# Setup development environment
setup_dev_env() {
    log "Setting up development environment..."
    
    # Add development aliases to both bash and zsh
    for rc in "/home/$SUDO_USER/.bashrc" "/home/$SUDO_USER/.zshrc"; do
        cat >> "$rc" << 'EOL'

# Development aliases
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias g='git'

# Development paths
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
EOL
    done
}

# Main execution
main() {
    log "Starting system setup..."
    
    setup_system
    setup_intel_graphics
    setup_thinkpad
    setup_ssd_optimizations
    setup_hibernation
    install_yay
    install_aur_packages
    setup_dev_env
    
    log "Setup complete! Please reboot your system."
    
    # Print helpful information
    cat << EOL

${GREEN}Post-installation steps:${NC}
1. Reboot your system

2. Audio setup:
   - Run: systemctl --user enable pipewire-pulse.service
   - Test: pactl info
   
3. Bluetooth:
   - Check status: bluetoothctl show
   - Scan devices: bluetoothctl
