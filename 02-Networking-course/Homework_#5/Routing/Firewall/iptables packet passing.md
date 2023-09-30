# iptables: packet passing

#iptables #networking 	

Source: https://interface31.ru/tech_it/2020/02/osnovy-iptables-dlya-nachinayushhih-chast-1.html, [Linux-IP](http://linux-ip.net/pages/diagrams.html)
Related: [[IPtables utility]] [[iptables rules]]

## Standard order of packets passing 
![[Pasted image 20220414172857.png]]

Eponymous Chains passed sequentially, so in this picture Tables putted into Chains. Although, in reality Chains are in Tables.

## Transit traffic
![[Pasted image 20220415113343.png]]

It never comes to the INPUT and OUTPUT Chains. DNAT makes before the filtering. Only incoming packets.

## Local packets
![[Pasted image 20220415113507.png]]

Local traffic never comes to FORWARD Chains. And there are two packets:  incoming (PREROUTING and INPUT) and outcoming (POSTROUTING and OUTPUT). 


![[Pasted image 20220429153135.png]]

