# Lab number 5
Tags: #EPAM #networking 

Related: [[Postfix]], [[Nginx]]


## Participants

1. EPAMTrServer_03 Ubuntu 20.04 (ens34 - 192.168.0.16, ens33 - 192.168.98.1) - DNS, NAT and firewall.
2. MailServer_02 Ubuntu 22.04 () - mailserver (Postfix).

## Plan

1. Install Mail Server: [[Postfix]], [[Dovecot]], [[Roundcube Webmail]]
2. Install nginx web-server: [[Nginx]]
3. Install HashiCorp Vault: [[HashiCorp Vault]] 
4. Install the external machine
5. Configure IPtables on the DNS server to allow requests from external machine
6. Check all connections.