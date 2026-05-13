#!/bin/bash
# setup_hyprland.sh - "El pedernal que forja el código"
# Inspirado en Omarchy para Fedora 44

# Resolve the repository root (one level up from this script's install/ directory)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing Hyprland environment (Tecpatl-OS)..."

# 1. Install core Hyprland and Wayland packages on Fedora
sudo dnf install -y hyprland waybar mako starship \
  wl-clipboard grim slurp swappy \
  brightnessctl playerctl nwg-look \
  kitty ghostty

# 2. Install Walker (Launcher and Clipboard manager)
# Walker may require installation via Go or a specific COPR repository on Fedora.
# Used for Super+Space and Super+Ctrl+V.
echo "Installing Walker..."
# sudo dnf copr enable shell-thief/walker -y && sudo dnf install walker -y

# 3. Prepare configuration directories
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/mako ~/.config/walker

# 4. Copy configurations from the repository
echo "Copying configurations from repository: $REPO_DIR"

[ -d "$REPO_DIR/config/hypr" ]   && cp -r "$REPO_DIR/config/hypr/"*   ~/.config/hypr/
[ -d "$REPO_DIR/config/waybar" ] && cp -r "$REPO_DIR/config/waybar/"* ~/.config/waybar/
[ -d "$REPO_DIR/config/mako" ]   && cp -r "$REPO_DIR/config/mako/"*   ~/.config/mako/
[ -d "$REPO_DIR/config/walker" ] && cp -r "$REPO_DIR/config/walker/"* ~/.config/walker/

# 5. Install themes from the repository
echo "Installing themes..."
mkdir -p ~/.config/omarchy/themes
[ -d "$REPO_DIR/themes" ] && cp -r "$REPO_DIR/themes/"* ~/.config/omarchy/themes/

# 6. Install custom scripts to user bin
echo "Installing custom scripts to ~/bin..."
mkdir -p ~/bin
if [ -d "$REPO_DIR/bin" ]; then
    cp -r "$REPO_DIR/bin/"* ~/bin/
    chmod +x ~/bin/*
fi

# 7. Ensure ~/bin is in PATH
echo "Configuring PATH in shell config files..."
BASH_PATH_LINE='export PATH="$HOME/bin:$PATH"'
# Bash
if [ -f ~/.bashrc ] && ! grep -qF "$BASH_PATH_LINE" ~/.bashrc; then
    echo -e "\n# Tecpatl-OS Binaries\n$BASH_PATH_LINE" >> ~/.bashrc
fi
# Zsh
if [ -f ~/.zshrc ] && ! grep -qF "$BASH_PATH_LINE" ~/.zshrc; then
    echo -e "\n# Tecpatl-OS Binaries\n$BASH_PATH_LINE" >> ~/.zshrc
fi
# Fish
if [ -f ~/.config/fish/config.fish ] && ! grep -q 'fish_add_path ~/bin' ~/.config/fish/config.fish; then
    echo -e "\n# Tecpatl-OS Binaries\nfish_add_path ~/bin" >> ~/.config/fish/config.fish
fi

echo "Hyprland configuration complete. Key shortcuts: Super+Space (Launcher), Super+Enter (Terminal)."
