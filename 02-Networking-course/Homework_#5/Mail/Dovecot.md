Tags: #networking #dovecot #mail 

Related: [[Lab number 5]], [[Postfix]], [[PostfixAdmin]]

Source: [dmosk](https://www.dmosk.ru/instruktions.php?object=mailserver-ubuntu), [habr.com](https://habr.com/ru/post/258279/)


## 1. Installation and configuring 

```bash
ilya@relay:~$ sudo apt install dovecot-imapd dovecot-pop3d dovecot-mysql
```

Configure the way of storing messages.

```bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/10-mail.conf 

mail_location = maildir:/home/mail/%d/%u/
```

`maildir` is an enhanced format of storing messages in directory `/home/mail/<mail domain>/<user login>`.

Set the listener for the authentication.
```bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/10-master.conf 

service auth {
  # ...
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }

  # Postfix smtp-auth
  unix_listener auth-userdb {
    mode = 0666
    user = vmail
    group = vmail
  }

  # Auth process is run as this user.
  #user = $default_internal_user
}

```

A listener _**/var/spool/postfix/private/auth**_ is for Postfix authorization via Dovecot. We use it when we configured Postfix.

_**auth-userdb**_ is a socket for dovecot-lda authorization.

_**mode**_ - rights to socket, `666` - everyone can connect to it

_**user** and **group**_ are the socket owners' user and group. 

And add some strings to the EOF to prevent error `error net_connect_unix(/var/run/dovecot/stats-writer) failed permission denied
```bash
service stats {  
    unix_listener stats-reader {  
        user = vmail  
        group = vmail  
        mode = 0660  
    }  
    unix_listener stats-writer {  
        user = vmail  
        group = vmail  
        mode = 0660  
    }  
}
```

## 2. Set the authentication in Dovecot
```Bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/10-auth.conf

#!include auth-system.conf.ext
!include auth-sql.conf.ext
```
We comment the default authentication and delete comment for the sql-authentication. 

## 3. Set the encryption in Dovecot

```bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/10-ssl.conf 

ssl = required

ssl_cert = </etc/ssl/mail/public.pem
ssl_key = </etc/ssl/mail/private.key
```
We use the same paths for the certificate and the key as in Postfix topic.


## 4. Set the connection
Set the auto catalog's connection during the first user's connect to the mailbox. 
```bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/15-lda.conf

lda_mailbox_autocreate = yes
```

Set the connection to the DB.
```bash
ilya@relay:~$ sudo vi /etc/dovecot/conf.d/auth-sql.conf.ext 

passdb {
  driver = sql

  # Path for SQL configuration file, see example-config/dovecot-sql.conf.ext
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
```
	Here I've used default options and haven't written anything.

Edit mysql configuration file.
```bash
ilya@relay:~$ sudo vi /etc/dovecot/dovecot-sql.conf.ext 

driver = mysql
connect = host=localhost dbname=postfix user=postfix password=123
default_pass_scheme = MD5-CRYPT
password_query = SELECT password FROM mailbox WHERE username = '%u'
user_query = SELECT maildir, 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
user_query = SELECT CONCAT('/home/mail/',LCASE(`domain`),'/',LCASE(`maildir`)), 1024 AS uid, 1024 AS gid FROM mailbox WHERE username = '%u'
```
_**password_query**_ is the password request from table `mailbox`  
_**user_query**_ is the request to access to the user's data (home mail directory, uid 1024).

## 5. Set the interface for the Dovecot listening
```bash
ilya@relay:~$ sudo vi /etc/dovecot/dovecot.conf 

listen = *
```
We delete the ipv6 protocol `::` from that string to prevent errors
``**master: Error: service(imap-login): listen(::, 143) failed: Address family not supported by protocol`  
`master: Error: service(imap-login): listen(::, 993) failed: Address family not supported by protocol**_`

## 6. Enable and restart 
```bash
ilya@relay:~$ sudo systemctl enable dovecot
ilya@relay:~$ sudo systemctl restart dovecot
```

We can create the first mailbox! Go to [[PostfixAdmin]] step 6.