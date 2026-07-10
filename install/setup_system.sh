#! /bin/bash
# setup_system.sh - System post install

set -euo pipefail

echo "Post install setup..."

# sudo dnf group upgrade -y core
# sudo dnf4 group install -y core

# echo "Updating firmware..."
# fwupdmgr refresh --force
# fwupdmgr get-devices # Lists devices with available updates.
# fwupdmgr get-updates # Fetches list of available updates.
# fwupdmgr update

echo "Setting up third-party repositories for sync applications..."

# 1. Enable RPM Fusion Free and Nonfree repositories (required for nautilus-dropbox)
# if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
#   echo "Installing RPM Fusion Free and Nonfree repositories..."
#   sudo dnf install -y \
#     https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# fi

# 2. Add MEGA repository (required for megasync and nautilus-megasync)
if [ ! -f /etc/yum.repos.d/megasync.repo ]; then
  echo "Adding MEGA repository..."
  sudo tee /etc/yum.repos.d/megasync.repo <<'EOF'
[MEGAsync]
name=MEGAsync
baseurl=https://mega.nz/linux/repo/Fedora_$releasever/
gpgkey=https://mega.nz/linux/repo/Fedora_$releasever/repodata/repomd.xml.key
gpgcheck=1
enabled=1
EOF
fi

# 3. Add Remember The Milk repository
if [ ! -f /etc/yum.repos.d/rememberthemilk.repo ]; then
  echo "Adding Remember The Milk repository..."
  sudo tee /etc/yum.repos.d/rememberthemilk.repo <<'EOF'
[rememberthemilk]
name=rememberthemilk
baseurl=https://www.rememberthemilk.com/download/linux/fedora/21/x86_64
enabled=1
gpgcheck=1
gpgkey=https://www.rememberthemilk.com/download/rememberthemilk-pkg.asc
EOF
fi

if [ ! -f /etc/yum.repos.d/terra.repo ]; then
  echo "Adding Terra repository..."
  sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

SKIP_NVIDIA=false
SKIP_VIRTUALBOX=false
for arg in "$@"; do
  [[ "$arg" == "--skip-nvidia" ]] && SKIP_NVIDIA=true
  [[ "$arg" == "--skip-virtualbox" ]] && SKIP_VIRTUALBOX=true
done

if [ "$SKIP_NVIDIA" = false ]; then
  echo "Installing NVidia drivers..."
  sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
fi

if [ "$SKIP_VIRTUALBOX" = false ]; then
  echo "Installing VirtualBox..."
  sudo dnf install -y VirtualBox akmod-VirtualBox
  sudo usermod -a -G vboxusers "$USER"
fi

echo "Installing Media Codecs..."
sudo dnf4 group install -y multimedia
sudo dnf swap -y 'ffmpeg-free' 'ffmpeg' --allowerasing                                                  # Switch to full FFMPEG.
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.
sudo dnf group install -y sound-and-video                                                               # Installs useful Sound and Video complementary packages.

sudo dnf install -y ffmpeg-libs libva libva-utils
sudo dnf swap -y libva-intel-media-driver intel-media-driver --allowerasing
sudo dnf install -y libva-intel-driver

sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

echo "Custom DNS Servers..."
sudo mkdir -p '/etc/systemd/resolved.conf.d' && sudo -e '/etc/systemd/resolved.conf.d/99-dns-over-tls.conf'

[Resolve]
DNS=1.1.1.2#security.cloudflare-dns.com 1.0.0.2#security.cloudflare-dns.com 2606:4700:4700::1112#security.cloudflare-dns.com 2606:4700:4700::1002#security.cloudflare-dns.com
DNSOverTLS=yes
Domains=~.

echo "Disable Gnome Software from Startup Apps..."
sudo rm /etc/xdg/autostart/org.gnome.Software.desktop

echo "Installing applications..."
sudo dnf install -y unzip p7zip p7zip-plugins unrar arj file-roller thunar

echo "Installing communication and sync applications..."
sudo dnf install -y thunderbird ulauncher megasync nautilus-megasync nautilus-dropbox rememberthemilk

echo "Installing games and applications..."
sudo dnf install -y baobab blender chromium clamav cowsay deja-dup dropbox eza gimp \
  gnome-browser-connector gnome-contacts gnome-epub-thumbnailer gnome-maps gnome-pomodoro \
  nautilus-gsconnect strawberry Thunar thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman \
  tomboy transmission trash-cli vlc cheat-community-cheatsheets cheat-fish-completion eza-bash-completion
