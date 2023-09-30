#scp #ssh #epam

Source: https://losst.ru/kopirovanie-fajlov-scp

Related: [[10 DevOps/11 Linux/112 Networking/Remote Control/ssh]]

`scp` is a Secure Copy utility. 

## Syntax
```bash
$ scp options user1@host1:file user2@host2:file
```

### Options
-   **-1** - use the SSH1 protocol;
-   **-2** - use the SSH2 protocol;
-   **-B** - packet mode to send several files;
-   **-C** - compression is on;
-   **- l** - set up the speed limit in kbit/s;
-   **-o** - declare the SSH option;
-   **-p** - save the modification time;
-   **-r** - recursive copying of directories;
-   **-v** - verbose mode.

### Example 
```bash
[ilya@192 Documents]$ scp -v ilya@epamtrserver_02:~/Documents/scp-doc ilya@epamtrserver_01:~/Documents
Executing: /usr/bin/ssh -x -oClearAllForwardings=yes -t -v -l ilya -- epamtrserver_02 scp -v ~/Documents/scp-doc ilya@epamtrserver_01:~/Documents
OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 58: Applying options for *
debug1: Connecting to epamtrserver_02 [192.168.243.132] port 22.
debug1: Connection established.
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_rsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_rsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_dsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_dsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ecdsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ecdsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ed25519 type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ed25519-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_7.4
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.4
debug1: match: OpenSSH_7.4 pat OpenSSH* compat 0x04000000
debug1: Authenticating to epamtrserver_02:22 as 'ilya'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:d1NPN7AWjJq0DRHWo6h7Nb8UP6T+/psbOIwrij0ofkk
debug1: Host 'epamtrserver_02' is known and matches the ECDSA host key.
debug1: Found key in /home/ilya/.ssh/known_hosts:1
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<rsa-sha2-256,rsa-sha2-512>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug1: Next authentication method: gssapi-keyex
debug1: No valid Key exchange context
debug1: Next authentication method: gssapi-with-mic
debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: KEYRING:persistent:1000)

debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: KEYRING:persistent:1000)

debug1: Next authentication method: publickey
debug1: Trying private key: /home/ilya/.ssh/id_rsa
debug1: Trying private key: /home/ilya/.ssh/id_dsa
debug1: Trying private key: /home/ilya/.ssh/id_ecdsa
debug1: Trying private key: /home/ilya/.ssh/id_ed25519
debug1: Next authentication method: password
ilya@epamtrserver_02's password: 
debug1: Authentication succeeded (password).
Authenticated to epamtrserver_02 ([192.168.243.132]:22).
debug1: channel 0: new [client-session]
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Sending environment.
debug1: Sending env LC_PAPER = ru_RU.UTF-8
debug1: Sending env LC_MONETARY = ru_RU.UTF-8
debug1: Sending env LC_NUMERIC = ru_RU.UTF-8
debug1: Sending env XMODIFIERS = @im=ibus
debug1: Sending env LANG = en_US.UTF-8
debug1: Sending env LC_MEASUREMENT = ru_RU.UTF-8
debug1: Sending env LC_TIME = ru_RU.UTF-8
debug1: Sending command: scp -v ~/Documents/scp-doc ilya@epamtrserver_01:~/Documents
Executing: program /usr/bin/ssh host epamtrserver_01, user ilya, command scp -v -t ~/Documents
OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 58: Applying options for *
debug1: Connecting to epamtrserver_01 [192.168.0.17] port 22.
debug1: Connection established.
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_rsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_rsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_dsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_dsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ecdsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ecdsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ed25519 type -1
debug1: key_load_public: No such file or directory
debug1: identity file /home/ilya/.ssh/id_ed25519-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_7.4
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.4
debug1: match: OpenSSH_7.4 pat OpenSSH* compat 0x04000000
debug1: Authenticating to epamtrserver_01:22 as 'ilya'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: kex: curve25519-sha256 need=64 dh_need=64
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:d1NPN7AWjJq0DRHWo6h7Nb8UP6T+/psbOIwrij0ofkk
The authenticity of host 'epamtrserver_01 (192.168.0.17)' can't be established.
ECDSA key fingerprint is SHA256:d1NPN7AWjJq0DRHWo6h7Nb8UP6T+/psbOIwrij0ofkk.
ECDSA key fingerprint is MD5:37:bf:f2:9f:a9:b1:c9:cd:7d:33:c5:03:22:5f:10:07.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'epamtrserver_01,192.168.0.17' (ECDSA) to the list of known hosts.
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<rsa-sha2-256,rsa-sha2-512>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug1: Next authentication method: gssapi-keyex
debug1: No valid Key exchange context
debug1: Next authentication method: gssapi-with-mic
debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: KEYRING:persistent:1000)

debug1: Unspecified GSS failure.  Minor code may provide more information
No Kerberos credentials available (default cache: KEYRING:persistent:1000)

debug1: Next authentication method: publickey
debug1: Trying private key: /home/ilya/.ssh/id_rsa
debug1: Trying private key: /home/ilya/.ssh/id_dsa
debug1: Trying private key: /home/ilya/.ssh/id_ecdsa
debug1: Trying private key: /home/ilya/.ssh/id_ed25519
debug1: Next authentication method: password
ilya@epamtrserver_01's password: 
debug1: Authentication succeeded (password).
Authenticated to epamtrserver_01 ([192.168.0.17]:22).
debug1: channel 0: new [client-session]
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Sending environment.
debug1: Sending env LC_PAPER = ru_RU.UTF-8
debug1: Sending env LC_MONETARY = ru_RU.UTF-8
debug1: Sending env LC_NUMERIC = ru_RU.UTF-8
debug1: Sending env XMODIFIERS = @im=ibus
debug1: Sending env LANG = en_US.UTF-8
debug1: Sending env LC_MEASUREMENT = ru_RU.UTF-8
debug1: Sending env LC_TIME = ru_RU.UTF-8
debug1: Sending command: scp -v -t ~/Documents
Sending file modes: C0664 0 scp-doc
Sink: C0664 0 scp-doc
scp-doc                                                                                                                                                                                                                     100%    0     0.0KB/s   00:00    
debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
debug1: channel 0: free: client-session, nchannels 1
debug1: fd 0 clearing O_NONBLOCK
debug1: fd 1 clearing O_NONBLOCK
Transferred: sent 2344, received 2468 bytes, in 12.1 seconds
Bytes per second: sent 194.4, received 204.7
debug1: Exit status 0
debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
debug1: client_input_channel_req: channel 0 rtype eow@openssh.com reply 0
debug1: channel 0: free: client-session, nchannels 1
Connection to epamtrserver_02 closed.
Transferred: sent 2800, received 8216 bytes, in 26.4 seconds
Bytes per second: sent 106.1, received 311.2
debug1: Exit status 0

```


Check remote host files
```bash
[ilya@homepc Documents]$ ls -lh
total 0
-rw-rw-r--. 1 ilya ilya 0 апр 13 15:41 scp-doc
```


```bash

```
