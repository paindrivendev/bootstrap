# bootstrap.sh
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run with sudo${NC}"
    exit 1
fi

# Get real username (even when using sudo)
REAL_USER=$(logname || echo "$SUDO_USER")

# Source other scripts
source ./scripts/install_packages.sh
source ./scripts/configure_system.sh

# Main function
main() {
    echo -e "${GREEN}Starting Arch Linux setup...${NC}"

    # Check if user exists
    if ! id "$REAL_USER" &>/dev/null; then
        read -p "Enter username to create: " NEW_USER
        read -s -p "Enter password for $NEW_USER: " USER_PASS
        echo
        useradd -m -G wheel -s /bin/bash "$NEW_USER"
        echo "$NEW_USER:$USER_PASS" | chpasswd
        REAL_USER=$NEW_USER
    fi

    # Install packages
    install_base_packages "$REAL_USER"

    # Configure system
    configure_system "$REAL_USER"

    echo -e "${GREEN}Setup complete! Please reboot your system.${NC}"
}

main "$@"
