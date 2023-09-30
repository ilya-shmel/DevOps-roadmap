Tags: #fact - [[iptables]] - [[Networking]] - [[Linux]]

Source: [IPtables interface](https://interface31.ru/tech_it/2020/02/osnovy-iptables-dlya-nachinayushhih-chast-1.html)

Related: [[nftables]], [[SELinux]], [[iptables rules]], [[iptables syntax]]

## Definition

**iptables** is a [user-space](https://en.wikipedia.org/wiki/User_space "User space") utility program that allows a [system administrator](https://en.wikipedia.org/wiki/System_administrator "System administrator") to configure the [IP packet filter rules](https://en.wikipedia.org/wiki/Packet_filter "Packet filter") of the [Linux kernel](https://en.wikipedia.org/wiki/Linux_kernel "Linux kernel") [firewall](https://en.wikipedia.org/wiki/Firewall_(computing) "Firewall (computing)"), implemented as different [Netfilter](https://en.wikipedia.org/wiki/Netfilter "Netfilter") modules.

It's not a Linux firewall. The firewall is **netfilter**!!! iptables is an utility for netfilter setups. 

The new firewall utility is [[nftables]]s.

## Structure

**Rules => Chains =>Tables**

Tables are the upper level, Rules are the lower level. There are 5 tables.

![[Pasted image 20220414154251.png]]

### Tables
1. **raw** - for the packet processing before **conntrack** (which monitoring a connection status and the packet's affiliation to connections). 
2. **mangle** - for the some TTL or TOS headers modification and labeling packets and connections.
3. **nat** - for the converting addresses and ports  of a source and a destination.
4. **filter** - for the packet filtration. Filter is a default table. 
5. **security** - for work with Access Control Systems like [[SELinux]].

Tables named in low case, Chains named in UPPER case. **But user Chains also named in low case!!!**

### Chains
Default Chains  

1. **PREROUTING** - for the incoming traffic before the first route decision. 
2. **INPUT** -  for the incoming traffic of the current node.
3. **FORWARD** - for the transit traffic of the node.
4. **OUTPUT** - for the outcoming traffic of the current node.
5. **POSTROUTING** - for the all outcoming traffic after an applying of all route decisions.

After an initialization all Chains are empty (there are no rules). Every Chain has the default rule ACCEPT which apply to the packet if it passed this Chain and didn't catch by another rules.

## Modules
There are additional modules for iptables: connlimit, conntack, limit, recent.



