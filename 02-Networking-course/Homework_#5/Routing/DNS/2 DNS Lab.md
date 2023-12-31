# DNS Lab

We have a machine EPAMTrServer_03 with the bridged interface ens34 192.168.0.14 and the LAN segment interface ens33. Ubuntu 20.04.

## 1. Configure DNS-server
```bash
ilya@epamtrserver03:/etc$ vi resolv.conf
ilya@epamtrserver03:/etc$ sudo resolvconf -u
ilya@epamtrserver03:/etc$ systemd-resolve --status
```

```bash
Global

       LLMNR setting: no                 
MulticastDNS setting: no                 
  DNSOverTLS setting: no                 
      DNSSEC setting: no                 
    DNSSEC supported: no                 
  Current DNS Server: 192.168.0.1        
         DNS Servers: 192.168.0.1        
          DNSSEC NTA: 10.in-addr.arpa    
                      16.172.in-addr.arpa
                      168.192.in-addr.arpa
                      17.172.in-addr.arpa
                      18.172.in-addr.arpa
                      19.172.in-addr.arpa
                      20.172.in-addr.arpa
                      21.172.in-addr.arpa
                      22.172.in-addr.arpa
                      23.172.in-addr.arpa
                      24.172.in-addr.arpa
                      25.172.in-addr.arpa
                      26.172.in-addr.arpa
                      27.172.in-addr.arpa
                      28.172.in-addr.arpa
                      29.172.in-addr.arpa
                      30.172.in-addr.arpa
                      31.172.in-addr.arpa
                      corp               
                      d.f.ip6.arpa       
                      home               
                      internal           
                      intranet           
                      lan                
                      local              
                      private
    test               


Link 3 (ens34)
      Current Scopes: DNS       
DefaultRoute setting: yes       
       LLMNR setting: yes       
MulticastDNS setting: no        
  DNSOverTLS setting: no        
      DNSSEC setting: no        
    DNSSEC supported: no        
  Current DNS Server: 192.168.0.1
         DNS Servers: 192.168.0.1
                      fe80::1   


Link 2 (ens33)
      Current Scopes: none
DefaultRoute setting: no 
       LLMNR setting: yes
MulticastDNS setting: no 
  DNSOverTLS setting: no 
      DNSSEC setting: no 
    DNSSEC supported: no
```
Restart and check resolv.conf
```bash
ilya@epamtrserver03:/etc$ sudo service network restart
ilya@epamtrserver03:/etc$ vi resolv.conf

# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)

#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN

# 127.0.0.53 is the systemd-resolved stub resolver.

# run "systemd-resolve --status" to see details about the actual nameservers.

nameserver 127.0.0.1
search EPAM.TR.LOCAL
options edns0 trust-ad
```
Check the Internet
```bash
ilya@epamtrserver03:~$ ping google.com
ping: google.com: Temporary failure in name resolution
```
Edit the address in /etc/network/interfaces
```bash
auto ens33
iface ens33 inet static
address 192.168.98.1
netmask 255.255.255.0
dns-nameservers 192.168.98.1
dns-search EPAM.TR.LOCAL
dns-domain [EPAM.TR.LOCAL](http://EPAM.TR.LOCAL)
```
Then check
```bash
ilya@epamtrserver03:~$ sudo service networking restart
sudo: unable to resolve host epamtrserver03: Temporary failure in name resolution

ilya@epamtrserver03:~$ ping google.com
PING google.com (64.233.162.100) 56(84) bytes of data.
64 bytes from li-in-f100.1e100.net (64.233.162.100): icmp_seq=1 ttl=60 time=52.2 ms
64 bytes from li-in-f100.1e100.net (64.233.162.100): icmp_seq=2 ttl=60 time=52.3 ms
64 bytes from li-in-f100.1e100.net (64.233.162.100): icmp_seq=3 ttl=60 time=60.0 ms
^C
--- google.com ping statistics ---

4 packets transmitted, 3 received, 25% packet loss, time 3004ms

rtt min/avg/max/mdev = 52.228/54.833/60.010/3.660 ms
```
 Check resolv.conf
```bash
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)

#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN

# 127.0.0.53 is the systemd-resolved stub resolver.

# run "systemd-resolve --status" to see details about the actual nameservers.

ilya@epamtrserver03:~$ sudo vi /etc/resolv.conf
nameserver 192.168.98.1
nameserver 127.0.0.53
search EPAM.TR.LOCAL
options edns0 trust-ad
```
## 2. Install bind9
```bash
ilya@epamtrserver03:~$ sudo apt install bind9
```

```bash
ilya@epamtrserver03:/etc/bind$ sudo vi named.conf.options
```
Restart the service
```bash
ilya@epamtrserver03:/etc/bind$ sudo service bind9 status

● named.service - BIND Domain Name Server

     Loaded: loaded (/lib/systemd/system/named.service; enabled; vendor preset: enabled)

     Active: active (running) since Thu 2022-02-10 15:36:23 MSK; 12min ago

       Docs: man:named(8)

   Main PID: 5506 (named)

      Tasks: 14 (limit: 4575)

     Memory: 37.1M

     CGroup: /system.slice/named.service

             └─5506 /usr/sbin/named -f -u bind

  

Feb 10 15:36:24 epamtrserver03 named[5506]: zone 0.in-addr.arpa/IN: loaded serial 1

Feb 10 15:36:24 epamtrserver03 named[5506]: zone localhost/IN: loaded serial 2

Feb 10 15:36:24 epamtrserver03 named[5506]: zone 127.in-addr.arpa/IN: loaded serial 1

Feb 10 15:36:24 epamtrserver03 named[5506]: zone 255.in-addr.arpa/IN: loaded serial 1

Feb 10 15:36:24 epamtrserver03 named[5506]: all zones loaded

Feb 10 15:36:24 epamtrserver03 named[5506]: running

Feb 10 15:36:30 epamtrserver03 named[5506]: managed-keys-zone: Initializing automatic trust anchor management for zone '.'; DNSKEY ID 20326 is now trusted, waiving the normal 30-day waiting period.

Feb 10 15:36:30 epamtrserver03 named[5506]: resolver priming query complete

Feb 10 15:37:15 epamtrserver03 named[5506]: dispatch 0x7f2d2802e4f0: shutting down due to TCP receive error: 199.9.14.201#53: connection reset

Feb 10 15:37:16 epamtrserver03 named[5506]: dispatch 0x7f2d2802e4f0: shutting down due to TCP receive error: 192.33.4.12#53: connection reset
```
Check the ping
```bash
ilya@epamtrserver03:/etc/bind$ ping google.com

PING google.com (64.233.162.138) 56(84) bytes of data.

64 bytes from li-in-f138.1e100.net (64.233.162.138): icmp_seq=1 ttl=60 time=54.5 ms

64 bytes from li-in-f138.1e100.net (64.233.162.138): icmp_seq=2 ttl=60 time=58.1 ms

64 bytes from li-in-f138.1e100.net (64.233.162.138): icmp_seq=3 ttl=60 time=54.6 ms

64 bytes from li-in-f138.1e100.net (64.233.162.138): icmp_seq=4 ttl=60 time=52.7 ms

^C

--- google.com ping statistics ---

14 packets transmitted, 14 received, 0% packet loss, time 17098ms

rtt min/avg/max/mdev = 49.884/54.419/58.378/2.957 ms
```
Configure zones. Use current file as template. Copy it to variable files directory 
```bash
ilya@epamtrserver03:/etc/bind$ sudo cp db.local /var/lib/bind/forward.bind
```
Write the zone of the direct view
```bash
ilya@epamtrserver03:/etc/bind$ sudo vi var/lib/bind/forward.bind

; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     epamtrserver_03.EPAM.TR.LOCAL. root.epamtrserver_03.EPAM.TR.LOCAL. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      epamtrserver_03.EPAM.TR.LOCAL.
@       IN      A       192.168.98.1
@       IN      AAAA    ::1

test    IN      A       192.168.98.111
```
Write the zone of the reverse view
```bash
ilya@epamtrserver03:/etc/bind$ sudo cp /var/lib/bind/forward.bind /var/lib/bind/reverse.bind

ilya@epamtrserver03:/etc/bind$ sudo vi var/lib/bind/reverse.bind

;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     epamtrserver_03.EPAM.TR.LOCAL. root.epamtrserver_03.EPAM.TR.LOCAL. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      epamtrserver_03.EPAM.TR.LOCAL.
1       IN      PTR     epamtrserver_03.EPAM.TR.LOCAL.
111     IN      PTR     test.EPAM.TR.LOCAL.
```
Bind zones to the DNS-server
```bash
ilya@epamtrserver03:/etc/bind$ sudo vi named.conf.local

///
// Do any local configuration here
//
zone "EPAM.TR.LOCAL" {
        type master;
        file "/var/lib/bind/forward.bind";
        check-names ignore;
        };
zone "98.168.192.in-addr.arpa" {
        type master;
        file "/var/lib/bind/reverse.bind";
        check-names ignore;
        };

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
```
Restart bind
```bash
ilya@epamtrserver03:/etc/bind$ sudo service bind9 restart
```

```bash
ilya@epamtrserver03:/etc/bind$ sudo service bind9 status

sudo: unable to resolve host epamtrserver03: Temporary failure in name resolution

● named.service - BIND Domain Name Server

     Loaded: loaded (/lib/systemd/system/named.service; enabled; vendor preset: enabled)

     Active: active (running) since Thu 2022-02-10 16:30:54 MSK; 9s ago

       Docs: man:named(8)

   Main PID: 7409 (named)

      Tasks: 14 (limit: 4575)

     Memory: 32.4M

     CGroup: /system.slice/named.service

             └─7409 /usr/sbin/named -f -u bind

  

Feb 10 16:30:54 epamtrserver03 named[7409]: zone 127.in-addr.arpa/IN: loaded serial 1

Feb 10 16:30:54 epamtrserver03 named[7409]: zone 255.in-addr.arpa/IN: loaded serial 1

Feb 10 16:30:54 epamtrserver03 named[7409]: zone 98.168.192.in-addr.arpa/IN: loaded serial 2

Feb 10 16:30:54 epamtrserver03 named[7409]: zone localhost/IN: loaded serial 2

Feb 10 16:30:54 epamtrserver03 named[7409]: zone EPAM.TR.LOCAL/IN: NS 'epamtrserver_03.EPAM.TR.LOCAL' has no address records (A or AAAA)

Feb 10 16:30:54 epamtrserver03 named[7409]: zone EPAM.TR.LOCAL/IN: not loaded due to errors.

Feb 10 16:30:54 epamtrserver03 named[7409]: all zones loaded

Feb 10 16:30:54 epamtrserver03 named[7409]: running

Feb 10 16:30:55 epamtrserver03 named[7409]: managed-keys-zone: Key 20326 for zone . is now trusted (acceptance timer complete)

Feb 10 16:30:58 epamtrserver03 named[7409]: resolver priming query complete
```
Edit forward.bind
```bash
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     epamtrserver_03.EPAM.TR.LOCAL. root.epamtrserver_03.EPAM.TR.LOCAL. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      epamtrserver_03.EPAM.TR.LOCAL.
@       IN      A       192.168.98.1
@       IN      AAAA    ::1
epamtrserver_03 IN A    192.168.98.1
test    IN      A       [192.168.98.111](http://192.168.98.111)
```
Restart
```bash
ilya@epamtrserver03:~$ sudo service bind9 restart
ilya@epamtrserver03:~$ sudo service bind9 status

● named.service - BIND Domain Name Server

     Loaded: loaded (/lib/systemd/system/named.service; enabled; vendor preset: enabled)

     Active: active (running) since Thu 2022-02-10 22:56:22 MSK; 5s ago

       Docs: man:named(8)

   Main PID: 8220 (named)

      Tasks: 14 (limit: 4575)

     Memory: 29.0M

     CGroup: /system.slice/named.service

             └─8220 /usr/sbin/named -f -u bind

  

Feb 10 22:56:22 epamtrserver03 named[8220]: zone 0.in-addr.arpa/IN: loaded serial 1

Feb 10 22:56:22 epamtrserver03 named[8220]: zone 255.in-addr.arpa/IN: loaded serial 1

Feb 10 22:56:22 epamtrserver03 named[8220]: zone 127.in-addr.arpa/IN: loaded serial 1

Feb 10 22:56:22 epamtrserver03 named[8220]: zone localhost/IN: loaded serial 2

Feb 10 22:56:22 epamtrserver03 named[8220]: zone EPAM.TR.LOCAL/IN: loaded serial 2

Feb 10 22:56:22 epamtrserver03 named[8220]: zone 98.168.192.in-addr.arpa/IN: loaded serial 2

Feb 10 22:56:22 epamtrserver03 named[8220]: all zones loaded

Feb 10 22:56:22 epamtrserver03 named[8220]: running

Feb 10 22:56:22 epamtrserver03 named[8220]: managed-keys-zone: Key 20326 for zone . is now trusted (acceptance timer complete)

Feb 10 22:56:26 epamtrserver03 named[8220]: resolver priming query complete
```
Success!

Try to check our fake test host
```bash
lya@epamtrserver03:~$ host test
Host test not found: 2(SERVFAIL)
ilya@epamtrserver03:~$ sudo vi /var/lib/bind/forward.bind
ilya@epamtrserver03:~$ host 192.168.98.111
111.98.168.192.in-addr.arpa domain name pointer [192.168.98.111](http://192.168.98.111).
```
Fail.

## Now, [[1 DHCP Lab]] paragraph 1. 

##  3. Generate a key for the authentication of our DNS-server
```bash
ilya@epamtrserver03:~$ tsig-keygen -a hmac-md5 dhcp_updater
key "dhcp_updater" {
algorithm hmac-md5;
secret "nA7disCxmkYXay9d/p+umA==";
};
```
Add this key to /etc/bind/named.conf.local
```bash
//
// Do any local configuration here
//
key DHCP_UPDATER {
        algorithm hmac-md5;
        secret "nA7disCxmkYXay9d/p+umA==";
        };
 
zone "EPAM.TR.LOCAL" {
        type master;
        file "/var/lib/bind/forward.bind";
        check-names ignore;
        allow-update { key DHCP_UPDATER; };
        };

zone "98.168.192.in-addr.arpa" {
        type master;
        file "/var/lib/bind/reverse.bind";
        check-names ignore;
        allow-update { key DHCP_UPDATER; };
        };

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
```

```bash
ilya@epamtrserver03:~$ sudo systemctl restart bind9
ilya@epamtrserver03:~$ sudo systemctl status bind9

● named.service - BIND Domain Name Server

     Loaded: loaded (/lib/systemd/system/named.service; enabled; vendor preset: enabled)

     Active: active (running) since Wed 2022-04-06 13:04:22 MSK; 7s ago

       Docs: man:named(8)

   Main PID: 11728 (named)

      Tasks: 14 (limit: 4575)

     Memory: 28.9M

     CGroup: /system.slice/named.service

             └─11728 /usr/sbin/named -f -u bind

  

Apr 06 13:04:22 epamtrserver03 named[11728]: zone 0.in-addr.arpa/IN: loaded serial 1

Apr 06 13:04:23 epamtrserver03 named[11728]: zone 98.168.192.in-addr.arpa/IN: loaded serial 2

Apr 06 13:04:23 epamtrserver03 named[11728]: zone 127.in-addr.arpa/IN: loaded serial 1

Apr 06 13:04:23 epamtrserver03 named[11728]: zone localhost/IN: loaded serial 2

Apr 06 13:04:23 epamtrserver03 named[11728]: zone 255.in-addr.arpa/IN: loaded serial 1

Apr 06 13:04:23 epamtrserver03 named[11728]: zone EPAM.TR.LOCAL/IN: loaded serial 2

Apr 06 13:04:23 epamtrserver03 named[11728]: all zones loaded

Apr 06 13:04:23 epamtrserver03 named[11728]: running

Apr 06 13:04:23 epamtrserver03 named[11728]: managed-keys-zone: Key 20326 for zone . is now trusted (acceptance timer complete)

Apr 06 13:04:26 epamtrserver03 named[11728]: resolver priming query complete
```

## Return to [[1 DHCP Lab]] paragraph 3

## 4. Search the status of BND9
```bash
ilya@epamtrserver03:~$ sudo systemctl status bind9

● named.service - BIND Domain Name Server

     Loaded: loaded (/lib/systemd/system/named.service; enabled; vendor preset: enabled)

     Active: active (running) since Thu 2022-04-07 17:28:14 MSK; 2 days ago

       Docs: man:named(8)

   Main PID: 1213 (named)

      Tasks: 14 (limit: 4575)

     Memory: 75.4M

     CGroup: /system.slice/named.service

             └─1213 /usr/sbin/named -f -u bind

  

Apr 09 21:01:43 epamtrserver03 named[1213]: none:100: 'max-cache-size 90%' - setting to 3510MB (out of 3901MB)

Apr 09 21:01:43 epamtrserver03 named[1213]: configuring command channel from '/etc/bind/rndc.key'

Apr 09 21:01:43 epamtrserver03 named[1213]: configuring command channel from '/etc/bind/rndc.key'

Apr 09 21:01:43 epamtrserver03 named[1213]: reloading configuration succeeded

Apr 09 21:01:43 epamtrserver03 named[1213]: scheduled loading new zones

Apr 09 21:01:43 epamtrserver03 named[1213]: any newly configured zones are now loaded

Apr 09 21:01:43 epamtrserver03 named[1213]: running

Apr 09 21:01:43 epamtrserver03 named[1213]: managed-keys-zone: Key 20326 for zone . is now trusted (acceptance timer complete)

Apr 09 21:05:03 epamtrserver03 named[1213]: listening on IPv4 interface ens33, 192.168.98.1#53

Apr 09 22:01:40 epamtrserver03 named[1213]: managed-keys-zone: Key 20326 for zone . is now trusted (acceptance timer complete)

ilya@epamtrserver03:~$ sudo systemctl status isc-dhcp-server

● isc-dhcp-server.service - ISC DHCP IPv4 server

     Loaded: loaded (/lib/systemd/system/isc-dhcp-server.service; enabled; vendor preset: enabled)

     Active: active (running) since Sat 2022-04-09 22:06:18 MSK; 4min 41s ago

       Docs: man:dhcpd(8)

   Main PID: 4935 (dhcpd)

      Tasks: 4 (limit: 4575)

     Memory: 15.5M

     CGroup: /system.slice/isc-dhcp-server.service

             └─4935 dhcpd -user dhcpd -group dhcpd -f -4 -pf /run/dhcp-server/dhcpd.pid -cf /etc/dhcp/dhcpd.conf ens33

  

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Sending on   Socket/fallback/fallback-net

Apr 09 22:06:18 epamtrserver03 dhcpd[4935]: Server starting service.

Apr 09 22:06:47 epamtrserver03 dhcpd[4935]: DHCPDISCOVER from 00:50:56:33:27:fe via ens33

Apr 09 22:06:48 epamtrserver03 dhcpd[4935]: DHCPOFFER on 192.168.98.101 to 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:07:51 epamtrserver03 dhcpd[4935]: DHCPDISCOVER from 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:07:52 epamtrserver03 dhcpd[4935]: DHCPOFFER on 192.168.98.101 to 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:08:54 epamtrserver03 dhcpd[4935]: DHCPDISCOVER from 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:08:55 epamtrserver03 dhcpd[4935]: DHCPOFFER on 192.168.98.101 to 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:09:59 epamtrserver03 dhcpd[4935]: DHCPDISCOVER from 00:50:56:33:27:fe (epamtrserver03) via ens33

Apr 09 22:10:00 epamtrserver03 dhcpd[4935]: DHCPOFFER on 192.168.98.101 to 00:50:56:33:27:fe (epamtrserver03) via ens33
```
Search the bind9 log
```bash
ilya@epamtrserver03:~$ ls -lh /var/lib/bind/
```
##  Go to [[1 DHCP Lab]] paragraph 4
## 5. Getting an answer via the hosts file
```bash
ilya@epamtrserver03:~$ sudo vi /etc/hosts

127.0.0.1 localhost
127.0.1.1 epamtrserver_03
192.168.98.102 epamtrserver_01


# The following lines are desirable for IPv6 capable hosts
::1    ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
Ping EPAMTrServer_01 
```bash
ilya@epamtrserver03:~$ ping epamtrserver_01

PING epamtrserver_01 (192.168.98.102) 56(84) bytes of data.

64 bytes from epamtrserver_01 (192.168.98.102): icmp_seq=1 ttl=64 time=0.532 ms

64 bytes from epamtrserver_01 (192.168.98.102): icmp_seq=2 ttl=64 time=0.436 ms

64 bytes from epamtrserver_01 (192.168.98.102): icmp_seq=3 ttl=64 time=0.557 ms

64 bytes from epamtrserver_01 (192.168.98.102): icmp_seq=4 ttl=64 time=0.513 ms
```
## 6. Get answer via DNS-server
Edit **/var/lib/bind/forward.bind**
```bash
;
; BIND data file for local loopback interface
;
$TTL    604800
@      IN      SOA    epamtrserver_03.EPAM.TR.LOCAL. root.epamtrserver_03.EPAM.TR.LOCAL. (
                              2        ; Serial
                        604800        ; Refresh
                          86400        ; Retry
                        2419200        ; Expire
                        604800 )      ; Negative Cache TTL
;
@      IN      NS      epamtrserver_03.EPAM.TR.LOCAL.
@      IN      A      192.168.98.1
  
epamtrserver_03 IN A    192.168.98.1
test    IN      A      192.168.98.111
epamtrserver01  IN A    [192.168.98.102](http://192.168.98.102)
```
Get answer
```bash
ilya@epamtrserver03:~$ host epamtrserver01
epamtrserver01.EPAM.TR.LOCAL has address 192.168.98.102

ilya@epamtrserver03:~$ host 192.168.98.102
102.98.168.192.in-addr.arpa domain name pointer epamtrserver01.EPAM.TR.LOCAL.98.168.192.in-addr.arpa.
```