#!/bin/bash

# For use with Debian 12 using KDE
# Authored by JAM

### Variables
## LAN you wish to allow connections from:
# LAN="192.168.1.0/24"
## Specific IP allowed to connect to this host:
# IP="192.168.1.100"

# Fix Wifi
sudo echo "options iwlwifi led_mode=1 power_save=0 swcrypto=1 bt_coex_active=0 11n_disable=8" > /etc/modprobe.d/iwlwifi.conf

# Basics
sudo apt update
sudo apt install -y nala && sudo nala upgrade
sudo nala --install-completion bash
sudo nala --show-completion bash
# Only keep the top 5 fastest mirrors
# sudo nala fetch 1,2,3,4,5

# Aliases
echo "alias ll='ls -la" >> ~/.bashrc

# Flatpak Execution
printf "\n\n# Flatpak_Execution\ncodium(){\n(flatpak run com.vscodium.codium $*)\n}\n"  >> ~/.bashrc

# Become Root
sudo su -

### Add Repos
printf "\n# Extra Repos\ndeb http://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo sed -i 's/bookworm/stable/g' /etc/apt/sources.list
sudo sed -i 's/bookworm/stable/g' /etc/apt/sources.list.d/nala-sources.list

## If you want to put your big boy pants on - go to the testing branch instead (rolling release):
# sudo sed -i 's/bookworm/testing/g' /etc/apt/sources.list
# sudo sed -i 's/bookworm/testing/g' /etc/apt/sources.list.d/nala-sources.list

## If you giant PP, go to sid (unstable branch, newest packages):
# sudo sed -i 's/bookworm/sid/g' /etc/apt/sources.list
# sudo sed -i 's/bookworm/sid/g' /etc/apt/sources.list.d/nala-sources.list

## Remove the empty lines from the nala-sources.list file
sudo sed -i '/^[[:space:]]*$/d' /etc/apt/sources.list.d/nala-sources.list

## Add the additional components to the nala-sources.list repos
sudo sed -ie '2,$ s/$/ contrib non-free non-free-firmware/' /etc/apt/sources.list.d/nala-sources.list
sudo nala update

# Crontab
sudo echo "0 3 * * 0 /usr/bin/nala upgrade -y" >> /etc/crontab
sudo echo "0 3 * * * /usr/bin/flatpak upgrade -y" >> /etc/crontab

# Back to user-mode
exit

# Adding Packages
sudo nala install -y default-jre htop curl preload firmware-linux firmware-linux-nonfree firmware-misc-nonfree firmware-realtek build-essential ufw pcscd "7zip" vim flatpak snapd timeshift xrdp ssh steam-devices neofetch fonts-liberation synaptic nvidia-driver

### Removing and Cleaning Packages
## Remove KDE Apps/Bloatware
sudo nala purge -y kwalletmanager kate kmouth knotes kmag imagemagick-6.q16 korganizer kmail kwrite kaddressbook dragonplayer juk kontrast okular firefox-esr konqueror "libreoffice*" kde-spectacle xterm akregator
## Remove Gnome Apps/Bloatware
sudo nala purge -y gnome-keyring* aisleriot baobab cheese eog evince evolution file-roller firefox-esr five-or-more four-in-a-row gedit gnome-2048 gnome-calculator gnome-calendar gnome-characters gnome-chess gnome-clocks gnome-color-manager gnome-contacts gnome-disk-utility gnome-documents gnome-font-viewer gnome-klotski gnome-logs gnome-mahjongg gnome-maps gnome-mines gnome-music gnome-nibbles gnome-robots gnome-screenshot gnome-software gnome-sound-recorder gnome-shell-extension-prefs gnome-sudoku gnome-system-monitor gnome-taquin gnome-tetravex gnome-todo gnome-tweaks gnome-weather hitori iagno im-config libreoffice-calc libreoffice-common libreoffice-draw libreoffice-impress libreoffice-writer lightsoff malcontent nautilus quadrapassel rhythmbox seahorse shotwell simple-scan software-properties-gtk swell-foop tali totem transmission-gtk yelp 
## Remove gnome desktop environment completely
# sudo purge gnome-core task-gnome-desktop totem-plugins gnome-shell gnome-session gnome
sudo nala clean
sudo nala autoremove -y

# Enable services
sudo systemctl enable xrdp
sudo systemctl enable ssh

### App-Outlet Config - issues in X11, should run fine with Wayland sessions
# wget https://github.com/AppOutlet/AppOutlet/releases/download/v2.1.0/app-outlet_2.1.0_amd64.deb
# sudo dpkg -i ~/Downloads/app-outlet_2.1.0_amd64.deb
# rm ~/Downloads/app-outlet_2.1.0_amd64.deb
## App-image version:
# wget https://github.com/AppOutlet/AppOutlet/releases/download/v2.1.0/App.Outlet-2.1.0.AppImage

# AppImageLauncher Config
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
sudo dpkg -i ~/Downloads/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
rm ~/Downloads/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb

# Virtual Box -- Still in testing!! // 4 July 23
wget https://www.virtualbox.org/download/testcase/virtualbox-7.0_7.0.9-158050~Debian~bookworm_amd64.deb
sudo dpkg -i virtualbox-7.0_7.0.9-158050~Debian~bookworm_amd64.deb
rm ~/Downloads/virtualbox-7.0_7.0.9-158050~Debian~bookworm_amd64.deb

# Flatpak Config
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for i in $(cat flatpaks.txt); do sudo flatpak install -y $i; done

# Snaps
# lol, jk.

# ufw enable - tune to your local lan
sudo ufw enable
# sudo ufw allow from $LAN
# sudo ufw allow from $IP

### Prep for Downloads
cd ~/Downloads

### Install Java
wget https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248763_8c876547113c4e4aab3c868e9e0ec572



### VMWare Horizon Client (AFRC VPN)
wget https://download3.vmware.com/software/CART24FQ1_LIN64_2303/VMware-Horizon-Client-2303-8.9.0-21435420.x64.bundle
chmod +x ~/Downloads/VMWare-Horizon-Client-2303-8.9.0-21435420.x64.bundle
sudo ~/Downloads/VMWare-Horizon-Client-2303-8.9.0-21435420.x64.bundle

### CAC Reader and DOD CA crap
# Smart Card Packages   
sudo nala install -y vsmartcard-vpcd pcsc-tools coolkey librust-pcsc-dev 
sudo systemctl enable pcscd
sudo systemctl start pcscd

### Grab Veikk Stylus Driver
wget https://veikk.com/image/catalog/Software/vktabletUbuntu-1.0.3-2-x86_64.zip?v=1660637356
unzip ~/Downloads/vktabletUbuntu-1.0.3-2-x86_64.zip
sudo dpkg -i vktabletUbuntu-1.0.3-2-x86_64.deb

### SonicWall NetExtender   
wget https://software.sonicwall.com/NetExtender/NetExtender.Linux-10.2.845.x86_64.tgz
tar zxvf ~/Downloads/NetExtender.Linux-10.2.845.x86_64.tgz
sudo ./netExtenderClient/install



