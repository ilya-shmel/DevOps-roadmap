#!/bin/bash

## That script installs some software on Fedora Linux via dnf, flatpak or snap utility. The first aurgument is username

## Function for installing the software via Fedora repository
install_dnf_function()
{
    echo "Installing $1..."
    dnf -y install $1
} 

## Function for installing the software via flathub
install_flatpak_function()
{
    echo "Installing $1..."
    flatpak -y install flathub $1
} 

## Function for installing the software via snap
install_snap_function()
{
    echo "Installing $1..."
    snap install $1
} 

##  Function for downlopading local packages. Parameter $1 is Google Drive path, paremeter $2 is destination path
download_function()
{   
    echo "Starting to download file $1"
    
    echo "====================================================="
    
    cd $2/ 

    gdown $1
    echo "File $1 was downloaded successfully!"
    echo "====================================================="
}

##  Function for installing local rpm packages
local_install_function()
{
    echo "Starting to install local package $1..."
    
    echo "====================================================="
    dnf -y localinstall $1    
    echo "====================================================="
    echo "Package $1 have been installed successfully!"
}

##============================================================================================================================================================================
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##============================================================================================================================================================================

## Declare massives of software that are installed by dnf, flatpak or snap, and other variables
dnf_apps=(snapd neofetch gnome-tweaks htop solaar unar unrar libreoffice-draw fbreader minder pdfarranger gimp wireshark telegram-desktop deluge video-downloader torbrowser-launcher pavucontrol audacity ffmulticonverter vlc kmod-v4l2loopback python3-pip)
flatpak_apps=(md.obsidian.Obsidian com.obsproject.Studio)
snap_apps=(trello-desktop)
index=0

##  Declare counters of our massives
dnf_apps_count=${#dnf_apps[*]}
flatpak_apps_count=${#flatpak_apps[*]}
snap_apps_count=${#snap_apps[*]}

##  Declare paths and names for local files
dpath=/home/$1/Desktop/packages
packages_names=(zoom_x86_64.rpm code-1.69.2-1658162074.el7.x86_64.rpm)
gid=(1PA0wR_ITX2NXdz3DX1bFE_5W6FEFO0jE 1PZCHvmerpSMkgQQKTfFj5t3xQctlTERu 1rFDpsMeEFednu4LF4XvzCzxF5iJqyh3H)

##  Make the directory for local packages
mkdir $dpath

## Install RPMFusion repository 
echo "Installing the RPMFusion..."
sudo dnf -y install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo "The RPMFusion was installed successfully!"

## Install the flathub remote
echo "Installing the flathub remote..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub
echo "The flathub remote was successfylly installed"

## Install the dnf apps
while [ $index -lt $dnf_apps_count ]
do
    install_dnf_function ${dnf_apps[$index]}
    ((index++))
done

## To prevent a not seeded device we're restarting snapd.seeded.service
systemctl restart snapd.seeded.service

## Install the flatpak apps
index=0
while [ $index -lt $flatpak_apps_count ]
do
    install_flatpak_function ${flatpak_apps[$index]}
    ((index++))
done

## Install snap apps
index=0
while [ $index -lt $snap_apps_count ]
do
    install_snap_function ${snap_apps[$index]}
    ((index++))
done

## Add Trello's shortcut to activities menu
#cp /var/lib/snapd/snap/trello-desktop/12/meta/gui/trello-desktop.desktop /home/$1/.local/share/applications/

## Install the gdown to download some packages from Google Drive
pip install gdown

## Download local packages
for file in ${gid[@]}
do
    download_function $file $dpath
done

## Install Vivaldi browser
wget -P $dpath https://downloads.vivaldi.com/stable/vivaldi-stable-5.3.2679.68-1.x86_64.rpm
dnf localinstall -y vivaldi-stable-5.3.2679.68-1.x86_64.rpm

for package in ${packages_names[@]}
do
    local_install_function $package

done

##  Install VMWare Workstation
chmod 777 $dpath/VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle 
$dpath/VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle

## Clear the temporary directory
rm -r $dpath

echo "The work was done!"