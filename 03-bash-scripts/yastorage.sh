#!/bin/bash

##That script syncs the local data with the specific Yandex.Disk directory 

## Declare the massive of directories
directories=(Bash Documents Obsidian)

## Create a name for the backup subdirectory
backup_name=Home+$(date --rfc-3339=date) 

## Create the backup directory
rclone mkdir YaStorage:Backup/$backup_name

## Copy directories to the backup destination
for directory in ${directories[@]}
do
    echo "=====Copying $directory=====" 
    rclone sync -P ~/$directory YaStorage:Backup/$backup_name/$directory --auto-confirm --syslog -vv
done

## Print the result of the copying 
echo "The copied directories are"
rclone lsd YaStorage:Backup/$backup_name

echo "The job is done!"