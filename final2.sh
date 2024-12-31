#!/bin/bash

################################################################################
# Arch Linux Installation Script for ThinkPad
# Description: Automated setup script for Arch Linux on ThinkPad devices
# Author: Generated by Claude
# Version: 1.0
################################################################################

#-------------------------------------------------------------------------------
# Configuration Variables
#-------------------------------------------------------------------------------

# Script configuration
set -e  # Exit on error
readonly SCRIPT_VERSION="1.0"
readonly SCRIPT_NAME=$(basename "$0")
readonly LOG_FILE="/var/log/arch-install.log"

# Default values
DEFAULT_USERNAME="ysf"
DEFAULT_HOSTNAME="ysf"

# Get parameters with defaults
USERNAME="${1:-$DEFAULT_USERNAME}"
HOSTNAME="${2:-$DEFAULT_HOSTNAME}"

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'  # No Color

#-------------------------------------------------------------------------------
# Package Group Definitions
#-------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------
# Utility Functions
#-------------------------------------------------------------------------------

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[${timestamp}] [INFO] $1${NC}" | tee -a "$LOG_FILE"
}

warn() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[${timestamp}] [WARN] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[${timestamp}] [ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        error "Please run as root"
    fi
}

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "${file}.backup-$(date +%Y%m%d-%H%M%S)"
        log "Backed up $file"
    fi
}

#-------------------------------------------------------------------------------
# System Configuration Functions
#-------------------------------------------------------------------------------

setup_localization() {
    log "Configuring system localization..."
    
    # Check if locale is already configured
    if ! grep -q "^en_US.UTF-8 UTF-8" /etc/locale.gen; then
        sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
        locale-gen
    fi
    
    # Only write if different
    if [ ! -f "/etc/locale.conf" ] || ! grep -q "LANG=en_US.UTF-8" /etc/locale.conf; then
        echo "LANG=en_US.UTF-8" > /etc/locale.conf
    fi
    
    # Check if timezone is already set correctly
    if [ "$(readlink /etc/localtime)" != "/usr/share/zoneinfo/Europe/Berlin" ]; then
        ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
        hwclock --systohc
    fi
}

setup_networking() {
    log "Configuring network settings..."
    
    # Check if hostname is already set
    if [ ! -f "/etc/hostname" ]; then
        echo "$HOSTNAME" > /etc/hostname
        log "Hostname set to: $HOSTNAME"
    else
        current_hostname=$(cat /etc/hostname)
        if [ "$current_hostname" != "$HOSTNAME" ]; then
            echo "$HOSTNAME" > /etc/hostname
            log "Updated hostname from $current_hostname to $HOSTNAME"
        else
            log "Hostname already set to: $HOSTNAME"
        fi
    fi
    
    # Check if hosts file needs to be configured
    if ! grep -q "127.0.1.1.*$HOSTNAME" /etc/hosts 2>/dev/null; then
        cat > /etc/hosts << EOL
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME
EOL
    fi
}

create_user() {
    log "Setting up user account..."
    
    # Check if user already exists
    if id "$USERNAME" >/dev/null 2>&1; then
        log "User $USERNAME already exists"
        # Prompt for root password since we'll need it for installations
        echo "Please enter root password for system updates and installations..."
        until su -c "exit" root; do
            echo "Invalid password, please try again..."
        done
    else
        useradd -m -G wheel,storage,power,audio,video -s /bin/bash "$USERNAME"
        
        echo "Setting password for $USERNAME..."
        passwd "$USERNAME"
        
        # Only set root password if not already set
        if ! grep -q "^root:[^:]*:" /etc/shadow; then
            echo "Setting password for root..."
            passwd root
        fi
    fi
    
    # Check if sudo access is already configured
    if ! grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then
        sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    fi
}


#-------------------------------------------------------------------------------
# Hardware-Specific Functions
#-------------------------------------------------------------------------------

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

# Battery charge thresholds
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
EOL

    # Enable ThinkPad services
    systemctl enable tlp thermald throttled
}

#-------------------------------------------------------------------------------
# Storage and Performance Functions
#-------------------------------------------------------------------------------

setup_ssd_optimizations() {
    log "Configuring SSD optimizations..."
    
    # Enable TRIM
    systemctl enable fstrim.timer
    
    # Optimize mount options
    backup_file "/etc/fstab"
    sed -i 's/relatime/noatime,nodiratime/g' /etc/fstab
}

setup_hibernation() {
    log "Configuring hibernation support..."
    
    local SWAP_UUID=$(grep -E '^UUID=.*swap' /etc/fstab | awk '{print $1}' | cut -d= -f2)
    
    if [ -n "$SWAP_UUID" ]; then
        # Update GRUB configuration
        backup_file "/etc/default/grub"
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash resume=UUID=$SWAP_UUID /" /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        
        # Update initramfs
        backup_file "/etc/mkinitcpio.conf"
        sed -i 's/HOOKS=.*/HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"/' /etc/mkinitcpio.conf
        mkinitcpio -p linux
    else
        warn "No swap partition UUID found. Skipping hibernation setup."
    fi
}

#-------------------------------------------------------------------------------
# Package Installation Functions
#-------------------------------------------------------------------------------

install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Installing yay AUR helper..."
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && sudo -u "$USERNAME" makepkg -si --noconfirm)
        rm -rf /tmp/yay-bin
    else
        log "yay is already installed"
    fi
}

install_package_groups() {
    log "Installing package groups..."
    
    pacman -Syu --noconfirm
    
    # Install all package groups
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
}

#-------------------------------------------------------------------------------
# Service Configuration Functions
#-------------------------------------------------------------------------------

configure_services() {
    log "Configuring system services..."
    
    # User services
    systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service
    
    # System services
    systemctl enable NetworkManager bluetooth acpid thermald docker fstrim.timer fwupd
    
    # Group permissions
    usermod -aG docker,video,input,audio $SUDO_USER
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

setup_shell_config() {
    log "Configuring shell environment..."
    
    # Setup trash-cli for safer file deletion
    mkdir -p ~/.local/share/Trash
    
    # Configure shell aliases
    for shell_rc in /home/$SUDO_USER/.bashrc /home/$SUDO_USER/.zshrc; do
        if [ -f "$shell_rc" ]; then
            echo 'alias rm="trash-put"' >> "$shell_rc"
        fi
    done
}

#-------------------------------------------------------------------------------
# Main Installation Function
#-------------------------------------------------------------------------------
main() {
    # Create log file
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
    
    log "Starting Arch Linux installation script v${SCRIPT_VERSION}"
    log "Using username: $USERNAME"
    log "Using hostname: $HOSTNAME"
    
    # Preliminary checks
    check_root
    
    # Basic system setup
    setup_localization
    setup_networking
    create_user
    
    # Package installation
    install_yay
    install_package_groups
    
    # Hardware configuration (after packages are installed)
    setup_intel_graphics  # Moved here after X11 is installed
    setup_thinkpad
    setup_ssd_optimizations
    setup_hibernation
    
    # Service configuration
    configure_services
    configure_bluetooth
    configure_udev
    setup_shell_config
    
    log "Installation completed successfully"
    log "Log file available at: $LOG_FILE"
}

# Print usage
usage() {
    echo "Usage: $0 [username] [hostname]"
    echo "Default username: $DEFAULT_USERNAME"
    echo "Default hostname: $DEFAULT_HOSTNAME"
    exit 1
}

# Handle help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# Execute main function
main "$@"
