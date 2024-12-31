#!/bin/bash

configure_system() {
    local REAL_USER=$1

    echo -e "${YELLOW}Configuring system...${NC}"

    # System Services
    echo -e "${YELLOW}Enabling system services...${NC}"
    systemctl enable NetworkManager
    systemctl enable bluetooth
    systemctl enable acpid
    systemctl enable thermald
    systemctl enable tlp
    systemctl enable power-profiles-daemon
    systemctl enable docker
    systemctl enable udisks2
    systemctl enable fstrim.timer

    # Audio Setup
    echo -e "${YELLOW}Configuring audio...${NC}"
    su - "$REAL_USER" -c "
        systemctl --user disable pulseaudio.service pulseaudio.socket || true
        systemctl --user enable pipewire.service
        systemctl --user enable pipewire-pulse.service
        systemctl --user enable wireplumber.service
    "

    # Power Management
    echo -e "${YELLOW}Configuring power management...${NC}"
    cat > /etc/tlp.conf << EOF
TLP_DEFAULT_MODE=BAT
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_BAT=power
DISK_IDLE_SECS_ON_AC=0
DISK_IDLE_SECS_ON_BAT=2
MAX_LOST_WORK_SECS_ON_AC=15
MAX_LOST_WORK_SECS_ON_BAT=60
EOF

    # User Setup
    echo -e "${YELLOW}Configuring user permissions...${NC}"
    usermod -aG docker,input,video,audio,storage,optical,scanner,lp "$REAL_USER"

    # Better Font Rendering
    echo -e "${YELLOW}Configuring font rendering...${NC}"
    ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
    ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/

    # Create user directories and configs
    echo -e "${YELLOW}Setting up user directories...${NC}"
    su - "$REAL_USER" -c "
        mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Videos ~/Music
        mkdir -p ~/.config/{i3,polybar,dunst,rofi,kitty}

        # Install Oh My Zsh if not already installed
        if [ ! -d ~/.oh-my-zsh ]; then
            sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended
        fi

        # Change shell to zsh if not already
        if [[ \"\$SHELL\" != \"/usr/bin/zsh\" ]]; then
            chsh -s \$(which zsh)
        fi
    "

    # Configure Docker
    echo -e "${YELLOW}Configuring Docker...${NC}"
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json << EOF
{
    "storage-driver": "overlay2",
    "features": {
        "buildkit": true
    }
}
EOF

    # Configure SSD if present
    if [ -d "/sys/block/nvme0n1" ] || [ -d "/sys/block/sda" ]; then
        echo -e "${YELLOW}Configuring SSD settings...${NC}"
        cat > /etc/udev/rules.d/60-scheduler.rules << EOF
# Set scheduler for NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
# Set scheduler for SSD and eMMC
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
EOF
    fi

    echo -e "${GREEN}System configuration complete!${NC}"
}
