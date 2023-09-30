
#NAT #networking #port_forwarding #ubuntu 

Source: https://obu4alka.ru/probros-portov-port-forwarding-v-linux-ispolzuya-iptables.html 

Related: [[NAT working]], [[IPtables utility]], [[iptables rules]], [[PAT]], [[A simple router (Lab 5 pt.2)]]

![[Pasted image 20220413160327.png]]

VM2 Eth2 has bridged network. VM2 Eth1 and VM1 Eth1 is an internal LAN segment.

## Prepare
VM2 is EPAMTrServer_03
ens33: 192.168.98.1 - LAN adapter
ens34 192.168.0.12 - WAN adapter (bridged network)

VM1 is EPAMTrMachine_03
ens33: 192.168.98.104

Watch default rules

```bash
ilya@epamtrserver03:~$ sudo iptables -L
[sudo] password for ilya: 
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination   
```


## Configure
### Allow to forwarding

```bash
ilya@epamtrserver03:~$ sudo iptables -A FORWARD -i ens33 -s 192.168.98.0/24 -j ACCEPT

ilya@epamtrserver03:~$ sudo iptables -A FORWARD -i ens34 -d 192.168.98.0/24 -j ACCEPT

ilya@epamtrserver03:~$ sudo iptables -P FORWARD DROP

```

So now we can send packets from LAN and WAN. Default policy for forwarding is DROP.

```bash
ilya@epamtrserver03:~$ sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy DROP)
target     prot opt source               destination         
ACCEPT     all  --  192.168.98.0/24      anywhere            
ACCEPT     all  --  anywhere             192.168.98.0/24     

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination 
```
       
Rules has added automatically. 

### Configure the NAT

If we don't declare the table by `-t` key, iptables tries to add rule into table `filter`. So we need to use `-t nat`.
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ens34 -j SNAT --to-source 192.168.98.105 
```
[[iptables - how to view rules]]
The result
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -n -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
SNAT       all  --  192.168.0.0/24       0.0.0.0/0            to:192.168.98.105

```

### Configure the PAT for RDP server
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A PREROUTING -i ens34 -p tcp -m tcp --dport 3389 -j DNAT --to-destination 192.168.98.105
```

The result
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -n -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:3389 to:192.168.98.105

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
SNAT       all  --  192.168.0.0/24       0.0.0.0/0            to:192.168.98.105
```


### Transparent proxy redirection
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A PREROUTING -d 192.168.98.0/24 -i ens33 -p tcp -m multiport --dports 80,443 -j REDIRECT --to-ports 3128
```
**We write ports without spaces.**

### For SSH redirection
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A PREROUTING -d 192.168.98.0/24 -i ens33 -p tcp -m multiport --dports 22,2222 -j REDIRECT --to-ports 2222
```

```bash
ilya@epamtrserver03:~$ netstat -nlp | grep 22
```


### Removing rules

First we need to watch the number of unnecessary rule 
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -n -L --line-numbers

Chain PREROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:3389 to:192.168.98.105
2    REDIRECT   tcp  --  0.0.0.0/0            192.168.98.0/24      multiport dports 80,443 redir ports 3128
3    REDIRECT   tcp  --  0.0.0.0/0            192.168.98.0/24      multiport dports 22,2222 redir ports 2222

Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    SNAT       all  --  192.168.0.0/24       0.0.0.0/0            to:192.168.98.105

```
Then use the `-D` key,  the Chain's name and number of rule.
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -D PREROUTING 3
```

### Forwarding SSH

Change white IP to gray IP
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A PREROUTING -p tcp -d 192.168.0.0/24 --dport 2222 -j DNAT --to-destination 192.168.98.105:22
```
SSH is in TCP protocol stack. 

And rule to return traffic. Change gray IP to white IP.  ## ?
```bash
ilya@epamtrserver03:~$ sudo iptables -t nat -A POSTROUTING -p tcp --sport 22 -d 192.168.98.105 -j SNAT --to-source 192.168.0.14:2222
```


```bash

```
