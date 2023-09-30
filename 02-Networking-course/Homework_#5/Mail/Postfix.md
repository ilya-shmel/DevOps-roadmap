Tags: #linux #mail #postfix

Source: [DMosk](https://www.dmosk.ru/instruktions.php?object=mailserver-ubuntu)

Related: [[Lab number 5]], [[PostfixAdmin]] 

## 1. Pre-Configure

### 1.1. Update the system.

### 1.2. Set the appropriate name for our mail-server

```bash
ilya@mailserver02:~$ hostnamectl set-hostname relay.epam.tr.local
```

### 1.3. Install the packet for the time synchronization and the timezone

```bash
ilya@mailserver02:~$ sudo apt install chrony

ilya@mailserver02:~$ timedatectl set-timezone Europe/Moscow 
```

Allow the chrony
```bash
ilya@mailserver02:~$ sudo systemctl enable chrony
Synchronizing state of chrony.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable chrony
```

### 1.4. Configure the firewall
To open ports
```bash
ilya@mailserver02:~$ sudo iptables -I INPUT 1 -p tcp --match multiport --dports 25,110,143,465,587,993,995 -j ACCEPT
```
There
-   **25** — standard SMTP via STARTTLS;
-   **110** — standard POP3 via STARTTLS;
-   **143** — standard IMAP via STARTTLS;
-   **465** — protected SMTP via SSL/TLS;
-   **587** — protected SMTP via STARTTLS;
-   **993** — protected IMAP via SSL/TLS;
-   **995** — protected POP3 via SSL/TLS.
-   **80** — HTTP for sites Postfixadmin and Roundcube;
-   **443** — protected HTTPS for sites Postfixadmin и Roundcube;

To save rules we are going to install the packet and save current rules
```bash
ilya@mailserver02:~$ sudo apt install iptables-persistent

ilya@mailserver02:~$ sudo netfilter-persistent save
```

## 2. Configure the web-server
[[Nginx]]

## 3. Install the PostfixAdmin

[[PostfixAdmin]] 

## 4. Install and configure Postfix 
### 4.1. Install packages
```bash
ilya@relay:~$ sudo apt install postfix postfix-mysql
```
We should leave `Internet Site` in the configuration menu.

### 4.2. Add an account for working with a catalog of virtual mailboxes 
```bash
ilya@relay:~$ sudo groupadd -g 1024 vmail
ilya@relay:~$ sudo useradd -d /home/mail -g 1024 -u 1024 vmail -m
ilya@relay:~$ sudo chown vmail:vmail /home/mail
```
First `vmail` and `1024` - group and guid
Second `vmail` and `1024` - user and uid with home directory  `/home/mail` where we'll store the mail.

We should check the usage of guid and uid in current system.  

### 4.3. Edit the Config of mailserver 
```bash
ilya@relay:~$ sudo vi /etc/postfix/main.cf


smtpd_tls_cert_file=/etc/ssl/mail/public.pem
smtpd_tls_key_file=/etc/ssl/mail/private.key
inet_protocols = ipv4
=========================================
Add to the end of file
=========================================
virtual_mailbox_base = /home/mail  
virtual_alias_maps = proxy:mysql:/etc/postfix/mysql_virtual_alias_maps.cf  
virtual_mailbox_domains = proxy:mysql:/etc/postfix/mysql_virtual_domains_maps.cf  
virtual_mailbox_maps = proxy:mysql:/etc/postfix/mysql_virtual_mailbox_maps.cf  
virtual_minimum_uid = 1024  
virtual_uid_maps = static:1024  
virtual_gid_maps = static:1024  
virtual_transport = dovecot  
dovecot_destination_recipient_limit = 1  
  
smtpd_sasl_auth_enable = yes  
smtpd_sasl_exceptions_networks = $mynetworks  
smtpd_sasl_security_options = noanonymous  
broken_sasl_auth_clients = yes  
smtpd_sasl_type = dovecot  
smtpd_sasl_path = private/auth  
  
smtp_use_tls = yes  
smtpd_use_tls = yes  
smtpd_tls_auth_only = yes  
smtpd_helo_required = yes
```

-   _**mydestination** — domains that we use for incoming mail
-   _**inet_protocols** — all or apv4 or ipv6_
-   _**smtpd_tls_cert_file** — a fullpath to the public certificate._
-   _**smtpd_tls_key_file** — a fullpath to the private certificate._
- -   _**virtual_mailbox_base** — a base path of the mailboxes storage in UNIX._
-   _**virtual_alias_maps** — the format and the path to the aliases of virtual users._
-   _**virtual_mailbox_domains** — the format and the path to storage of domains for virtual users._
-   _**virtual_mailbox_maps** — the format and the path to storage of mailboxes of virtual users._
-   _**virtual_minimum_uid** — the starting number of users' id._
-   _**virtual_uid_maps** — user id which declare a user who writes messages._
-   _**virtual_gid_maps** — group id which declare a group that writes messages._
-   _**virtual_transport** — sets a transporter for messages._
-   _**dovecot_destination_recipient_limit** — transmitting messages from Postfix to Dovecot executes by quantity set (in our e.g.  - 1 item)._
-   _**smtpd_sasl_auth_enable** — allows sasl authentication._
-   _**smtpd_sasl_exceptions_networks** — an exception of networks which uses encryption ._
-   _**smtpd_sasl_security_options** — additional options for configuring sasl._
-   _**broken_sasl_auth_clients** — that option fo MS Outlook's clients._
-   _**smtpd_sasl_type** — specify the type of the authentication._
-   _**smtpd_sasl_path** — the path to temporary files of exchange with Dovecot. We use the absolute path or the relative path queue_directory (/var/spool/postfix by default). The fullpath is /var/spool/postfix/private/auth._
-   _**smtp_use_tls** — use the encrypted connection to other SMTP server during sending the message, if it can be._
-   _**smtpd_use_tls** — the pointer for users that's signalling about TLS support._
-   _**smtpd_tls_auth_only** — use only TLS._
-   _**smtpd_helo_required** — the requirement of starting the session with greets._

### 4.4. Create some files

File with options for addressing to aliases' DB
```bash
ilya@relay:~$ sudo vi /etc/postfix/mysql_virtual_alias_maps.cf

user = postfix
password = 123
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%u'
```
_ **user** and **password** — MySQL login and password; **hosts** — DB server name (in our case - localhost); **dbname** — DB name; **query** — pattern for a permission to the data_

Create instruction file for getting the virtual domains' data
```bash
ilya@relay:~$ sudo vi /etc/postfix/mysql_virtual_domains_maps.cf

user = postfix
password = 123
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%u'
```

Create mailboxes file
```bash
ilya@relay:~$ sudo vi /etc/postfix/mysql_virtual_mailbox_maps.cf

user = postfix
password = 123
hosts = localhost
dbname = postfix
query = SELECT CONCAT(domain,'/',maildir) FROM mailbox WHERE username='%s' AND active = '1'
```

### 4.5. Edit file `master.cf`

Add to EOF
```bash
ilya@relay:~$ vi /etc/postfix/master.cf

#=====================================================================
submission   inet  n  -  n  -  -  smtpd
  -o smtpd_tls_security_level=may
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=/var/spool/postfix/private/auth
  -o smtpd_sasl_security_options=noanonymous
  -o smtpd_sasl_local_domain=$myhostname

smtps   inet  n  -  n  -  -  smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject

dovecot   unix  -  n  n  -  -  pipe
  flags=DRhu user=vmail:vmail argv=/usr/lib/dovecot/deliver -d ${recipient}

```
See the dmosk link or the documentation for comments.

### 4.6. Generates security certificates
```bash
ilya@relay:~$ sudo mkdir -p /etc/ssl/mail

ilya@relay:~$ sudo openssl req -new -x509 -days 1461 -nodes -out /etc/ssl/mail/public.pem -keyout /etc/ssl/mail/private.key -subj "/C=RU/ST=SPb/L=SPb/O=Global Security/OU=IT Department/CN=relay.epam.tr.local"
```
Certificate expires after `1461` days. Keys  `subj` could be randomize, but `CN` have to contain our mailserver name. 

Enable and restart Postfix
```bash
ilya@relay:~$ sudo systemctl enable postfix
ilya@relay:~$ sudo systemctl restart postfix
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