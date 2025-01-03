#!/bin/bash

################################################################################
# Arch Linux Initial Installation Script
# Description: Setup script for base Arch Linux system (pre-reboot)
# Version: 1.0
################################################################################

set -e  # Exit on error

# Default values
DEFAULT_USERNAME="ysf"
DEFAULT_HOSTNAME="t14"

# Get parameters with defaults
USERNAME="${1:-$DEFAULT_USERNAME}"
HOSTNAME="${2:-$DEFAULT_HOSTNAME}"

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m'  # No Color

log() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# Check if running in chroot
if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
    error "Please run this script in arch-chroot"
fi

main() {
    log "Starting Arch Linux initial setup..."

    # Setup locale
    log "Configuring system locale..."
    sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    # Setup timezone
    log "Setting timezone..."
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    hwclock --systohc

    # Setup hostname
    log "Configuring hostname..."
    echo "$HOSTNAME" > /etc/hostname
    cat > /etc/hosts << EOL
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME
EOL

    # Create user and set passwords
    log "Creating user account..."
    useradd -m -G wheel,storage,power,audio,video -s /bin/bash "$USERNAME"
    
    echo "Setting password for $USERNAME..."
    passwd "$USERNAME"
    
    echo "Setting password for root..."
    passwd root

    # Configure sudo
    log "Configuring sudo access..."
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

    # Install GRUB
    log "Installing and configuring GRUB..."
    pacman -S --noconfirm grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg

    # Install networking packages
    log "Installing networking packages..."
    pacman -S --noconfirm \
        networkmanager \
        network-manager-applet \
        nm-connection-editor \
        wpa_supplicant \
        openssh \
        iw \
        wireless_tools

    # Enable networking services
    log "Enabling network services..."
    systemctl enable NetworkManager
    systemctl enable systemd-resolved
    systemctl enable sshd

    log "Initial installation completed!"
    log "You can now exit chroot, unmount partitions and reboot:"
    echo "$ exit"
    echo "$ umount /mnt/boot/efi"
    echo "$ umount /mnt"
    echo "$ reboot"
}

# Execute main function
main "$@"
