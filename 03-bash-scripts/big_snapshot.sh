#!/bin/bash

## That script transfers local files to the Yandex.Disk storage

## Declare the massive of the backuping directories and the archive name
directories=(Bash Desktop Documents Obsidian Pictures Public .ssh)
backup_name="/storage/nvme01/03-Temporal_Backup/Snapshot_$(date --rfc-3339=date)"

## Temporary directory for archives
mkdir $backup_name

## Delete the unnecessary directory if it exists
rm -rf home/Ilya/Bash/vmware-host-modules/

## Create archives of all directories
for directory in ${directories[@]}
do 
    echo "Storing $directory..."
    tar cvjf $directory.tar /home/Ilya/$directory
    mv $directory.tar $backup_name
done

## Send archives to Yandex.Disk
rclone mkdir YaStorage:Backup/"Snapshot_$(date --rfc-3339=date)"
rclone -P move $backup_name YaStorage:Backup/"Snapshot_$(date --rfc-3339=date)" --auto-confirm --syslog

rm -R -v $backup_name

echo "The Big Backup is done!"