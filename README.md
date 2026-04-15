# Doom Emacs + EXWM on ThinkPad X270

This is my personal Doom Emacs configuration, customized for use as a full Window Manager (EXWM) on Arch Linux.

## Highlights
- **Hardware Optimized**: Integrated brightness and volume controls for the ThinkPad X270 via `brightnessctl` and `pactl`.
- **EXWM Modeline**: Custom `doom-modeline` segments to show EXWM workspaces on the left, with system load hidden for a cleaner look.
- **Data Science Ready**: Pre-configured `ESS` (Emacs Speaks Statistics) with an automatic RStudio-style layout.
- **Laptop Friendly**: Battery and time display enabled by default.

## Prerequisites
To use the hardware keys, ensure you have the following installed on Arch:
```bash
sudo pacman -S brightnessctl libpulse qutebrowser
