#!/bin/bash
# setup_flatpaks.sh - "El pedernal que forja el código"
# Instalación masiva de aplicaciones Flatpak para Tecpatl-OS

echo "Configurando repositorios y aplicaciones Flatpak..."

# 1. Asegurar que el repositorio Flathub esté habilitado
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 2. Lista de aplicaciones extraídas de FlatpacksBazzite.txt
# Organizadas por categorías para facilitar el mantenimiento
APPS=(
    # IA y Desarrollo [1, 5, 6, 13]
    "ai.opencode.opencode" 
    "io.github.qwersyk.Newelle"
    "io.podman_desktop.PodmanDesktop"
    "com.getpostman.Postman"
    "rest.insomnia.Insomnia"
    "io.github.shiftey.Desktop"
    "com.umlet.Umlet"
    "org.kde.umbrello"

    # Gaming y Herramientas de Compatibilidad [1-7, 12, 13]
    "com.heroicgameslauncher.hgl"
    "com.github.Matoking.protontricks"
    "com.vysp3r.ProtonPlus"
    "io.mrarm.mcpelauncher"
    "ca.victorz.acr.AssaultCubeReloaded"
    "com.epicgames.ut2004"
    "com.github.iortcw.iortcw"
    "com.github.sakya.corechess"
    "com.rq3.Reaction"
    "info.urbanterror.UrbanTerror"
    "io.github.ec_.Quake3e.OpenArena"
    "io.github.lavenderdotpet.LibreQuake"
    "net.sourceforge.DuneLegacy"
    "net.sourceforge.ExtremeTuxRacer"
    "net.tabletopclub.TabletopClub"
    "org.gnome.Chess"
    "org.luanti.luanti"
    "org.megaglest.MegaGlest"
    "org.sauerbraten.Sauerbraten"

    # Navegadores y Comunicación [3-5, 7, 9, 12, 14]
    "io.gitlab.librewolf-community"
    "com.opera.Opera"
    "org.mozilla.firefox"
    "org.chromium.Chromium"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "us.zoom.Zoom"
    "im.riot.Riot"
    "org.gnome.Fractal"
    "org.eu.encom.spectral"
    "org.kde.tokodon"

    # Productividad y Oficina [1, 6, 11, 12]
    "md.obsidian.Obsidian"
    "me.proton.Pass"
    "com.dropbox.Client"
    "org.mozilla.Thunderbird"
    "org.keepassxc.KeePassXC"
    "org.gnucash.GnuCash"
    "app.drey.Dialect"

    # Multimedia y Creatividad [3, 4, 7, 8, 11, 13]
    "org.videolan.VLC"
    "org.blender.Blender"
    "org.gimp.GIMP"
    "org.inkscape.Inkscape"
    "org.audacityteam.Audacity"
    "org.kde.kdenlive"
    "io.github.jliljebl.Flowblade"
    "no.mifi.losslesscut"
    "org.shotcut.Shotcut"
    "org.olivevideoeditor.Olive"
    "org.openshot.OpenShot"
    "com.spotify.Client"
    "org.strawberrymusicplayer.strawberry"
    "com.warlordsoftwares.media-downloader"
    "org.nickvision.tubeconverter"

    # Utilidades de Sistema y GNOME [2, 5-7, 9-11]
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "io.github.flattool.Warehouse"
    "io.missioncenter.MissionCenter"
    "org.gnome.Extensions"
    "org.gnome.baobab"
    "org.gnome.DejaDup"
    "org.gnome.Logs"
    "org.fedoraproject.MediaWriter"
)

# 3. Bucle de instalación
for APP in "${APPS[@]}"; do
    echo "Instalando $APP..."
    flatpak install -y flathub "$APP"
done

# 4. Aplicar permisos para temas (Coherencia Visual)
# Esto soluciona el problema de los temas de GNOME en Flatpaks [17]
echo "Aplicando configuraciones de coherencia visual..."
flatpak override --filesystem=$HOME/.themes:ro
flatpak override --filesystem=$HOME/.icons:ro
flatpak override --env=GTK_THEME=Adwaita-dark # O tu tema prehispánico preferido

echo "Instalación de Flatpaks completada."
