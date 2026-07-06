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

# Mise - COPR by jdxcode
sudo dnf copr enable -y jdxcode/mise

# Warp Terminal — official RPM repository
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
sudo sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'

# Antigravity — official RPM repository
sudo tee /etc/yum.repos.d/antigravity.repo <<EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

# Visual Studio Code — official Microsoft RPM repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

# VirtualBox — RPM Fusion Free repository
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# ── 1. High-performance terminals ─────────────────────────────────────────────
sudo dnf install -y ghostty warp-terminal

# ── 2. Base Languages and Tools (DNF) ─────────────────────────────────────────
# Common shell improvements from Omarchy + VS Code
sudo dnf install -y neovim fish starship fastfetch \
  fzf ripgrep zoxide lazygit lazydocker \
  eza bat fd-find mise code # Visual Studio Code

# Set fish as the default shell for the current user
echo "Setting fish as default shell..."
sudo chsh -s $(which fish) "$USER"

# Install Fisher (plugin manager for fish shell)
echo "Installing Fisher plugin manager..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Install Fish plugins via Fisher
echo "Installing Fish plugins..."
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "fisher install nickeb96/puffer-fish"

# ── 2b. Homebrew (Linuxbrew) ──────────────────────────────────────────────────
echo "Installing Homebrew..."

# Build dependencies required by Homebrew on Fedora
sudo dnf group install -y "Development Tools"
sudo dnf install -y procps-ng curl file git

# Run official Homebrew installer (non-interactive, no prompts)
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make brew available for the rest of this script (fish config is in section 6)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
  distrobox toolbox gnome-boxes

# ── 4. AI Agents (Flatpak and CLI) ────────────────────────────────────────────
sudo dnf install -y antigravity
flatpak install flathub ai.opencode.opencode -y      # OpenCode [21, 22]
flatpak install flathub io.github.qwersyk.Newelle -y # Newelle [24]

# Claude Code and Gemini CLI (usually require Node.js/NPM)
sudo dnf install -y nodejs npm
curl -fsSL https://claude.ai/install.sh | bash # Claude Code [21]
sudo npm install -g @google/gemini-cli         # Gemini CLI
# Install Claude Desktop
sudo curl -fsSL https://pkg.claude-desktop-debian.dev/rpm/claude-desktop.repo -o /etc/yum.repos.d/claude-desktop.repo
sudo dnf install claude-desktop -y

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

cat <<EOF >$FISH_CONF
source (/usr/bin/starship init fish --print-full-init | psub)
setenv EDITOR nvim

set -Ux GOPATH $HOME/go
set -Ux PATH $PATH $HOME/go/bin

# Homebrew (Linuxbrew) shell integration
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

if status is-interactive
    alias lz "eza --icons --git -lZ"
    alias ls "eza --icons"
    alias ll "eza --icons --long --git"

    alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'" # [10]
    alias c="opencode" # Alias for OpenCode AI agent [14]
    alias lg="lazygit" # [14]
    alias ld="lazydocker" # [26]

    set -x PATH $PATH ~/bin
    set -x PATH $PATH ~/.local/bin

    zoxide init fish | source
    /usr/bin/mise activate fish | source

    fastfetch
else
    /usr/bin/mise activate fish --shims | source
end
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

# ── Firefox Developer Edition ───────────────────────────────────────────────────
echo "Installing Firefox Developer Edition..."
FF_DEV_URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
FF_DEV_TAR="/tmp/firefox-developer.tar.xz"
FF_DEV_DIR="/opt/firefox-developer"

echo "Downloading Firefox Developer Edition..."
curl -L -o "$FF_DEV_TAR" "$FF_DEV_URL"

echo "Extracting Firefox Developer Edition to $FF_DEV_DIR..."
sudo rm -rf "$FF_DEV_DIR"
sudo mkdir -p "$FF_DEV_DIR"
sudo tar -xf "$FF_DEV_TAR" -C "$FF_DEV_DIR" --strip-components=1
rm -f "$FF_DEV_TAR"

# Create symbolic link
sudo ln -sf "$FF_DEV_DIR/firefox" /usr/local/bin/firefox-developer

# Create GNOME desktop entry
echo "Creating GNOME desktop shortcut for Firefox Developer Edition..."
sudo tee /usr/share/applications/firefox-developer.desktop <<'EOL'
[Desktop Entry]
Name=Firefox Developer Edition
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec=/opt/firefox-developer/firefox %u
Terminal=false
Type=Application
Icon=/opt/firefox-developer/browser/chrome/icons/default/default128.png
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=firefox-aurora
EOL

echo "Development setup completed."
echo "NOTE: A reboot is recommended to fully load VirtualBox kernel modules."
