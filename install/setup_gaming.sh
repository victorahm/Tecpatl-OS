#!/bin/bash
# Drivers de video Nvidia y capas de compatibilidad
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
sudo dnf install -y steam mangohud gamescope

# Launchers y herramientas de optimización (Flatpak y RPM)
flatpak install flathub com.github.Matoking.protontricks com.vysp3r.ProtonPlus -y
flatpak install flathub com.heroicgameslauncher.hgl org.lutris.Lutris -y

# Emuladores y soporte Android
sudo dnf install -y waydroid
flatpak install flathub io.mrarm.mcpelauncher -y # Minecraft Bedrock [9]
# Prompt: Añadir instalación de emuladores para Gameboy y DOS [17]
