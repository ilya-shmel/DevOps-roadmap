
#ssh #linux #networking 

Related: [[4 SCP]], [[ssh-copy-id ERROR No identities found]], [[ERROR @@@@@@@@@]], [[10 DevOps/11 Linux/112 Networking/Remote Control/SSH]]

Source: [ssh-keygen instruction](https://www.ssh.com/academy/ssh/keygen#creating-an-ssh-key-pair-for-user-authentication)

Port: **22/TCP**

## Install 
```bash
sudo dnf install openssh-server
```

Start SSH dervice
```bash
sudo service ssh start

#OR

sudo systemctl start sshd
```

## Generate Keys
```bash
ssh-keygen -t rsa
```

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ilya/.ssh/id_rsa): epamtrserver_02_key
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in epamtrserver_02_key.
Your public key has been saved in epamtrserver_02_key.pub.
The key fingerprint is:
SHA256:1OooWs001ga9Qzqr4MxubOeBSxldz/6kkM91reyWw2E ilya@192.168.98.103
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|       . .       |
|      o + .      |
|   . . O o       |
|  . . * S        |
|   + = X .  E.   |
| .= + B o oo.o.  |
| =+=.+ + = o=.   |
| +Boo   + .o+.   |
+----[SHA256]-----+
```

Check the .ssh/ directory
```bash
[ilya@192 Documents]$ cd ~/.ssh
[ilya@192 .ssh]$ ls -lh
total 8,0K
-rw-------. 1 ilya ilya 565 фев  9 17:28 authorized_keys
-rw-r--r--. 1 ilya ilya 193 апр 13 13:36 known_hosts
```

I recommend to move keys to the .ssh/  directory
```bash
[ilya@192 Documents]$ ls -lh
total 8,0K
-rw-------. 1 ilya ilya 1,7K апр 13 14:27 epamtrserver_02_key
-rw-r--r--. 1 ilya ilya  401 апр 13 14:27 epamtrserver_02_key.pub
-rw-rw-r--. 1 ilya ilya    0 апр 13 13:33 scp-doc
```

```bash
[ilya@192 Documents]$ mv epam* ~/.ssh/
```

## Copy key to a remote host
```bash
ilya@192 ~]$ ssh-copy-id -i /home/ilya/.ssh/epamtrserver_02_key.pub ilya@192.168.98.102  #user@hostname
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ilya/.ssh/epamtrserver_02_key.pub"
The authenticity of host '192.168.98.102 (192.168.98.102)' can't be established.
ECDSA key fingerprint is SHA256:d1NPN7AWjJq0DRHWo6h7Nb8UP6T+/psbOIwrij0ofkk.
ECDSA key fingerprint is MD5:37:bf:f2:9f:a9:b1:c9:cd:7d:33:c5:03:22:5f:10:07.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ilya@192.168.98.102's password: 
Permission denied, please try again.
ilya@192.168.98.102's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ilya@192.168.98.102'"
and check to make sure that only the key(s) you wanted were added.
```


## Connect via concrete port

```bash
ssh -p2222 ilya@epamtrserver_03
```

Related: [[Failed to open ID file]], [[ssh-copy-id ERROR No identities found]]

```bash

```