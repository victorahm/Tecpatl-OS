#!/bin/bash

sudo dnf install -y steam mangohud gamescope aisleriot brutalchess dreamchess extremetuxracer gnome-2048 gnome-chess gnome-mahjongg \
  gnome-mines minetest pychess stockfish

# Launchers y herramientas de optimización (Flatpak y RPM)
flatpak install flathub com.github.Matoking.protontricks com.vysp3r.ProtonPlus -y
flatpak install flathub com.heroicgameslauncher.hgl org.lutris.Lutris -y

# Emuladores y soporte Android
sudo dnf install -y waydroid
flatpak install flathub io.mrarm.mcpelauncher -y # Minecraft Bedrock [9]
# Prompt: Añadir instalación de emuladores para Gameboy y DOS [17]
