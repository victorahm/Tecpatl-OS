#!/bin/bash
# Misión: "El pedernal que forja el código y corta el lag" [1]

echo "Iniciando instalación de Tecpatl-OS..."

chmod +x install/setup_*.sh

./install/setup_gnome.sh
./install/setup_gaming.sh
./install/setup_hyprland.sh
./install/setup_dev.sh

cat << 'EOF' > /usr/local/bin/update-tecpatl
#!/bin/bash
echo "--- Iniciando actualización de Tecpatl-OS ---"

# 1. Actualización de Repositorio de Scripts (Opcional)
# echo "Sincronizando scripts de Tecpatl-OS..."
# cd ~/tu-repo-scripts && git pull

# 2. Actualización de Sistema (Fedora RPMs)
echo "Actualizando paquetes DNF..."
sudo dnf upgrade -y

# 3. Actualización de Aplicaciones Flatpak
echo "Actualizando Flatpaks..."
flatpak update -y

# 4. Actualización de Neovim (LazyVim)
if command -v nvim &> /dev/null; then
    echo "Sincronizando plugins de LazyVim..."
    nvim --headless "+Lazy! sync" +qa
fi

# 5. Limpieza de sistema (similar a Omarchy-pkg-drop)
echo "Limpiando paquetes innecesarios..."
sudo dnf autoremove -y
flatpak uninstall --unused -y

echo "--- Sistema Actualizado con Éxito ---"
EOF

chmod +x /usr/local/bin/update-tecpatl


echo "Instalación completada. Reinicie para aplicar todos los cambios."
