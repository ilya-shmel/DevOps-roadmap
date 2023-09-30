# NFS client
#nfs #centos7 #mount

Source: https://winitpro.ru/index.php/2020/06/05/ustanovka-nastrojka-nfs-servera-i-klienta-linux/ 

Related: [[3 NFS server]] [[NFS doesn't working]]

To install NFS on CentOS 7 run this command
```bash
[ilya@192 ~]$ sudo yum install nfs-utils
```

Add services to the autorun and start them 
```bash
[ilya@192 ~]$ sudo systemctl enable rpcbind nfs-server
```

```bash
[ilya@192 ~]$ sudo systemctl start rpcbind nfs-server
```

Make a directory for NFS storage
```bash
[ilya@192 ~]$ sudo mkdir /backup
```

Mount shared NFS storage
```bash
sudo mount -t nfs 192.168.98.102:/backup/nfs/ /backup
```

There 192.168.98.102 is an IP address of the NFS server.

Check the mounted volume
```bash
[ilya@192 ~]$ df -h
Filesystem                   Size  Used Avail Use% Mounted on
devtmpfs                     895M     0  895M   0% /dev
tmpfs                        910M     0  910M   0% /dev/shm
tmpfs                        910M   11M  900M   2% /run
tmpfs                        910M     0  910M   0% /sys/fs/cgroup
/dev/sda3                     36G  4,6G   32G  13% /
/dev/sda1                    297M  213M   85M  72% /boot
tmpfs                        182M   24K  182M   1% /run/user/1000
tmpfs                        182M     0  182M   0% /run/user/0
192.168.98.102:/backup/nfs/   36G  5,0G   31G  14% /backup
```


Check the directory to find NFS server files
```bash
[ilya@192 ~]$ cd /backup
[ilya@192 backup]$ ls -lh
total 0
-rw-rw-r--. 1 nfsnobody nfsnobody 0 апр 12 14:09 123
-rw-rw-r--. 1 nfsnobody nfsnobody 0 апр 12 13:55 testfile
```

Success! 
On the client I've touched file
```bash
[ilya@192 backup]$ touch server_02
```

On the server I've checked this file
```bash
[ilya@homepc nfs]$ ls -lh
total 0
-rw-rw-r--. 1 nfsnobody nfsnobody 0 апр 12 14:09 123
-rw-rw-r--. 1 ilya      ilya      0 апр 13 12:43 server_02
-rw-rw-r--. 1 nfsnobody nfsnobody 0 апр 12 13:55 testfile
```

Checking NFS on client machine

```bash
[ilya@192 backup]$ mount -l | grep nfs
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
192.168.98.102:/backup/nfs/ on /backup type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.98.102,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.98.102)
[ilya@192 backup]$ 
```

The result is non-empty.



```bash

```