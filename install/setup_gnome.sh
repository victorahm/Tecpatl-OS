#!/bin/bash
# Instalación de herramientas base y extensiones RPM
sudo dnf install -y gnome-tweaks gnome-extensions-app dconf-editor \
  gnome-shell-extension-blur-my-shell gnome-shell-extension-burn-my-windows \
  gnome-shell-extension-caffeine gnome-shell-extension-gsconnect \
  gnome-shell-extension-just-perfection gnome-shell-extension-desktop-cube

# Aplicaciones de oficina y navegación (RPM y Flatpak)
sudo dnf install -y thunderbird ulauncher
flatpak install flathub io.gitlab.librewolf-community com.opera.Opera -y
flatpak install flathub com.dropbox.Client me.proton.Pass -y

# Configuración de sincronización de archivos (RPM)
sudo dnf install -y megasync nautilus-megasync nautilus-dropbox

# Configuración estética mínima vía dconf (MacOS style copy/paste)
# Prompt: Usar dconf para mapear Super+C y Super+V en GNOME [12, 13]
#
