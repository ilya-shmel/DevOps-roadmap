# DHCP Lab
We have a machine EPAMTrServer_03 with the bridged interface ens34 192.168.0.14 and the LAN segment interface ens33. Ubuntu 20.04.

## 0. Prepare the network
```bash
ilya@epamtrserver03:~$ sudo vi /etc/default/grub

GRUB_CMDLINE_LINUX="netcfg/do_not_use_netplan=true"
```
Install ifupdown packet
```bash
ilya@epamtrserver03:~$ sudo apt-get install ifupdown
```
Configure network in interfaces file
```bash
ilya@epamtrserver03:~$ sudo vi etc/network/interfaces

# interfaces(5) file used by ifup(8) and ifdown(8)

# Include files from /etc/network/interfaces.d:

source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback
  

auto ens33
iface ens33 inet static
address 192.168.98.1
netmask 255.255.255.0
dns-nameservers 127.0.0.1
dns-search EPAM.TR.LOCAL
dns-domain EPAM.TR.LOCAL
  
auto ens34
iface ens34 inet dhcp
```
Apply changes
```bash
ilya@epamtrserver03:~$ sudo update-grub
ilya@epamtrserver03:~$ sudo shutdown -r now
```
Restart networking and disable firewall
```bash
ilya@epamtrserver03:~$ sudo service networking restart
ilya@epamtrserver03:~$ sudo ufw disable
```

## 1. Install DHCP packet and start to configure
```bash
ilya@epamtrserver03:~$ sudo apt install isc-dhcp-server
```
Configure

Notion: ***!!! Here we don't use '';'' after "}{" !!!***
```bash
ilya@epamtrserver03:~$ sudo vi /etc/dhcp/dhcpd.conf

# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#
# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as
# configuration file instead of this file.
#

# option definitions common to all supported networks...
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;
  
subnet 192.168.98.0 netmask 255.255.255.0 {
range  192.168.98.101 192.168.98.199;
option domain-name "TR.LOCAL";
option domain-name-servers 192.168.98.1;
option routers 192.168.98.1;
option broadcast-address 192.168.98.255;
}

Host fileserver {
hardware ethernet 08:02:27:1c:f5:df;
fixed-address 192.168.98.134;
}

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;
authoritative;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;
# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;
```
Prevent the registration of the Internet sites
```bash
ilya@epamtrserver03:~$ sudo vi /etc/default/isc-dhcp-server

# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid
  
# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".

INTERFACESv4="ens33"
INTERFACESv6=""
```
Configure logs of the dchp-server 
```bash
ilya@epamtrserver03:~$ sudo vi /etc/rsyslog.conf
# Add to the end of file this line
local7.*        /var/log/dhcpd.log
```
Create this log manually
```bash
ilya@epamtrserver03:~$ sudo touch /var/log/dhcpd.log
```
Restart DHCP and rsyslog
```bash
ilya@epamtrserver03:~$ sudo service rsyslog restart

ilya@epamtrserver03:~$ sudo service rsyslog status

● rsyslog.service - System Logging Service

     Loaded: loaded (/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)

     Active: active (running) since Sun 2022-03-27 21:35:26 MSK; 58s ago

TriggeredBy: ● syslog.socket

       Docs: man:rsyslogd(8)

             https://www.rsyslog.com/doc/

   Main PID: 41017 (rsyslogd)

      Tasks: 4 (limit: 4575)

     Memory: 1.3M

     CGroup: /system.slice/rsyslog.service

             └─41017 /usr/sbin/rsyslogd -n -iNONE

  
Mar 27 21:35:26 epamtrserver03 systemd[1]: Starting System Logging Service...

Mar 27 21:35:26 epamtrserver03 systemd[1]: Started System Logging Service.

Mar 27 21:35:26 epamtrserver03 rsyslogd[41017]: imuxsock: Acquired UNIX socket '/run/systemd/journal/syslog' (fd 3) from systemd.  [v8.2001.0]

Mar 27 21:35:26 epamtrserver03 rsyslogd[41017]: rsyslogd's groupid changed to 110

Mar 27 21:35:26 epamtrserver03 rsyslogd[41017]: rsyslogd's userid changed to 104

Mar 27 21:35:26 epamtrserver03 rsyslogd[41017]: [origin software="rsyslogd" swVersion="8.2001.0" x-pid="41017" x-info="https://www.rsyslog.com"] start

ilya@epamtrserver03:~$ systemctl start isc-dhcp-server

==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===

Authentication is required to start 'isc-dhcp-server.service'.

Authenticating as: Ilya Shmadchenko (ilya)

Password:

==== AUTHENTICATION COMPLETE ===

ilya@epamtrserver03:~$ systemctl status isc-dhcp-server

● isc-dhcp-server.service - ISC DHCP IPv4 server

     Loaded: loaded (/lib/systemd/system/isc-dhcp-server.service; enabled; vendor preset: enabled)

     Active: active (running) since Tue 2022-03-29 11:04:53 MSK; 10s ago

       Docs: man:dhcpd(8)

   Main PID: 1899 (dhcpd)

      Tasks: 4 (limit: 4575)

     Memory: 5.6M

     CGroup: /system.slice/isc-dhcp-server.service

             └─1899 dhcpd -user dhcpd -group dhcpd -f -4 -pf /run/dhcp-server/dhcpd.pid -cf /etc/dhcp/dhcpd.conf ens33
				 
				 Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Wrote 0 deleted host decls to leases file.

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Wrote 0 new dynamic host decls to leases file.

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Wrote 0 leases to leases file.

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Listening on LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Mar 29 11:04:53 epamtrserver03 sh[1899]: Listening on LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Mar 29 11:04:53 epamtrserver03 sh[1899]: Sending on   LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Mar 29 11:04:53 epamtrserver03 sh[1899]: Sending on   Socket/fallback/fallback-net

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Sending on   LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Sending on   Socket/fallback/fallback-net

Mar 29 11:04:53 epamtrserver03 dhcpd[1899]: Server starting service.
```

## 2. Problem with log
```bash
Mar 29 10:56:17 epamtrserver03 rsyslogd[1175]: file '/var/log/dhcpd.log': open error: Permission denied [v8.2001.0 try https://www.rsyslog.com/e/2433 ]
```
Change tho log owner and restart DHCP
```bash
ilya@epamtrserver03:~$ sudo chown syslog:adm /var/log/dhcpd.log

ilya@epamtrserver03:~$ sudo systemctl restart rsyslog.service
```

## Go to [[2 DNS Lab]] paragraph 3
## 3. Add the DNS key to the DHCP configuration
```bash
ilya@epamtrserver03:~$ sudo vi /etc/dhcp/dhcpd.conf

subnet 192.168.98.0 netmask 255.255.255.0 {
range  192.168.98.101 192.168.98.199;
option domain-name "TR.LOCAL";
option domain-name-servers 192.168.98.1;
option routers 192.168.98.1;
option broadcast-address 192.168.98.255;
}

Host fileserver {
hardware ethernet 08:02:27:1c:f5:df;
fixed-address 192.168.98.134;
}

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)

ddns-updates on;
ddns-update-style interim;
update-static-leases on;
authoritative;

key DHCP_UPDATER {
        algorithm hmac-md5;
        secret "nA7disCxmkYXay9d/p+umA==";
        }

zone EPAM.TR.LOCAL {
        primary 192.168.98.1;
        key DHCP_UPDATER;
        }

zone 98.168.192.in-addr.arpa {
        primary 192.168.98.1;
        key DHCP_UPDATER;
        }

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;
```
Restart the DHCP-service
```bash
ilya@epamtrserver03:~$ sudo systemctl restart isc-dhcp-server

ilya@epamtrserver03:~$ sudo systemctl status isc-dhcp-server

● isc-dhcp-server.service - ISC DHCP IPv4 server

     Loaded: loaded (/lib/systemd/system/isc-dhcp-server.service; enabled; vendor preset: enabled)

     Active: active (running) since Sat 2022-04-09 22:06:18 MSK; 2s ago

       Docs: man:dhcpd(8)

   Main PID: 4935 (dhcpd)

      Tasks: 4 (limit: 4575)

     Memory: 15.3M

     CGroup: /system.slice/isc-dhcp-server.service

             └─4935 dhcpd -user dhcpd -group dhcpd -f -4 -pf /run/dhcp-server/dhcpd.pid -cf /etc/dhcp/dhcpd.conf ens33

  

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Wrote 0 deleted host decls to leases file.

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Wrote 0 new dynamic host decls to leases file.

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Wrote 0 leases to leases file.

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Listening on LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Apr 09 22:06:18 epamtrserver03 sh[4935]: Listening on LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Apr 09 22:06:18 epamtrserver03 sh[4935]: Sending on   LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Apr 09 22:06:18 epamtrserver03 sh[4935]: Sending on   Socket/fallback/fallback-net

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Sending on   LPF/ens33/00:50:56:33:27:fe/192.168.98.0/24

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Sending on   Socket/fallback/fallback-net

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Server starting service.
```
## Go to [[2 DNS Lab]] paragraph 4
## 4. Testing DHCP on a client machine
On EPAMTrServer_02 we run
```bash
[ilya@192 ~]$ sudo dhclient -r

ilya@localhost ~]$ sudo dhclient -v ens36
[sudo] password for ilya:
Internet Systems Consortium DHCP Client 4.2.5
Copyright 2004-2013 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/ens36/00:0c:29:e9:be:ac
Sending on  LPF/ens36/00:0c:29:e9:be:ac
Sending on  Socket/fallback
DHCPDISCOVER on ens36 to 255.255.255.255 port 67 interval 8 (xid=0x6dea80f)
DHCPREQUEST on ens36 to 255.255.255.255 port 67 (xid=0x6dea80f)
DHCPOFFER from 192.168.98.1
DHCPACK from 192.168.98.1 (xid=0x6dea80f)
bound to 192.168.98.102 -- renewal in 238 seconds.
```

```bash

```