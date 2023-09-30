#!/bin/bash

## That script unpacks the music archives from the 'Downloads' directory, copies them into the 'Music' directory and sends to the Yandex.Disk storage

## Declare the directories' names for the storing of archives and Music  
arch_dir="/home/Ilya/Downloads/music"
music_dir="/home/Ilya/Music"

## Create the temporary directory for the downloaded archives and 
mkdir $arch_dir
cd ~/Downloads
mv *.rar *.zip *.7z  $arch_dir

## Unpack the archives and delete them
for archive in $arch_dir/*
do
    echo "Unpacking $archive..."
    unar -o $music_dir "$archive"
    rm "$archive"
done

## Copy music to Yandex Disk
rclone -P copy $music_dir YaStorage:Музыка --auto-confirm --syslog 
rm -R $arch_dir



