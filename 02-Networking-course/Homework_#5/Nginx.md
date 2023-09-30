
Tags: #nginx 

Related: [[Postfix]], [[Lab number 5]]

Source:  [DMosk](https://www.dmosk.ru/instruktions.php?object=mailserver-ubuntu)

## 1. Install nginx
```bash
sudo apt install nginx
```

```bash
ilya@mailserver02:~$ sudo systemctl enable nginx 
Synchronizing state of nginx.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable nginx
```

Then checking the result

![[Pasted image 20220622181456.png]]

## 2. PHP + PHP-FPM + nginx
Install php and php-fpm
```bash
ilya@mailserver02:~$ sudo apt install php php-fpm
```

Configure the nginx

```bash
ilya@mailserver02:~$ sudo vi /etc/nginx/sites-enabled/default
```

```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location ~ \.php$ {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                set $root_path /var/www/html;
                fastcgi_pass unix:/run/php/php8.1-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $root_path$fastcgi_script_name;
                include fastcgi_params;
                fastcgi_param DOCUMENT_ROOT $root_path;
                try_files $uri $uri/ =404;
        }
}

```

There **/var/www/html** is the default directory for nginx data.

**run/php/php7.4-fpm.sock** is the path to the socket file php-fpm with current version.
```bash
ilya@mailserver02:~$ php --version
PHP 8.1.2 (cli) (built: Jun 13 2022 13:52:54) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.1.2, Copyright (c), by Zend Technologies
```
Allow the autorun for php-fpm
```bash
ilya@mailserver02:/run/php$ sudo systemctl enable php8.1-fpm
Synchronizing state of php8.1-fpm.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable php8.1-fpm
```
And restart the nginx
```bash
ilya@mailserver02:/run/php$ sudo systemctl restart nginx
```
For sure we create an index file in the site's directory

```bash
ilya@mailserver02:/run/php$ sudo vi /var/www/html/index.php

<?php phpinfo(); ?>
```

Then checking:

![[Pasted image 20220622183916.png]]

## 3. MariaDB
Install DB server
```bash
ilya@mailserver02:/run/php$ sudo apt install mariadb-server

ilya@mailserver02:/run/php$ sudo systemctl enable mariadb
sudo: unable to resolve host relay.epam.tr.local: Name or service not known
Synchronizing state of mariadb.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable mariadb

```

Set the password for sql root
```bash
ilya@mailserver02:/run/php$ sudo mysqladmin -u root password
New password: 123
Confirm new password: 123

```

```bash

```