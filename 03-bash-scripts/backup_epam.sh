#!/bin/bash

## That script simply backup local files into the tar archive on any device

#Function simulate key --help for all linux programs
help_function()
{
    echo "This is back-up script"
    echo " "
    echo "You should use compression utilites like gzip, bzip2, xz or lzma!"
    echo " "
    echo "Usage: "
    echo "backup_epam.sh [-s [OPTION] -b [OPTION] -a [OPTION] -c [OPTION] -u [OPTION] -e[OPTION] -h]"
    echo " "
    echo "Options:"
    echo "-a        archive name"
    echo "-b        backup directory"
    echo "-c        compression level"
    echo "-e        excluding files"
    echo "-h        help"
    echo "-s        saving files"
    echo "-u        compression utility"
    echo " "
    echo "Default options:"
    echo " "
    echo "Archive name is 'Current Date + backup.tar'."
    echo "Compression utility is GZIP, compression level is 6."
    echo "Saving files is '/etc'."
    echo "Excluding files is: no excluding files."
    echo "Backup directory is '/media/homework/btrfs/Backup'."
    exit 0  

}

#Main backup operations: make tar archive, compress and move it to backup destination
# $1 - archive name, $2 - saving files, $3 - backup directory, $4 - compression
# $5 - utility $6 - excluding files
backup_function()
{
    echo "Archive name is $1"
    echo "Compression utility is $5, compression level is $4"
    echo "Saving files is $2"
    echo "Excluding files is: $2/$6"
    echo "Backup directory is $3"
      
    if [[ $6 != No ]]
    then
        tar -cvf $1 --exclude=$2/$6 $2 | $5 -$4 > $1.tar    #Make compressed archive without excluding files   
        mv $1.tar $3
    else
        tar -cvf $1 $2 | $5 -$4 > $1.tar                    #Make compressed archive without excluding key
        mv $1.tar $3
    fi
}

#Function prevent using some options as parameters
check_params()
{
	if [[ $OPTARG =~ ^-[a/b/s/h/c/u/e]$ ]]                  #Add options to this condition
	then
	echo "Unknow argument $OPTARG for option $param!"
	exit 1
	fi
}

#Define variables for our script
current_date=`date +%m-%d-%y`                               #Get current date for archive name
backup_directory="/media/homework/btrfs/Backup"
saving_files="/etc"
archive_name=$current_date-"backup.tar"
compression=6
utility=gzip
exclude_files="No"

#Script's process options 
# s - saving files, b - backup directory, a - archive name, c - compression
# u - utility, e - exclude files, h - get help (without options)
while getopts hs:b:a:c:u:e: param
do
    case $param in
    h) help_function;;
    s) check_params; saving_files=$OPTARG;; 
    b) check_params; backup_directory=$OPTARG;;
    a) check_params; archive_name=$current_date-$OPTARG;;
    c) check_params; compression=$OPTARG;;
    u) check_params; utility=$OPTARG;;
    e) check_params; exclude_files=$OPTARG;;
    esac
done

#Start backup function with specific or default parameters
echo "=============================================================="
echo "Starting back-up!"
echo "=============================================================="
    
backup_function $archive_name $saving_files $backup_directory $compression $utility $exclude_files
    
echo "=============================================================="
echo "End of back-up."
echo "=============================================================="





