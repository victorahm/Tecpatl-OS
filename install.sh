#!/bin/bash
# Misión: "El pedernal que forja el código y corta el lag" [1]

echo "Iniciando instalación de Tecpatl-OS..."

chmod +x install/setup_*.sh

./install/setup_gnome.sh
./install/setup_gaming.sh
./install/setup_hyprland.sh
./install/setup_dev.sh

# Crear comando 'update-tecpatl' (Inspirado en Topgrade de Omarchy)
# Prompt: Crear función que ejecute dnf update, flatpak update y
# actualice las extensiones de GNOME simultáneamente [2, 33]

echo "Instalación completada. Reinicie para aplicar todos los cambios."
