Tags: #perm - #coarse - [[Linux]] - [[Networking]]

Source: [youtube.com](https://www.youtube.com/watch?v=D4iXqvy-rfA)

Reference: 

Related: [[4 SCP]], [[A simple router (Lab 5 pt.2)]], [[10 DevOps/11 Linux/112 Networking/Remote Control/ssh]]

---
## Main blueprint

![[Screenshot from 2022-12-13 08-51-40.png]]

## Generate keys

```bash
[Ilya@aorus2022 ~]$ ssh-keygen -t rsa
```

## Copy public key to the server
```bash 
[Ilya@aorus2022 Bash]$ ssh-copy-id -i /home/Ilya/.ssh/epamkey.pub ilya@192.168.0.111
```

## Prove the connection
```bash 
ssh ilya@machine_ip_address
```

## Check the configuration on our server
```bash 
ilya@nettestmachine:~$ cd /etc/ssh
ilya@nettestmachine:/etc/ssh$ sudo vi sshd_config

>Interesting options

#Port 22
#PubkeyAuthentication yes
#PasswordAuthentication yes
#PermitRootLogin yes

```

`sshd.config` is a file for the server, `ssh.config` is a file for the client (our server is client too)!

## Making some convenient things

We have `.bashrc` in the **`home`** directory on our client machine
```bash 
ilya@nettestmachine:~$ sudo vi .bashrc 

alias sshnettest='ssh ilya@192.168.0.112'
alias uclone='ssh ilya@192.168.0.111'
```

It doesn't work on my Fedora... Because I should restart the system or an other service...  
```bash 
Ilya@aorus2022 Bash]$ sshnettest
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-56-generic x86_64)
```

## Useful parameters

`-C` - compression. Good for internet connection
`-p 6022` - connection via a specific port. We've configured that port earlier.

## How to close the session
```bash 
exit
```

```bash 

```

```bash 

```

```bash 

```