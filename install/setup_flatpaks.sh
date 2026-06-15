#!/bin/bash
# setup_flatpaks.sh - "El pedernal que forja el código"
# Massive Flatpak application install for Tecpatl-OS

echo "Configuring Flatpak repositories and applications..."

# 1. Ensure the Flathub repository is enabled
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 2. Application list organized by category
APPS=(
    # AI & Development
    "ai.opencode.opencode"
    "io.github.qwersyk.Newelle"
    "io.podman_desktop.PodmanDesktop"
    "com.getpostman.Postman"
    "rest.insomnia.Insomnia"
    "io.github.shiftey.Desktop"
    "com.umlet.Umlet"
    "org.kde.umbrello"

    # Gaming & Compatibility Tools
    "com.heroicgameslauncher.hgl"
    "com.github.Matoking.protontricks"
    "com.vysp3r.ProtonPlus"
    "io.mrarm.mcpelauncher"
    "ca.victorz.acr.AssaultCubeReloaded"
    "com.epicgames.ut2004"
    "com.github.iortcw.iortcw"
    "net.tabletopclub.TabletopClub"
    "io.github.tfuxu.floodit"
    "it.mijorus.gearlever"

    # Browsers & Communication
    "io.gitlab.librewolf-community"
    "app.zen_browser.zen"
    "org.garudalinux.firedragon"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "us.zoom.Zoom"
    "im.riot.Riot"
    "org.gnome.Fractal"
    "org.eu.encom.spectral"
    "org.kde.tokodon"
    "com.github.vladimiry.ElectronMail"
    "eu.betterbird.Betterbird"

    # Productivity & Office
    "md.obsidian.Obsidian"
    "me.proton.Pass"
    "app.drey.Dialect"
    "org.gnome.Books"

    # Multimedia & Creativity
    "org.audacityteam.Audacity"
    "org.kde.kdenlive"
    "io.github.jliljebl.Flowblade"
    "no.mifi.losslesscut"
    "org.shotcut.Shotcut"
    "org.olivevideoeditor.Olive"
    "org.openshot.OpenShot"
    "com.spotify.Client"
    "com.warlordsoftwares.media-downloader"
    "org.nickvision.tubeconverter"
    "org.mediaharbor.MediaHarbor"

    # System Utilities & GNOME
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "io.github.flattool.Warehouse"
    "io.missioncenter.MissionCenter"
    "page.tesk.Refine"
)

# 3. Installation loop
for APP in "${APPS[@]}"; do
    echo "Installing $APP..."
    flatpak install -y flathub "$APP"
done

# 4. Apply theme permissions (Visual Consistency)
# Fixes GNOME theme issues in Flatpaks
echo "Applying visual consistency settings..."
flatpak override --user --filesystem=$HOME/.themes:ro
flatpak override --user --filesystem=$HOME/.icons:ro
flatpak override --user --env=GTK_THEME=Adwaita-dark

echo "Installing AppImage support ..."
sudo dnf install -y fuse-libs

echo "Flatpak installation complete."
