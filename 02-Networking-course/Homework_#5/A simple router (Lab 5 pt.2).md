Tags: #fact - [[Linux]] - [[Ubuntu Server]] - [[Networking]] - [[Route]] - [[NAT]]

Related: [[5 NAT port forwarding]], [[NAT Lab]], [[Problem with White And Grey addresses]]

Source: [archwiki](https://wiki.archlinux.org/title/Router), [andreyrex](https://andreyex.ru/ubuntu/kak-sozdat-prostoj-marshrutizator-s-ubuntu-server-18-04-1-lts-bionic-beaver/)

--- 

## Starting lines
We have that configuration of our net
![[Screenshot from 2022-12-13 12-31-13.png]]
***host1**** is in LAN (VMware subnet)
***host2*** is in WAN (my home 192.168.0.0 network)
***Router*** has bridged interface ***ext0*** and internal subnet interface ***int0*** 

IP addresses are in the picture.

LAN is `192.186.0.0/24`

```bash 
[Ilya@aorus2022 ~]$ subnetcalc 192.186.0.2/24
Address       = 192.186.0.2
                   11000000 . 10111010 . 00000000 . 00000010
Network       = 192.186.0.0 / 24
Netmask       = 255.255.255.0
Broadcast     = 192.186.0.255
Wildcard Mask = 0.0.0.255
Hosts Bits    = 8
Max. Hosts    = 254   (2^8 - 2)
Host Range    = { 192.186.0.1 - 192.186.0.254 }
Properties    =
   - 192.186.0.2 is a HOST address in 192.186.0.0/24
   - Class C
GeoIP Country = United States (US)
DNS Hostname  = (Name or service not known)
```

## Section of the SSH config

See the [[10 DevOps/11 Linux/112 Networking/Remote Control/SSH]] evergreen note. I use the name `epamkey`.

## Section of the NET config

See the [[+How to Configure Static IP Address on Ubuntu 18.04]] litnote. 

See the problem with interfaces' names: [[How to rename a network interface in 20.04]]

## Configuring the NAT

Read the fact note [[IPtables utility]]. The need the `nat` table.  

Check that site [linuxhint](https://linuxhint.com/configure-nat-on-ubuntu/)

Install the iptables
```bash 
ilya@router:~$ sudo apt install iptables-persistent
```
Turn on the forwarding by uncommenting that line:
```bash 
ilya@router:~$ sudo vi /etc/sysctl.conf

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

ilya@router:~$ sudo sysctl -p
net.ipv4.ip_forward = 1
```

Check the rules
```bash 
ilya@router:~$ sudo iptables -L

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination  
```

Enable the masquerading

```bash 
ilya@router:~$ sudo iptables -t nat -A POSTROUTING -j MASQUERADE

ilya@router:~$ sudo iptables -t nat -L

Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  anywhere             anywhere   

```

Save the iptables rules in the file `/etc/iptables/rules.v4`
```bash 
root@router:~$ sh -c "iptables-save > /etc/iptables/rules.v4"

# Generated by iptables-save v1.8.7 on Tue Dec 13 13:54:30 2022
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j MASQUERADE
COMMIT
# Completed on Tue Dec 13 13:54:30 2022
```

Reference from ArchWiki
![[Screenshot from 2022-12-14 14-43-49.png]]

```bash 
# Accept incoming packets from localhost and the LAN interface.
root@router:~$ iptables -A INPUT -i lo -j ACCEPT
root@router:~$ iptables -A INPUT -i int0 -j ACCEPT

# Accept incoming packets from the WAN if the router initiated the connection.
root@router:~$ iptables -A INPUT -i ext0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Forward LAN packets to the WAN
root@router:~$ iptables -A FORWARD -i int0 -o ext0 -j ACCEPT

# Forward WAN packets to the LAN if the LAN initiated the connection.
root@router:~$ iptables -A FORWARD -i ext0 -o int0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

I've configured the ssh connection to __host1__ via __router__. I've shut down the bridge connection on __host1__. I can see the __host2__ from the __host1__!       
```bash
ilya@host1:~$ ping 192.168.0.113
PING 192.168.0.113 (192.168.0.113) 56(84) bytes of data.
64 bytes from 192.168.0.113: icmp_seq=1 ttl=63 time=0.583 ms
64 bytes from 192.168.0.113: icmp_seq=2 ttl=63 time=0.523 ms
64 bytes from 192.168.0.113: icmp_seq=3 ttl=63 time=0.616 ms
64 bytes from 192.168.0.113: icmp_seq=4 ttl=63 time=0.556 ms
64 bytes from 192.168.0.113: icmp_seq=5 ttl=63 time=0.589 ms
64 bytes from 192.168.0.113: icmp_seq=6 ttl=63 time=0.429 ms
64 bytes from 192.168.0.113: icmp_seq=7 ttl=63 time=0.563 ms
64 bytes from 192.168.0.113: icmp_seq=8 ttl=63 time=0.633 ms
64 bytes from 192.168.0.113: icmp_seq=9 ttl=63 time=0.598 ms
```

But I can't reach the __host1__ from __host2__
```bash 
ilya@host2:~$ ping 192.186.0.2
PING 192.186.0.2 (192.186.0.2) 56(84) bytes of data.
^C
--- 192.186.0.2 ping statistics ---
10 packets transmitted, 0 received, 100% packet loss, time 9193ms
```

Although I can ping the __router__ internal interface...
```bash 
ilya@host2:~$ ping 192.186.0.1
PING 192.186.0.1 (192.186.0.1) 56(84) bytes of data.
64 bytes from 192.186.0.1: icmp_seq=1 ttl=240 time=416 ms
64 bytes from 192.186.0.1: icmp_seq=2 ttl=240 time=436 ms
64 bytes from 192.186.0.1: icmp_seq=3 ttl=240 time=453 ms
```

We configure the rule for the traffic from the external network to our `host2`
```bash
root@router:~$ iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ext0 -j SNAT --to-source 192.186.0.2
```

We add the port forwarding via NAT using port `2022` on `router` and the standard SSH port 22 on `host1`.    
```bash
root@router:~$ iptables -t nat -A PREROUTING -p tcp --dport 2022 -j DNAT --to 192.186.0.2:22
root@router:~$ iptables -A INPUT -p tcp --dport 2022 -j ACCEPT

root@router:~$ sh -c "iptables-save > /etc/iptables/rules.v4"
root@router:~$ systemctl restart iptables
```

The final output of our iptables configuration is here

```bash
root@router:~# iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -i int0 -j ACCEPT
-A INPUT -i ext0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 2022 -j ACCEPT
-A FORWARD -i int0 -o ext0 -j ACCEPT
-A FORWARD -i ext0 -o int0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
root@router:~# iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -p tcp -m tcp --dport 2022 -j DNAT --to-destination 192.186.0.2:22
-A POSTROUTING -j MASQUERADE
```

## Check the result

```bash
ilya@host2:~$ ssh -v -p 2022 ilya@192.168.101
OpenSSH_8.9p1 Ubuntu-3, OpenSSL 3.0.2 15 Mar 2022
...
ilya@host1:~$ uname -a
Linux host1 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```

And rule to return traffic. Change gray IP to white IP. For the `host2` connection via [[10 DevOps/11 Linux/112 Networking/Remote Control/SSH]] 2222 port through address `192.168.0.114`

```bash
root@router:~ iptables -t nat -A POSTROUTING -p tcp --sport 22 -d 192.186.0.2 -j SNAT --to-source 192.168.0.114:2222
root@router:~$ sh -c "iptables-save > /etc/iptables/rules.v4"
root@router:~$ systemctl restart iptables
```

## The result iptables policies 

```bash
root@router:~# iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -i int0 -j ACCEPT
-A INPUT -i ext0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 2022 -j ACCEPT
-A FORWARD -i int0 -o ext0 -j ACCEPT
-A FORWARD -i ext0 -o int0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

root@router:~# iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -p tcp -m tcp --dport 2022 -j DNAT --to-destination 192.186.0.2:22
-A POSTROUTING -j MASQUERADE
-A POSTROUTING -d 192.186.0.2/32 -p tcp -m tcp --sport 22 -j SNAT --to-source 192.168.0.114:2222
```