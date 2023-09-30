# NFS server
We use EPAMTrServer_01 as NFS-server.

## 1. Install the nfs-packet 
```bash
[ilya@homepc ~]$ sudo yum install nfs-utils
[sudo] password for ilya:
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
* base: mirror.yandex.ru
* extras: mirror.corbina.net
* updates: mirror.reconn.ru
base       				          | 3.6 kB  00:00:00
extras                         | 2.9 kB  00:00:00   
updates                        | 2.9 kB  00:00:00   
updates/7/x86_64/primary_db    |  15 MB  00:00:26   

Package 1:nfs-utils-1.3.0-0.68.el7.2.x86_64 already installed and latest version

Nothing to do
```
## 2. Configure the firewall
```bash
[ilya@homepc ~]$ sudo firewall-cmd --permanent --zone=public --add-service=nfs
success
[ilya@homepc ~]$ sudo firewall-cmd --permanent --zone=public --add-service=mountd
success
[ilya@homepc ~]$ sudo firewall-cmd --permanent --zone=public --add-service=rpc-bind
success
[ilya@homepc backup]$ sudo firewall-cmd --permanent --add-port=111/tcp
[ilya@homepc backup]$ sudo firewall-cmd --reload
success
[ilya@homepc backup]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33 ens36
  sources:
  services: dhcp dhcpv6-client mountd nfs rpc-bind ssh
  ports: 111/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```
## 3. Prepare the shared directory
```bash
[ilya@homepc ~]$ sudo mkdir /backup/nfs 
[ilya@homepc ~]$ sudo mkdir /backup/nfs 
[ilya@homepc ~]$ sudo chown -R nfsnobody:nfsnobody /backup/nfs 
[ilya@homepc ~]$ sudo chmod -R 777 //backup/nfs 
```
## 4. Configure NFS
```bash
[ilya@homepc ~]$ sudo vi /etc/exports

/backup/nfs 192.168.98.0/24(rw,sync,no_root_squash,no_all_squash,crossmnt)
```
## 5. Starting services
```bash
[ilya@homepc storage]$ sudo systemctl enable rpcbind
[sudo] password for ilya:
[ilya@homepc storage]$ sudo systemctl enable nfs-server
Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/systemd/system/nfs-server.service.
[ilya@homepc storage]$ sudo systemctl start rpcbind
[ilya@homepc storage]$ sudo systemctl start nfs-server

[ilya@homepc storage]$ exportfs -a
```
## 6. Make some test files in this directory
```bash
[ilya@homepc nfs]$ touch testfile
[ilya@homepc nfs]$ ls -lh
total 0
-rw-rw-r--. 1 ilya ilya 0 апр 12 13:51 testfile
```

```bash

```

```bash

```

```bash

```

