#!/bin/bash

## That script installs the Pangeoradar Platform on Debian 10 

## Add some useful variables
PLATFORM_VERSION="3.6.3"

echo "================================================="
echo "Please, enter the correct Platform's version: "
echo "================================================="

read PLATFORM_VERSION

## Download the Platform package
rsync --archive --verbose --progress Ilya@192.168.0.16:/home/Ilya/Public/v-stand-34/pgr-$PLATFORM_VERSION.tar.gz ~/

## Unpack the Platform
cd /home/ilya/
mkdir pgr
tar -xvf pgr-$PLATFORM_VERSION.tar.gz -C pgr
cp pgr/* /var/tmp/
cp pgr-agent.lic /var/tmp

## Check the tmp directory and the Internet
ls -lh /var/tmp
ping -c4 google.com

## Install the Platform
cd /var/tmp
bash install.sh 