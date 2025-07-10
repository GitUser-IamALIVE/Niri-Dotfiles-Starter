#!/bin/bash

# Install script for Niri desktop environment and related packages
# Make sure to run this script with appropriate permissions

set -e  # Exit on any error

echo "=== Starting installation process ==="

# Command 1: Install main packages
echo "Installing main packages..."
sudo pacman -S --needed --noconfirm niri fuzzel kitty waybar wlogout blueman nwg-look gnome-keyring xdg-desktop-portal-gnome swww waypaper adw-gtk-theme swayidle swaylock wlogout cliphist papirus-icon-theme sddm cava file-roller flatpak gnome-software gnome-text-editor gnome-disk-utility

# Command 2: Remove unwanted packages
echo "Removing unwanted packages..."
sudo pacman -Rns --noconfirm micro cachyos-micro-settings

# Command 3: Install cmatrix-git from AUR
echo "Installing cmatrix-git from AUR..."
paru -S cmatrix-git --skipreview --noconfirm

# Command 4: Set dark theme preference
echo "Setting dark theme preference..."
dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'

# Command 5: Enable SDDM service
echo "Enabling SDDM service..."
sudo systemctl enable sddm

echo "=== Installation completed successfully! ==="

# Command 6: Ask for reboot
echo ""
read -p "Would you like to reboot now? (Y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    echo "Rebooting system..."
    sudo reboot
else
    echo "Reboot cancelled. Please reboot manually when ready."
fi
