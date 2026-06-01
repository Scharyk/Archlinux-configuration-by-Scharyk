# 🦅 Arch Linux + Hyprland Custom Configuration

Welcome to my personal, automated Arch Linux setup! This repository contains a fully customized, rice-themed desktop environment powered by **Hyprland** and dynamically colored using **Pywal**.

---

## 📸 Screenshots
> *Tip: Open your SwayNC Control Center and terminal to see the dynamic themes in action!*
> 
> *(Once you upload screenshots to your repository, you can display them here like this: `![Desktop Setup](screenshot.png)`)*

---

## 🚀 Automated Installation

You can install this entire configuration with a single command. It will clone the repository, install all necessary dependencies, and deploy the configs.

```bash
bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Scharyk/Archlinux-configuration-by-Scharyk/main/install.sh](https://raw.githubusercontent.com/Scharyk/Archlinux-configuration-by-Scharyk/main/install.sh))"
⚠️ Note: The script will ask for your sudo password during the installation to install system packages and components from the AUR. Just type it in when prompted!

🛠️ What's Inside? (Features & Components)

This setup includes a curated list of modern Wayland tools, all configured to blend together flawlessly:
Component	Software Used	Description
Window Manager	Hyprland	Smooth, dynamic tiling window manager with fluid animations.
Status Bar	Waybar	Clean, highly customized top bar tracking system stats.
Control Center	SwayNC	A complete notification center with toggles and volume sliders.
App Launcher	Rofi (Wayland)	Blazing fast application menu styled to match the theme.
Terminal	Kitty	Fast, GPU-accelerated terminal.
Theming Engine	Pywal	Generates a custom color palette on the fly based on your wallpaper.
System Info	Fastfetch	Custom system fetch featuring a unique ASCII Arch Sword art.
⌨️ Keybindings (Quick Start)

Once installed, use these main shortcuts to navigate around:

    Super + Q — Open Kitty Terminal

    Super + C — Close active window

    Super + W — Change Theme (Triggers script to randomize theme and re-color the whole system on the fly!)
  
    Super + A - Open the menu of change wallpapers!

    Super + F - Open the menu when you have all aplications and you can open iT!

    Click the Bell Icon on Waybar — Toggle the SwayNC Control Center

Created with 💻 and ☕ by Scharyk. Enjoy your new rice!
