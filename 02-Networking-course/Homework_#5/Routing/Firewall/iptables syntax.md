# iptables syntax

Tags: #fact - #iptables #networking #firewall #bash

Related: [[IPtables utility]], [[iptables rules]], [[iptables packet passing]], [[A simple router (Lab 5 pt.2)]]

Source: [How to observe the rules](https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules)

---

```bash
iptables [-t table] {-A|-C|-D} chain rule-specification
```

Default rules dwell in   `/run/xtables.lock` in Ubuntu Server 20.04.

## How to see all rules with numbers
```bash
root@router:~# iptables -L --line-numbers
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     all  --  anywhere             anywhere            
2    ACCEPT     all  --  anywhere             anywhere
``` 

## How to delete the rule

```bash
root@router:~$ iptables -D INPUT 1
```

It's in table filter.

```bash

```

```bash

```
## How to replace the rule
[Replace](https://stackoverflow.com/questions/33465937/how-do-you-edit-a-rule-in-iptables) 


```bash

```

```bash

```

```bash

```

```bash

```

```bash

```

```bash

```

```bash

```