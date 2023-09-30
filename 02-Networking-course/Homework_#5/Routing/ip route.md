
Tags: #fact - [[Linux]] - [[Ubuntu Server]] - [[Networking]] - [[Routes]] - [[ip]]

Related: [[Communication administratively filtered]], [[Router]]

Source: [Winitpro](https://winitpro.ru/index.php/2020/04/13/nastrojka-marshrutov-v-linux/), [Add a route](https://devconnected.com/how-to-add-route-on-linux/), [Routing Tables](https://ubuntu.com/core/docs/networkmanager/routing-tables)

---
## Reading routes

To see all routes type the command
```bash
ip route

default via 192.168.0.1 dev ens33 proto dhcp src 192.168.0.14 metric 101 
default via 192.168.98.1 dev ens34 proto dhcp src 192.168.98.109 metric 102 
192.168.0.0/24 dev ens33 proto kernel scope link src 192.168.0.14 metric 100 
192.168.0.1 dev ens33 proto dhcp scope link src 192.168.0.14 metric 100 
192.168.98.0/24 dev ens34 proto kernel scope link src 192.168.98.109 metric 100 
192.168.98.1 dev ens34 proto dhcp scope link src 192.168.98.109 metric 100 
```

**Proto Kernel** - the route created by kernel.
**Proto Static**  - the route created by admin.
**Metric** - the route priority.

Checking the route for concrete IP-address:
```bash
ilya@mailserver02:~$ ip route get 8.8.8.8
8.8.8.8 via 192.168.0.1 dev ens33 src 192.168.0.14 uid 1000 
    cache 
```

## Add or delete the route
```bash
sudo ip route del default via 192.168.0.1 dev ens33 proto dhcp src 192.168.0.14 metric 100 
```

```bash 
sudo ip route add default via 192.168.0.1 dev ens33 proto dhcp src 192.168.0.14 metric 101 
```
## Changing the route
```bash
ilya@mailserver02:~$ sudo ip route replace default via 192.168.98.1 dev ens34 proto dhcp src 192.168.98.109 metric 102

```

After all changes we need to restart the network:
```bash 
sudo systemctl restart systemd-networkd
```
