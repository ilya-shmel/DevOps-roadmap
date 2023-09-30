# PPTP VPN Client
#vpn #pptp #centos7 #client

Source: [zlthinker](https://zlthinker.github.io/Setup-VPN-on-CentOS) [valec.ru](http://valec.ru/?p=174), [oracle](https://docs.oracle.com/cd/E19683-01/817-0204/pppsvrconfig.reference-250/index.html), [wiki.archlinux](https://wiki.archlinux.org/title/PPTP_Client)

Related: [[6 PPTP VPN Client]], [[PPTP]], [[modprobe]]

## 0. Install PPTP client
```bash
[ilya@epamtrserver_02 ~]$ sudo yum install pptp
```
## 1. Turn on the support of PPP in the Linux kernel
```bash
[ilya@epamtrserver_02 ~]$ sudo modprobe ppp_mppe
[ilya@epamtrserver_02 ~]$ sudo modprobe nf_conntrack_pptp
```
## 2. Create the configuration file which supports auto reconnection if connection has lost
```bash
[ilya@epamtrserver_02 ~]$ sudo vi /etc/ppp/peers/pptpserver
```

```bash
pty "pptp 192.168.98.102 --nolaunchpppd"
name ilya
password 123
remotename PPTP
require-mppe-128
persist holdoff 10
maxfail 0
lcp-echo-interval 15
lcp-echo-failure 4
ipparam pptpserver
```
## 3. Edit the options file
`/etc/ppp/options`
```bash
lock
noauth
nobsdcomp
nodeflate
refuse-pap
refuse-eap
refuse-chap
refuse-mschap
```
## 4. Edit chap-secrets file
```bash

```
## 5. Launch the connection
```bash
[ilya@epamtrserver_02 ~]$ sudo pppd call pptpserver
```
## 6. Check the connection name
```bash
[ilya@epamtrserver_02 ~]$ sudo pppd call pptpserver
[ilya@epamtrserver_02 ~]$ ip a | grep ppp

73: ppp0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1496 qdisc pfifo_fast state UNKNOWN group default qlen 3
    link/ppp 
    inet 192.168.98.198 peer 192.168.98.102/32 scope global ppp0
       valid_lft forever preferred_lft forever
		 
[ilya@epamtrserver_02 ~]$ ifconfig ppp0
ppp0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1496
        inet 192.168.98.198  netmask 255.255.255.255  destination 192.168.98.102
        ppp  txqueuelen 3  (Point-to-Point Protocol)
        RX packets 6  bytes 60 (60.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6  bytes 66 (66.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
		 
```
## 7. Check the route table
```bash
[ilya@epamtrserver_02 peers]$ sudo route add -net 192.168.98.0 netmask 255.255.255.0 dev ppp0
[ilya@epamtrserver_02 peers]$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.0.1     0.0.0.0         UG    100    0        0 ens33
0.0.0.0         192.168.98.1    0.0.0.0         UG    101    0        0 ens36
192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 ens33
192.168.98.0    0.0.0.0         255.255.255.0   U     101    0        0 ens36
192.168.98.102  0.0.0.0         255.255.255.255 UH    0      0        0 ens36
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
```

