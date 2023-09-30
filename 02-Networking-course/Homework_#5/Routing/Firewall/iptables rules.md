# iptables rules
#iptables #networking 	

Source: https://interface31.ru/tech_it/2020/02/osnovy-iptables-dlya-nachinayushhih-chast-1.html
Related: [[IPtables utility]], [[iptables syntax]], [[iptables packet passing]]

Every rule contains 3 items:
- criteria
- action
- count

![[Pasted image 20220414170714.png]]

## Criteria
If there are no a criteria then an action applies to all packets. After the action the count calculates the number of packets and their size in bytes.

Criteria can be numerous. They combinates by AND and AND NOT.

## Action
Common actions are:
- ACCEPT - pass the packet
- DROP - block the packet 
- REJECT - block the packet and send a notation to the source

Another actions: MASQUERADE (nat), MARK (mangle), LOG.

There are **terminal** and **non-terminal** actions. Terminal actions cancels the packet passing in Chain. It obvious for Tabels filter, nat. Non-terminal are mangle actions.

## Passing through rules
In Chain the packet passes rules until the first trigger. Then the packet will be move to the next rule (if the action is non-terminal) or will leave the Chain (if the action is terminal).  

![[Pasted image 20220414172549.png]]

