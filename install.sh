#!/bin/bash
# Misión: "El pedernal que forja el código y corta el lag" [1]

echo "Iniciando instalación de Tecpatl-OS..."

chmod +x install/setup_*.sh

./install/setup_system.sh
./install/setup_gnome.sh
./install/setup_gaming.sh
./install/setup_hyprland.sh
./install/setup_dev.sh
./install/setup_flatpaks.sh

cat << 'EOF' > /usr/local/bin/update-tecpatl
#!/bin/bash
echo "--- Starting Tecpatl-OS Update ---"

# 1. Scripts Repository Update (Optional)
# echo "Syncing Tecpatl-OS scripts..."
# cd ~/tu-repo-scripts && git pull

# 2. System Update (Fedora RPMs)
echo "Updating DNF packages..."
sudo dnf upgrade -y

# 3. Flatpak Applications Update
echo "Updating Flatpaks..."
flatpak update -y

# 4. Neovim Update (LazyVim)
if command -v nvim &>/dev/null; then
  echo "Syncing LazyVim plugins..."
  nvim --headless "+Lazy! sync" +qa
fi

# 5. Fisher Update (Fish plugins)
if command -v fish &>/dev/null; then
  echo "Updating Fisher plugins..."
  fish -c "fisher update"
fi

# 6. Homebrew Update
if command -v brew &>/dev/null; then
  echo "Updating Homebrew and packages..."
  brew update
  brew upgrade
  brew cleanup
fi

# 7. Mise Update
if command -v mise &>/dev/null; then
  echo "Updating mise..."
  sudo mise self-update -y
fi

# 8. System Cleanup (similar to Omarchy-pkg-drop)
echo "Cleaning up unnecessary packages..."
sudo dnf autoremove -y
flatpak uninstall --unused -y

echo "--- System Successfully Updated ---"

EOF

chmod +x /usr/local/bin/update-tecpatl


echo "Instalación completada. Reinicie para aplicar todos los cambios."
