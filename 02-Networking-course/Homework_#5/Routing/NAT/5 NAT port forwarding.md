Tags: #nat #port_forwarding #iptables 

Related: [[NAT working]], [[IPtables utility]], [[A simple router (Lab 5 pt.2)]]

Source: https://www.youtube.com/watch?v=u_a3ouarrVU&t=114s, https://obu4alka.ru/probros-portov-port-forwarding-v-linux-ispolzuya-iptables.html

## 0. Turn on the packet forwarding
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
or use  the command [[tee]]
```bash
ilya@epamtrserver03:~$ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```
because the redirection of the output is done not as `sudo`, so it doesn't work. [Watch here](https://askubuntu.com/questions/783017/bash-proc-sys-net-ipv4-ip-forward-permission-denied)

Also we can use another path.
```bash
ilya@epamtrserver03:~$ sudo vi /etc/sysctl.conf
```

Found this line and uncomment it.
```bash
# Uncomment the next line to enable packet forwarding for IPv4
#net.ipv4.ip_forward=1
```
This line turns on the forwarding even after the reboot.


## 1. Turn on NAT
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A POSTROUTING -o ens34 -j MASQUERADE
```
MASQUERADE put ens34 address as SNAT (Source NAT).

Allow forwarding in iptables.
```bash
ilya@epamtrserver03:~$ sudo iptables -A FORWARD -i ens33 -o ens34 -j ACCEPT
```

The result.
```bash
ilya@epamtrserver03:~$ sudo iptables -L -nv
Chain INPUT (policy ACCEPT 60 packets, 4248 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     all  --  ens33  ens34   0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT 35 packets, 3372 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain logdrop (0 references)
 pkts bytes target     prot opt in     out     source               destination   
```

```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -L -nv
Chain PREROUTING (policy ACCEPT 10 packets, 994 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 6 packets, 690 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 27 packets, 2017 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 19 packets, 1418 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    8   599 MASQUERADE  all  --  *      ens34   0.0.0.0/0            0.0.0.0/0         
```

## 2. Configure the client machine
```bash
sudo ip route add default via 192.168.98.1 dev ens33
```

Maybe it's not necessary, because the default gateway already installed. 

## 3. Configure port forwarding
On the External Server we going to use port 9022 for the ssh connection. On the Internal Server we will use port 22.

Add the rule
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 9022 -j DNAT --to 192.168.98.105:22
```

And we should to allow input traffic on 9022 port. 
```bash
sudo iptables -A INPUT -p tcp --dport 9022 -j ACCEPT
```


## 4. Try to connect via port 9022
```bash
[Ilya@homepc Bash]$ ssh -v -p 9022 ilya@192.168.0.11
OpenSSH_8.7p1, OpenSSL 1.1.1n  FIPS 15 Mar 2022
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: Reading configuration data /etc/ssh/ssh_config.d/50-redhat.conf
debug1: Reading configuration data /etc/crypto-policies/back-ends/openssh.config
debug1: configuration requests final Match pass
debug1: re-parsing configuration
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: Reading configuration data /etc/ssh/ssh_config.d/50-redhat.conf
debug1: Reading configuration data /etc/crypto-policies/back-ends/openssh.config
debug1: Connecting to 192.168.0.11 [192.168.0.11] port 9022.
debug1: connect to address 192.168.0.11 port 9022: Connection timed out
ssh: connect to host 192.168.0.11 port 9022: Connection timed out

```

Try to return default DROP-policy for FORWARD Chain. 


 ```bash
ilya@epamtrserver03:~$ sudo iptables -P FORWARD ACCEPT
```

Success!!!
 ```bash
[Ilya@homepc Bash]$ ssh -v -p 9022 ilya@192.168.0.11
OpenSSH_8.7p1, OpenSSL 1.1.1n  FIPS 15 Mar 2022
***
ED25519 key fingerprint is SHA256:FQdEE0yxu4r06oKYVnPpG2hZaLKHJwEb6fVjEtLgtLg.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: 192.168.243.128
    ~/.ssh/known_hosts:4: epamtrmachine_03
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[192.168.0.11]:9022' (ED25519) to the list of known hosts.
***
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)
```

```bash

```