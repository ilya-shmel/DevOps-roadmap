#!/bin/bash

#That script restores the work of VMware Workstation after a Fedora kernel update

echo "Entered version of VMware Workstation is $1."

rm -rf vmware-host-modules #To prevent fatal error after git clone if this directory is exist

git clone https://github.com/mkubecek/vmware-host-modules.git
cd vmware-host-modules                                       
git checkout workstation-$1
make
make install

/etc/init.d/vmware start


