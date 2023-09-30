# PPTP VPN Server
#centos7 #vpn #pptp #server

Source: [Codeby.net](https://codeby.net/threads/ustanovka-pptp-vpn-servera-na-centos-7-dlja-lenivyx.61298/), [wiki.archlinux](https://wiki.archlinux.org/title/PPTP_server_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9))

Related: [[EPEL]], [[PPTP]]

Port: TCP 1723, Other 47

## 0. Install repository and net utilities
```bash
[ilya@192 ~]$ sudo yum install epel-release net-tools
```

epel-release is an PPTP repository.

## 1. Turn off SElinux
```bash
[ilya@homepc ~]$ sudo vi /etc/sysconfig/selinux
```

```bash
SELINUX=disable
```

## 2. Install PPTP VPN
```bash
[ilya@192 ~]$ sudo  yum install ppp pptp pptpd pptp-setup
```
Add PPTP to autoruns.
```bash
[ilya@192 ~]$ sudo chkconfig pptpd on 
Note: Forwarding request to 'systemctl enable pptpd.service'.
Created symlink from /etc/systemd/system/multi-user.target.wants/pptpd.service to /usr/lib/systemd/system/pptpd.service.
```

## 3. Configure PPTP
We need the file /etc/pptpd.conf 
```bash
option /etc/ppp/options.pptpd
logwtmp
localip 192.168.98.102
remoteip 192.168.98.103-254
```
I use the current  IP-address for EPAMTrServer_01 LAN Segment.

To declare DNS server(s) we need to edit /etc/ppp/options.pptpd
```bash
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
proxyarp
lock
nobsdcomp
novj
novjccomp
ms-dns 192.168.98.1
ms-dns 8.8.8.8
```
I use my current DNS EPAMTrServer_03.

To declare a login and a password for PPTP VPN Server we should to edit  /etc/ppp/chap-secrets
```bash
# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
ilya            pptpd   123                     *

```

Turn on IP forwarding in /etc/sysctl.conf
```bash
net.core.wmem_max = 12582912  
net.core.rmem_max = 12582912  
net.ipv4.tcp_rmem = 10240 87380 12582912  
net.ipv4.tcp_wmem = 10240 87380 12582912  
net.core.wmem_max = 12582912  
net.core.rmem_max = 12582912  
net.ipv4.tcp_rmem = 10240 87380 12582912  
net.ipv4.tcp_wmem = 10240 87380 12582912  
net.core.wmem_max = 12582912  
net.core.rmem_max = 12582912  
net.ipv4.tcp_rmem = 10240 87380 12582912  
net.ipv4.tcp_wmem = 10240 87380 12582912  
net.ipv4.ip_forward = 1
```

And apply sysctl configuration.
```bash
[ilya@192 etc]$ sudo sysctl -p
```

## 4. Configure a firewall
Delete firewalld
```bash
[ilya@192 etc]$ sudo systemctl stop firewalld
[ilya@192 etc]$ sudo systemctl disable firewalld
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
```
Install IPtables 
```bash
[ilya@192 etc]$ sudo yum install iptables-services iptables
```
Add it to autoruns
```bash
[ilya@192 etc]$ sudo systemctl enable iptables
Created symlink from /etc/systemd/system/basic.target.wants/iptables.service to /usr/lib/systemd/system/iptables.service.

[ilya@192 etc]$ sudo chmod +x /etc/rc.d/rc.local
```
### Configure IPtables 

Turn on NAT for ens36 and ppp+
```bash
[ilya@192 etc]$ sudo iptables -t nat -A POSTROUTING -s 192.168.98.0/24 -o ens36 -j MASQUERADE
[ilya@192 ~]$ sudo iptables -t nat -A POSTROUTING -o ppp+ -j MASQUERADE 
```
Allow all packets via ppp* interfaces
```bash
[ilya@192 ~]$ sudo iptables -A INPUT -i ppp+ -j ACCEPT
[ilya@192 ~]$ sudo iptables -A OUTPUT -o ppp+ -j ACCEPT
```
Allow incoming connections on the port 1723 (PPTP) 
```bash
[ilya@192 ~]$ sudo iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
```
Allow all GRE packets
```bash
[ilya@192 ~]$ sudo iptables -A INPUT -p 47 -j ACCEPT
[ilya@192 ~]$ sudo iptables -A OUTPUT -p 47 -j ACCEPT
```
Enable the IP forwarding
```bash
[ilya@192 ~]$ sudo iptables -F FORWARD
[ilya@192 ~]$ sudo iptables -A FORWARD -j ACCEPT
```
Restart IPtables
```bash
[ilya@192 etc]$ sudo service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]

[ilya@192 etc]$ sudo service iptables restart
Redirecting to /bin/systemctl restart iptables.service

[ilya@192 etc]$ sudo systemctl start pptpd

```
## 5. Check the service's status.
```bash
[ilya@192 etc]$ sudo systemctl status pptpd iptables
● pptpd.service - PoPToP Point to Point Tunneling Server
   Loaded: loaded (/usr/lib/systemd/system/pptpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Вт 2022-04-26 13:55:25 MSK; 16s ago
 Main PID: 5856 (pptpd)
    Tasks: 1
   CGroup: /system.slice/pptpd.service
           └─5856 /usr/sbin/pptpd -f

апр 26 13:55:25 homepc systemd[1]: Started PoPToP Point to Point Tunneling Server.
апр 26 13:55:25 homepc pptpd[5856]: MGR: connections limit (100) reached, extra IP addresses ignored
апр 26 13:55:25 homepc pptpd[5856]: MGR: Manager process started
апр 26 13:55:25 homepc pptpd[5856]: MGR: Maximum of 100 connections available

● iptables.service - IPv4 firewall with iptables
   Loaded: loaded (/usr/lib/systemd/system/iptables.service; enabled; vendor preset: disabled)
   Active: active (exited) since Вт 2022-04-26 13:54:44 MSK; 56s ago
  Process: 5834 ExecStart=/usr/libexec/iptables/iptables.init start (code=exited, status=0/SUCCESS)
 Main PID: 5834 (code=exited, status=0/SUCCESS)
    Tasks: 0
   CGroup: /system.slice/iptables.service

апр 26 13:54:44 homepc systemd[1]: Starting IPv4 firewall with iptables...
апр 26 13:54:44 homepc iptables.init[5834]: iptables: Applying firewall rules: [  OK  ]
апр 26 13:54:44 homepc systemd[1]: Started IPv4 firewall with iptables.
```
Check the pptp process
```bash
[ilya@192 etc]$ ps aux | grep pptpd
ilya       3527  0.0  0.2 149404  5228 pts/1    T    12:03   0:00 vim pptpd.conf
root       5856  0.0  0.0  10736   892 ?        Ss   13:55   0:00 /usr/sbin/pptpd -f
ilya       5891  0.0  0.0 112812  1000 pts/1    S+   13:58   0:00 grep --color=auto pptpd
```
Check the port listening
```bash
[ilya@192 etc]$ netstat -an | grep -i listen
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:1723            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:45885           0.0.0.0:*               LISTEN     
```

