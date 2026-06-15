#!/bin/bash
# setup_gnome.sh - GNOME Shell UI & Experience Configuration
# "The flint that forges the code and cuts the lag"

set -euo pipefail

echo "Starting GNOME customization for Tecpatl-OS..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Base Tools & DNF Extensions ─────────────────────────────────────────────
echo "Installing GNOME tools and DNF-available extensions..."
sudo dnf install -y gnome-tweaks gnome-extensions-app dconf-editor pipx \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-gsconnect \
  gnome-shell-extension-just-perfection \
  gnome-shell-extension-user-theme \
  gnome-shell-extension-window-list \
  gnome-shell-extension-apps-menu

# ── 2. Install gnome-extensions-cli via pipx ───────────────────────────────────
echo "Installing gnome-extensions-cli (gext) via pipx..."
pipx install gnome-extensions-cli 2>/dev/null || pipx upgrade gnome-extensions-cli 2>/dev/null || true
# Ensure pipx bin dir is on PATH for this session
export PATH="$HOME/.local/bin:$PATH"

# ── 3. Install Non-DNF Extensions via gext ─────────────────────────────────────
echo "Installing extensions from extensions.gnome.org via gext..."

GEXT_EXTENSIONS=(
  "logomenu@aryan_k"
  "tilingshell@ferrarodomenico.com"
  "weatheroclock@CleoMenezesJr.github.io"
  "autohide-battery@sitnik.ru"
  "auto-power-profile@dmy3k.github.io"
  "Bluetooth-Battery-Meter@maniacx.github.com"
  "dim-completed-calendar-events@marcinjahn.com"
  "fullscreen-avoider@noobsai.github.com"
  "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
  "lockkeys@febueldo.test"
  "task-widget@juozasmiskinis.gitlab.io"
  "todo.txt@bart.libert.gmail.com"
  "wellbeingtoggle@m51.io"
  "CoverflowAltTab@palatis.blogspot.com"
  "hotedge@jonathan.jdoda.ca"
  "supergfxctl-gex@asus-linux.org"
)

for ext in "${GEXT_EXTENSIONS[@]}"; do
  echo "  Installing: $ext"
  gext --filesystem install "$ext" || echo "  Warning: Failed to install $ext — skipping."
done

# ── 4. Enable All Extensions ──────────────────────────────────────────────────
echo "Enabling all extensions..."

ALL_EXTENSIONS=(
  # DNF-installed extensions
  "appindicatorsupport@rgcjonas.gmail.com"
  "blur-my-shell@aunetx"
  "caffeine@patapon.info"
  "gsconnect@andyholmes.github.io"
  "just-perfection-desktop@just-perfection"
  "user-theme@gnome-shell-extensions.gcampax.github.com"
  "window-list@gnome-shell-extensions.gcampax.github.com"
  "apps-menu@gnome-shell-extensions.gcampax.github.com"
  # gext-installed extensions
  "logomenu@aryan_k"
  "tilingshell@ferrarodomenico.com"
  "weatheroclock@CleoMenezesJr.github.io"
  "autohide-battery@sitnik.ru"
  "auto-power-profile@dmy3k.github.io"
  "Bluetooth-Battery-Meter@maniacx.github.com"
  "dim-completed-calendar-events@marcinjahn.com"
  "fullscreen-avoider@noobsai.github.com"
  "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
  "lockkeys@febueldo.test"
  "task-widget@juozasmiskinis.gitlab.io"
  "todo.txt@bart.libert.gmail.com"
  "wellbeingtoggle@m51.io"
  "CoverflowAltTab@palatis.blogspot.com"
  "hotedge@jonathan.jdoda.ca"
  "supergfxctl-gex@asus-linux.org"
)

for ext in "${ALL_EXTENSIONS[@]}"; do
  gnome-extensions enable "$ext" 2>/dev/null || echo "  Note: Could not enable $ext (GNOME Shell may not be running)."
done

# ── 5. macOS-Style Keyboard Shortcuts ─────────────────────────────────────────
# Using Super as the equivalent of macOS Cmd key
echo "Applying macOS-style keyboard shortcuts..."

# --- Window Management ---
# Cmd+W → Close window
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
# Cmd+H → Minimize/hide window
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']"
# Cmd+F → Toggle fullscreen
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
# Cmd+Tab → Switch applications (like macOS app switcher)
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
# Cmd+` → Switch windows within same application
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Shift><Super>Above_Tab']"
# Alt+Tab → Switch windows (all windows, not just apps)
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
# Cmd+Alt+Esc → Force quit
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['<Alt>space']"
# Toggle maximized
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>F10']"

# --- Workspace Navigation (Ctrl-based, like macOS Mission Control) ---
# Ctrl+Left/Right → Switch workspace
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right']"
# Ctrl+Shift+Left/Right → Move window to workspace
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Shift>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Shift>Right']"
# Ctrl+Up → Mission Control (overview)
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control>Down']"
# Ctrl+1/2/3/4 → Switch to specific workspace (disabled default Super+N app switching first)
gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Control>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Control>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Control>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Control>4']"

# --- System Shortcuts ---
# Cmd+Space → Search (Spotlight equivalent, via GNOME search)
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>space']"
# Cmd+, → System Settings/Preferences
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>comma']"
# Cmd+L → Lock screen
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
# Cmd+A → Show all applications (Launchpad equivalent)
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"
# Cmd+N → Focus notifications
gsettings set org.gnome.shell.keybindings focus-active-notification "['<Super>n']"
# Cmd+V / Cmd+M → Toggle message tray (notification center)
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>v', '<Super>m']"
# Cmd+S → Toggle quick settings
gsettings set org.gnome.shell.keybindings toggle-quick-settings "['<Super>s']"

# --- Screenshots (macOS-style) ---
# Cmd+Shift+3 → Full screenshot
gsettings set org.gnome.shell.keybindings screenshot "['<Super><Shift>3']"
# Cmd+Shift+4 → Window screenshot
gsettings set org.gnome.shell.keybindings screenshot-window "['<Super><Shift>4']"
# Cmd+Shift+5 → Screenshot UI (selection, record, etc.)
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>5']"
# Cmd+Shift+6 → Screen recording UI
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Super><Shift>6']"

# --- Overview ---
# Cmd+Z → Toggle overview (Activities)
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>z']"

# --- Monitor Switching ---
gsettings set org.gnome.mutter.keybindings switch-monitor "['<Super>p', 'XF86Display']"

# ── 6. Custom Keybindings ─────────────────────────────────────────────────────
echo "Setting up custom keyboard shortcuts..."

# Register custom keybinding paths
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', \
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', \
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', \
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

# Custom 0: Super+T → Open Ghostty terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ghostty +new-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'

# Custom 1: Ctrl+Alt+Delete → Mission Center (like macOS Activity Monitor)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Mission Center'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flatpak run io.missioncenter.MissionCenter'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control><Alt>KP_Delete'

# Custom 2: Ctrl+Shift+Escape → Mission Center (Windows-style alternative)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Mission Center'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'flatpak run io.missioncenter.MissionCenter'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Control><Shift>Escape'

# Custom 3: Ctrl+Space → ULauncher (Spotlight-style launcher)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'ULauncher'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'ulauncher-toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Control>space'

echo "GNOME configuration completed. A session restart is recommended."
