#!/bin/bash
# setup_dev.sh - "The flint that forges the code"
# Inspired by Omarchy for Fedora 44

echo "Installing development tools (Tecpatl-OS)..."

# ── 0. Repository Setup ────────────────────────────────────────────────────────
echo "Setting up required repositories..."

# Ensure dnf-plugins-core is available (provides 'dnf copr')
sudo dnf install -y dnf-plugins-core

# Ghostty terminal — COPR by scottames
sudo dnf copr enable -y scottames/ghostty

# Starship prompt — COPR by atim
sudo dnf copr enable -y atim/starship

# Lazygit — COPR by dejan
sudo dnf copr enable -y dejan/lazygit

# Lazydocker — COPR by atim
sudo dnf copr enable -y atim/lazydocker

# Warp Terminal — official RPM repository
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
sudo sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'

# Antigravity — official RPM repository
sudo tee /etc/yum.repos.d/antigravity.repo << EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

# Visual Studio Code — official Microsoft RPM repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# VirtualBox — RPM Fusion Free repository
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# ── 1. High-performance terminals ─────────────────────────────────────────────
sudo dnf install -y ghostty warp-terminal

# ── 2. Base Languages and Tools (DNF) ─────────────────────────────────────────
# Common shell improvements from Omarchy + VS Code
sudo dnf install -y neovim fish starship fastfetch \
    fzf ripgrep zoxide lazygit lazydocker \
    eza bat fd-find \
    code              # Visual Studio Code

# Copy Starship configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARSHIP_CONFIG_SRC="$SCRIPT_DIR/../config/starship.toml"
STARSHIP_CONFIG_DEST="$HOME/.config/starship.toml"
mkdir -p "$HOME/.config"
if [ -f "$STARSHIP_CONFIG_SRC" ]; then
    cp "$STARSHIP_CONFIG_SRC" "$STARSHIP_CONFIG_DEST"
    echo "Starship configuration copied to $STARSHIP_CONFIG_DEST"
else
    echo "Warning: Starship config not found at $STARSHIP_CONFIG_SRC — skipping."
fi

# ── 3. Containers and Virtualization ──────────────────────────────────────────
sudo dnf install -y podman podman-compose docker-compose \
    distrobox toolbox gnome-boxes \
    VirtualBox akmod-VirtualBox

# Add current user to the vboxusers group
sudo usermod -a -G vboxusers "$USER"

# ── 4. AI Agents (Flatpak and CLI) ────────────────────────────────────────────
sudo dnf install -y antigravity
flatpak install flathub ai.opencode.opencode -y       # OpenCode [21, 22]
flatpak install flathub io.github.qwersyk.Newelle -y  # Newelle [24]

# Claude Code and Gemini CLI (usually require Node.js/NPM)
sudo dnf install -y nodejs npm
sudo npm install -g @anthropic-ai/claude-code # Claude Code [21]

# ── 5. Neovim Configuration (LazyVim for Ruby on Rails) ───────────────────────
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim
fi

# Copy custom LazyVim Lua configuration
NVIM_CONFIG_SRC="${SCRIPT_DIR}/../config/nvim/lua"
NVIM_CONFIG_DEST="$HOME/.config/nvim/lua"
if [ -d "$NVIM_CONFIG_SRC" ]; then
    cp -r "$NVIM_CONFIG_SRC/." "$NVIM_CONFIG_DEST/"
    echo "Neovim Lua configuration copied to $NVIM_CONFIG_DEST"
else
    echo "Warning: Neovim config not found at $NVIM_CONFIG_SRC — skipping."
fi

# ── 6. Omarchy Aliases and Functions ──────────────────────────────────────────
# Appended to the fish shell configuration file
FISH_CONF="$HOME/.config/fish/config.fish"
mkdir -p $(dirname $FISH_CONF)

cat <<EOF > $FISH_CONF
# Omarchy-style aliases
alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'" # [10]
alias c="opencode" # Alias for OpenCode AI agent [14]
alias lg="lazygit" # [14]
alias ld="lazydocker" # [26]

# Zoxide init [11]
zoxide init fish | source

# Starship prompt [8]
starship init fish | source

# Fastfetch on shell start [6]
fastfetch
EOF

# Copy Git configuration
GIT_CONFIG_SRC="$SCRIPT_DIR/../config/git"
GIT_CONFIG_DEST="$HOME/.config/git"
if [ -d "$GIT_CONFIG_SRC" ]; then
    cp -r "$GIT_CONFIG_SRC/." "$GIT_CONFIG_DEST/"
    echo "Git configuration copied to $GIT_CONFIG_DEST"
else
    echo "Warning: Git config not found at $GIT_CONFIG_SRC — skipping."
fi

# Copy Ghostty configuration
GHOSTTY_CONFIG_SRC="$SCRIPT_DIR/../config/ghostty"
GHOSTTY_CONFIG_DEST="$HOME/.config/ghostty"
if [ -d "$GHOSTTY_CONFIG_SRC" ]; then
    mkdir -p "$GHOSTTY_CONFIG_DEST"
    cp -r "$GHOSTTY_CONFIG_SRC/." "$GHOSTTY_CONFIG_DEST/"
    echo "Ghostty configuration copied to $GHOSTTY_CONFIG_DEST"
else
    echo "Warning: Ghostty config not found at $GHOSTTY_CONFIG_SRC — skipping."
fi

# Copy OpenCode configuration
OPENCODE_CONFIG_SRC="$SCRIPT_DIR/../config/opencode"
OPENCODE_CONFIG_DEST="$HOME/.config/opencode"
if [ -d "$OPENCODE_CONFIG_SRC" ]; then
    mkdir -p "$OPENCODE_CONFIG_DEST"
    cp -r "$OPENCODE_CONFIG_SRC/." "$OPENCODE_CONFIG_DEST/"
    echo "OpenCode configuration copied to $OPENCODE_CONFIG_DEST"
else
    echo "Warning: OpenCode config not found at $OPENCODE_CONFIG_SRC — skipping."
fi

# ── 7. Web Development Tools (Optional - Omarchy Style) ───────────────────────
# Postman and Insomnia for APIs
flatpak install flathub com.getpostman.Postman rest.insomnia.Insomnia -y # [22, 28]

echo "Development setup completed."
echo "NOTE: A reboot is recommended to fully load VirtualBox kernel modules."