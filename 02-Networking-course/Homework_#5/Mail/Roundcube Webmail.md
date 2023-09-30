

Tags: #mail #networking #php 

Related: [[Dovecot]], [[Postfix]], [[PostfixAdmin]], [[Lab number 5]], [[Nginx]]

Source: [dmosk.ru](https://www.dmosk.ru/instruktions.php?object=mailserver-ubuntu), [Roundcube.net](https://roundcube.net/download/)


## 1. Page of downloading

	https://roundcube.net/download/

We prefer LTS version.

	https://github.com/roundcube/roundcubemail/releases/download/1.5.3/roundcubemail-1.5.3-complete.tar.gz

```bash
ilya@relay:~$ wget https://github.com/roundcube/roundcubemail/releases/download/1.5.3/roundcubemail-1.5.3-complete.tar.gz
```

## 2. Install the program 

```bash
# Create the webmail directory
ilya@relay:~$ sudo mkdir /var/www/html/webmail

# Unpack the archive
ilya@relay:~$ sudo tar -C /var/www/html/webmail -xvf roundcubemail-*.tar.gz --strip-components 1

# Copy the config template
ilya@relay:~$ sudo cp /var/www/html/webmail/config/config.inc.php.sample /var/www/html/webmail/config/config.inc.php
```

## 3. Edit the config
```bash
ilya@relay:~$ sudo vi /var/www/html/webmail/config/config.inc.php

$config['db_dsnw'] = 'mysql://roundcube:123@localhost/roundcubemail';
$config['enable_installer'] = true;

$config['smtp_pass'] = '';

```
The first string we edit, the second string we add (it allows the portal's installation). The third string prevents an authorization error. 

_**roundcube:123**_ are login and password
_**localhost**_ is the DB server
_**roundcubemail**_ is a DB name

Add to the EOF 
```bash
$config['drafts_mbox'] = 'Drafts';  
$config['junk_mbox'] = 'Junk';  
$config['sent_mbox'] = 'Sent';  
$config['trash_mbox'] = 'Trash';  
$config['create_default_folders'] = true;
```
to prevent the error of deleting or other actions in the webclient.

## 4. Edit the DB
Add an owner for the portal's directory 
```bash
ilya@relay:~$ sudo chown -R www-data:www-data /var/www/html/webmail/
```

Create roundcubemail DB
```bash
ilya@relay:~$ mysql -uroot -p
MariaDB [(none)]> CREATE DATABASE roundcubemail DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY '123';
MariaDB [(none)]> quit
```

Load the data to the created DB
```bash
ilya@relay:~$ mysql -uroot -p roundcubemail < /var/www/html/webmail/SQL/mysql.initial.sql 
```

## 5. Install the additional components 
```bash
ilya@relay:~$ sudo apt -y install php-pear php-intl php-ldap php-net-smtp php-gd php-imagick php-zip php-curl
```

Add packets to compile `mcrypt` from binaries.
```bash
ilya@relay:~$ sudo apt -y install php-dev libmcrypt-dev
```

Start to compile new packets
```bash
ilya@relay:~$ sudo pecl channel-update pecl.php.net
ilya@relay:~$ sudo pecl install mcrypt-1.0.5

Build process completed successfully
Installing '/usr/lib/php/20210902/mcrypt.so'
install ok: channel://pecl.php.net/mcrypt-1.0.5
configuration option "php_ini" is not set to php.ini location
You should add "extension=mcrypt.so" to php.ini
```

Edit a file for the new module.
```bash
ilya@relay:~$ sudo vi /etc/php/8.1/fpm/conf.d/99-mcrypt.ini

extension=mcrypt.so
```

## 6. Set php options
```bash
ilya@relay:~$ sudo vi /etc/php/8.1/fpm/php.ini 

# Find and change the parameters
date.timezone = "Europe/Moscow"
...
post_max_size = 50M
...
upload_max_filesize = 50M
```

And don't forget to reload php-fpm
```bash
ilya@relay:~$ sudo systemctl restart php8.1-fpm
```

## 7. Set option for nginx
```bash
ilya@relay:~$ sudo vi /etc/nginx/nginx.conf 

# Add a string to the http block
client_max_body_size 50M; 

# Restart nginx
ilya@relay:~$ sudo systemctl restart nginx
```

```bash

```