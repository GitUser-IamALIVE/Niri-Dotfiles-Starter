#!/bin/bash

# Niri Desktop Environment Setup Script (Arch-Based Only)
# No external dependencies required

set -e  # Exit on error

# ========== Styled Echo ==========
header() {
    echo -e "\n\033[1;36m==> $1\033[0m"
}
section() {
    echo -e "\n\033[1;34m# $1\033[0m"
}
success() {
    echo -e "\033[1;32m✔ $1\033[0m"
}
error() {
    echo -e "\033[1;31m✖ $1\033[0m"
}
prompt() {
    echo -ne "\033[1;33m$1\033[0m"
}

# ========== Distro Selection ==========

section "Niri Desktop Installation Script"
header "Select your Linux distribution:"
echo "1. Arch-Based Distributions"
echo "2. Others (Not supported)"
prompt "Enter your choice [1-2]: "
read -r distro_choice

if [[ "$distro_choice" != "1" ]]; then
    error "Sorry, this script supports only Arch-based distributions."
    exit 1
fi

# ========== Arch Flavor ==========

header "Select your Arch-based distribution:"
echo "1. CachyOS"
echo "2. Arch"
echo "3. Arch-based Derivative"
prompt "Enter your choice [1-3]: "
read -r arch_type

# ========== Functions ==========

install_main_packages() {
    header "Installing main packages..."
    if [[ "$arch_type" == "1" ]]; then
        sudo pacman -S --needed --noconfirm \
            niri fuzzel kitty waybar wlogout blueman nwg-look \
            gnome-keyring xdg-desktop-portal-gnome swww waypaper \
            adw-gtk-theme swayidle swaylock wlogout cliphist \
            papirus-icon-theme sddm cava file-roller flatpak \
            gnome-software gnome-text-editor gnome-disk-utility
    else
        header "Checking if paru is installed..."
        if ! command -v paru &> /dev/null; then
            if [[ "$arch_type" == "1" ]]; then
                header "Installing paru using pacman..."
                sudo pacman -S --needed --noconfirm paru
            else
                header "Installing paru from AUR..."
                sudo pacman -S --needed --noconfirm base-devel git
                git clone https://aur.archlinux.org/paru.git
                cd paru
                makepkg -si --noconfirm
                cd ..
                rm -rf paru
            fi
        fi

        paru -S --needed --noconfirm \
            niri fuzzel kitty waybar wlogout blueman nwg-look \
            gnome-keyring xdg-desktop-portal-gnome swww waypaper \
            adw-gtk-theme swayidle swaylock wlogout cliphist \
            papirus-icon-theme sddm cava file-roller flatpak \
            gnome-software gnome-text-editor gnome-disk-utility
    fi
    success "Main packages installed."
}

remove_unwanted_packages() {
    header "Removing unwanted packages (CachyOS only)..."
    sudo pacman -Rns --noconfirm micro cachyos-micro-settings || true
    success "Unwanted packages removed."
}

install_cmatrix() {
    header "Installing cmatrix-git..."
    paru -S cmatrix-git --skipreview --noconfirm
    success "cmatrix-git installed."
}

set_dark_theme() {
    header "Setting dark theme preference..."
    dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
    success "Dark theme applied."
}

enable_sddm() {
    header "Enabling SDDM service..."
    sudo systemctl enable sddm
    success "SDDM enabled."
}

reboot_system() {
    echo ""
    prompt "Would you like to reboot now? (Y/n): "
    read -r reboot_choice
    if [[ "$reboot_choice" =~ ^[Yy]$|^$ ]]; then
        echo "Rebooting system..."
        sudo reboot
    else
        echo "Reboot cancelled. Please reboot manually when ready."
    fi
}

# ========== Installation Mode ==========

header "Choose installation mode:"
echo "1. Automatic (run all commands)"
echo "2. Selective (choose steps from menu)"
prompt "Enter your choice [1-2]: "
read -r install_mode

section "Starting Installation"

if [[ "$install_mode" == "1" ]]; then
    [[ "$arch_type" == "1" ]] && install_main_packages && remove_unwanted_packages
    [[ "$arch_type" != "1" ]] && install_main_packages
    install_cmatrix
    set_dark_theme
    enable_sddm
    reboot_system
else
    while true; do
        header "Selective Install Menu"
        echo "1. Install main packages"
        [[ "$arch_type" == "1" ]] && echo "2. Remove unwanted packages (CachyOS only)"
        echo "3. Install cmatrix-git"
        echo "4. Set dark theme"
        echo "5. Enable SDDM"
        echo "6. Reboot system"
        echo "7. Run All (distro-dependent)"
        echo "8. Exit"
        prompt "Choose an option [1-8]: "
        read -r step

        case "$step" in
            1) install_main_packages ;;
            2)
                if [[ "$arch_type" == "1" ]]; then
                    remove_unwanted_packages
                else
                    echo "Skipping: Only for CachyOS."
                fi
                ;;
            3) install_cmatrix ;;
            4) set_dark_theme ;;
            5) enable_sddm ;;
            6) reboot_system ;;
            7)
                install_main_packages
                [[ "$arch_type" == "1" ]] && remove_unwanted_packages
                install_cmatrix
                set_dark_theme
                enable_sddm
                reboot_system
                ;;
            8)
                echo "Exiting installer."
                break
                ;;
            *) echo "Invalid option. Try again." ;;
        esac
        echo ""
        prompt "Press Enter to return to menu..."
        read
        clear
    done
fi

success "Installation process completed!"

