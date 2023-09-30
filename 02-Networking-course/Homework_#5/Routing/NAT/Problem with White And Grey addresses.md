Tags: #fact - [[Networking]] - [[NAT]] 

Source:

Reference:

Related: [[A simple router (Lab 5 pt.2)]] 

---

Hello!!!

I've emulated the simple network in my VMware environment: https://drive.google.com/file/d/1BJQCPUqRtvIbLjfUZnDVX3TW9r7XqeJR/view?usp=sharing

The `host1` is in the internal network `192.186.0.0/24`, the `host2` is in my home network `192.168.0.0/24`.

The `router` has two net adapters in both networks. 

All machines are operated by Ubuntu Server 22.04.

I've installed iptables on `router` and configured it.

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

If I try to connect to the `host1` via the router's port 2022 on the external adapter it will connect successfully.

```bash
ilya@host2:~$ ssh -v -p 2022 ilya@192.168.101
OpenSSH_8.9p1 Ubuntu-3, OpenSSL 3.0.2 15 Mar 2022
...
ilya@host1:~$ uname -a
Linux host1 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```

As you can see I've added a rule to make the fake address `192.168.0.114` and port 2222 for the `host1`.  

But when I connect to port 2222 on the fake address `192.168.0.114` it fails

```bash
ilya@host2:~$ ssh ilya@192.168.0.114:2222
ssh: Could not resolve hostname 192.168.0.114:2222: Name or service not known
```

Obviously the rule isn't working

```bash
root@router:~ iptables -t nat -A POSTROUTING -p tcp --sport 22 -d 192.186.0.2 -j SNAT --to-source 192.168.0.114:2222
```

So I have skipped some rules or configuration options...

Could you help me?

===================================================


