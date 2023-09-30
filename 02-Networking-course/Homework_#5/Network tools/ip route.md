# ip route
```bash
[Ilya@homepc storage]$ ip route
default via 192.168.0.1 dev wlp7s0u1 proto dhcp metric 600 
172.16.28.0/24 dev vmnet1 proto kernel scope link src 172.16.28.1 
192.168.0.0/24 dev wlp7s0u1 proto kernel scope link src 192.168.0.13 metric 600 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown 
192.168.243.0/24 dev vmnet8 proto kernel scope link src 192.168.243.1
```
Create new route - send
```bash
ip  route add 10.0.3.0/24 dev enp0s3 metric 2000
```
Delete the route entry
```bash
ip  route delete 10.0.3.0/24
```