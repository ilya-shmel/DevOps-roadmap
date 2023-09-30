Tags: #postfix 

Related: [[Postfix]], [[Lab number 5]]

Source: [dmosk](https://www.dmosk.ru/instruktions.php?object=mailserver-ubuntu), [MariaDB](https://mariadb.com/kb/ru/a-mariadb-primer/)

## 1. Install the additional php components

```bash
ilya@relay:~$ sudo apt install php-mysql php-mbstring php-imap

ilya@relay:~$ systemctl restart php8.1-fpm
```

## 2. Work with PostfixAdmin

Download the package
```bash
wget https://sourceforge.net/projects/postfixadmin/files/latest/download -O postfixadmin.tar.gz
```

Create the PostfixAdmin's directory in the nginx folder and extract the archive into that
```bash
ilya@relay:/var/www/html$ sudo mkdir postfixadmin

tar -C /var/www/html/postfixadmin -xvf postfixadmin.tar.gz --strip-components 1
```

Create a directory for templates to prevent the error **he templates_c directory doesn't exist or isn't writeable for the webserver** and set the permissions for postfixadmin directory
```bash
ilya@relay:/var/www/html/postfixadmin$ sudo mkdir templates_c

ilya@relay:/var/www/html/postfixadmin$ sudo chown -R www-data:www-data /var/www/html/postfixadmin
```

www-data is the default user for php-fpm running

Create Postfix database and MariaDB account
```bash
ilya@relay:/var/www/html$ mysql -u root -p

MariaDB [(none)]> CREATE DATABASE postfix DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
```
there **postfix** is a nema of DB
```bash
MariaDB [(none)]> GRANT ALL ON postfix.* TO 'postfix'@'localhost' IDENTIFIED BY '123';

\q
```
there **postfix** is an account name, **123** is a password and **localhost** allow connections only from the local server. 

## 3. The config file

Create the config file for postfixadmin
```bash
vi /var/www/html/postfixadmin/config.local.php
```

Add next strings
```bash
<?php  
  
$CONF['configured'] = true;  
$CONF['default_language'] = 'ru';  
$CONF['database_password'] = '123';  
$CONF['emailcheck_resolve_domain']='NO';  
  
?>
```
`configured` - Admin has ended the configuration
`database_password` - the database password that we set in previous step
`emailcheck_resolve_domain` - need to check a Domain while mailboxes and names are creating

Open the site `http://192.168.0.10/postfixadmin/public/setup.php`.

Set the setup password and generate hash.

The setuo password is `abc12`.

We need to copy this hash to the configuration file.
`$CONF['setup_password'] = '$2y$10$KTPpTVX0FR08fJFIPUN7VukddGwukZnEXTV5Z6X0tEQQKGRL2rAJG';`

![[Pasted image 20220824160301.png]]

```bash
sudo vi /var/www/html/postfixadmin/config.local.php

<?php

$CONF['configured'] = true;
$CONF['default_language'] = 'ru';
$CONF['database_password'] = '123';
$CONF['emailcheck_resolve_domain']='NO';
$CONF['setup_password'] = '$2y$10$KTPpTVX0FR08fJFIPUN7VukddGwukZnEXTV5Z6X0tEQQKGRL2rAJG';
?>
~          
```

Refresh the site and see the new form of login with setup password.

It installs the postfixadmin.

Add a superuser.

![[Pasted image 20220824161236.png]]
![[Pasted image 20220824161411.png]]

A password for root is `abc12`.

PostfixAdmin has been installed successfully.

## 4. Check the result

We should go to site `http://192.168.0.10/postfixadmin/public/login.php`.

![[Pasted image 20220824163636.png]]

## 5. Create a user

Connect to DB and select `postfix` database
```bash
ilya@relay:~$ mysql -uroot -p
MariaDB [(none)]> use postfix

```

Add administrator via request
```bash
MariaDB [postfix]> INSERT INTO admin (`username`, `password`, `superadmin`, `active`) VALUES ('root@epam.tr.local', '$2y$10$KTPpTVX0FR08fJFIPUN7VukddGwukZnEXTV5Z6X0tEQQKGRL2rAJG', '1', '1');

MariaDB [postfix]>quit
```
![[Pasted image 20220824170216.png]]
Add a New Admin `ilya@epam.tr.local` with same password.

We could delete the `root` admin.

Now go to step 4 [[Postfix]].

## 6. How to create mailbox

http://<server's IP address>/postfixadmin/public/.
![[Pasted image 20220826100713.png]]
![[Pasted image 20220826100720.png]]
![[Pasted image 20220826100728.png]]
![[Pasted image 20220826100733.png]]

Connection parameters:
-   **Сервер**: server name or IP address (bad way, because certificate has only domain name).
-   **IMAP**: 143 STARTTLS or 993 SSL/TLS
-   **POP3**: 110 STARTTLS or 995 SSL/TLS
-   **SMTP**: 25 STARTTLS or 465 SSL/TLS or 587 STARTTLS

```bash

```

```bash

```

relay.epam.tr.local
