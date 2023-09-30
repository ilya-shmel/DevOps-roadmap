#!/bin/bash

## That script downloads and renames files from the Google Drive

##  Function for renaming the Google Drive files
rename_function()
{
    echo "File $1 is $2"
    mv $1 $2
} 

##  Declare varieties 
gdrive_path=/run/user/1000/gvfs/google-drive:host=gmail.com,user=prophet8912/0AO19kmSnhKnAUk9PVA/1LYCVkkuxnLNY0gLx16K4PzImHh5XSt69
dpath=/home/ilya/Desktop/packets
packets_names=(zoom_x86_64.rpm code-1.69.2-1658162074.el7.x86_64.rpm VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle)
index=0

##  Make the destination directory
mkdir $dpath

##  Download packets from GDrive
echo "Starting to download files..."
echo "Source path is $gdrive_path"
echo "Destination path is $dpath"
echo "====================================================="

for file in $gdrive_path/*
do
    rsync -v $file $dpath
    echo "====================================================="
done

echo "Files were copied successfully!"

##  Rename downloaded files
cd $dpath/ 
echo "Renaming files..."
for full_name in $dpath/* 
do 
    file_name="${full_name##*/}"
    case $file_name in
    1PA0wR_ITX2NXdz3DX1bFE_5W6FEFO0jE) rename_function $file_name ${packets_names[$index]} $dpath; ((index++));;
    1PZCHvmerpSMkgQQKTfFj5t3xQctlTERu) rename_function $file_name ${packets_names[$index]} $dpath; ((index++));; 
    1rFDpsMeEFednu4LF4XvzCzxF5iJqyh3H) rename_function $file_name ${packets_names[$index]} $dpath; ((index++));;
    *) echo "No matches." 
    esac
done      


dnf -y localinstall $dpath/zoom_x86_64.rpm
dnf -y localinstall $dpath/code-1.69.2-1658162074.el7.x86_64.rpm

chmod 777 $dpath/VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle 
$dpath/VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle