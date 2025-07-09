#!/bin/sh
#
# Author: Lucas Gracioso (contact@lbgracioso.net)
#
# This script automates the installation of some applications,
# development tools and utilities I use.
#
# Note: Some applications may require user intervention, so ensure
# you review the process as it runs.

installGameLaunchers()
{
  echo "Installing game launchers..."
  dnf install steam
}

installRazer()
{
  echo "Installing Razer tools..."
  dnf config-manager addrepo --from-repofile=https://openrazer.github.io/hardware:razer.repo
  dnf install polychromatic
}

installFlatpakApps()
{
  echo "Installing general Flatpak apps..."

  apps=(
    "com.discordapp.Discord"
    "com.mattjakeman.ExtensionManager"
    "com.spotify.Client"
    "io.dbeaver.DBeaverCommunity"
    "it.mijorus.gearlever"
    "org.telegram.desktop"
    "net.lutris.Lutris"
    "rest.insomnia.Insomnia"
    "org.mozilla.Thunderbird"
    "md.obsidian.Obsidian"
    "org.onlyoffice.desktopeditors"
    "io.github.alainm23.planify"
    "org.keepassxc.KeePassXC"
  )

  for app in "${apps[@]}"; do
    flatpak install -y flathub "$app"
  done
}

installVagrantPlugins()
{
  echo "Installing Vagrant plugins..."
  vagrant plugin install vagrant-libvirt
}

installWorkOps()
{
  echo "Installing work ops tools..."
  dnf -y install podman qemu-kvm vagrant libvirt ansible
}

installWorkDev()
{
  echo "Installing work dev tools..."
  dnf -y install gcc-c++ cmake gdb
}

installWork()
{
  echo "Installing work tools..."
  installWorkOps
  installWorkDev
}

installPrinterDrivers()
{
  echo "Installing printer drivers..."
  dnf -y install epson-inkjet-printer-escpr
}

warnToDos()
{
  breakLine
  echo "⚠️  What's left to do:"

  todos=(
    "Install JetBrains Toolbox"
    "Install GNOME Extensions (Apps Menu, Dash to Dock, Places Status Indicator, Tray Icons: Reloaded, Desktop Icons NG (DING), Timer)"
    "Configure SSH and GPG Keys (for GitHub)"
  )

  for i in "${!todos[@]}"; do
    echo "$((i + 1)). ${todos[i]}"
  done
  breakLine
}

checkPrivileges()
{
  if [ "$EUID" -eq 0 ]; then
    return
  fi

  echo "This script must be run as root."
  read -r -p "Do you want to restart it with sudo? (y/N): " user_input

  case "${user_input,,}" in
    y|yes)
      echo "Re-running the script with sudo..."
      exec sudo "$0" "$@"
      ;;
    *)
      echo "Exiting script..."
      exit 1
      ;;
  esac
}

breakLine()
{
  echo -e "\n"
}

run()
{
  echo "###########################################"
  echo "#            Starting setup...           #"
  echo "###########################################"
  breakLine

  installFlatpakApps
  installGameLaunchers
  installRazer
  installWork
  warnToDos

  breakLine
  echo "###########################################"
  echo "#             Setup done! Enjoy ;)        #"
  echo "###########################################"
}

checkPrivileges
run
