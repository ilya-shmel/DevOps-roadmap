#!/usr/bin/env bash

## That script restarts the service and displays that status

## Restart the service and watch its logfile
sudo systemctl stop pangeoradar-logcollector.service 
echo "================================================="
echo "Waiting for the log-collector stopping"
echo "================================================="
sleep 5 
sudo systemctl start pangeoradar-logcollector.service
echo "================================================="
echo "Waiting for the log-collector starting"
echo "================================================="
sleep 5
sudo systemctl status pangeoradar-logcollector.service
sleep 5
lnav /home/ilya/crash.log