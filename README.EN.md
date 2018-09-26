ShadowsocksR-libev for OpenWrt
===

Introduction
---

 This project it [shadowsocksr-libev][1] make file for LEDE/OpenWrt  

Features
---

Package contains only [shadowsocksr-libev][1]

 - shadowsocksr-libev

   ```
   /
   └── usr/
       └── bin/
           ├── ssr-local       // SOCKS Proxy
           ├── ssr-redir       // Transparent proxy with UDP support
           └── ssr-tunnel      // Provide port forwarding for DNS queries
   ```

Compile
---

 - Compile with OpenWrt [SDK][S]

   ```bash
   # Taking AR71XX platform as an example
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   # Add feeds
   git clone https://github.com/paulgit/openwrt-feeds.git package/feeds
   # Get shadowsocks-libev Makefile
   git clone https://github.com/paulgit/openwrt-shadowsocksr.git package/feeds/shadowsocksr-libev
   # Select packages to compile Network -> shadowsocksr-libev (note new static link options)
   make menuconfig
   # Start compiling
   make package/shadowsocksr-libev/compile V=99
   ```

Configuration
---

   The package itself does not contain a configuration file, the configuration file format is JSON, and supports the following keys:  

   Key Name       | Data Type  | Descriptions
   ---------------|------------|-----------------------------------------------
   server         | String     | Server address, can be IP or domain name
   server_port    | Number     | Server port number, less than 65535
   local_address  | String     | Local bound IP address, default 127.0.0.1
   local_port     | Number     | Local bound port number less than 65535
   password       | String     | Server password
   method         | String     | Encryption method, [Details][E]
   timeout        | Number     | Timeout Time (seconds), default 60
   fast_open      | Boolean    | Whether [TCP-Fast-Open][F] is enabled and applies only to ssr-local
   nofile         | Number     | Setup Linux ulimit
   protocol       | String     | [Protocol Plugin][P], Recommended to use ```orgin, auth_aes128_{md5, sha1}, auth_chain_{a, b, c, d, e, f}```
   obfs           | String     | [Obsfuscation Plugin][P], Recommended to use ```plain, http_{simple, post}, tls1.2_ticket_auth```


  [1]: https://github.com/shadowsocksrr/shadowsocksr-libev/tree/Akkariiin/master
  [E]: http://shadowsocks.org/en/spec/Stream-Ciphers.html
  [F]: https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open
  [S]: https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [P]: https://github.com/shadowsocksrr/shadowsocks-rss/blob/master/ssr.md

Usage
---

 - Taking ssr-redir as an example

   ```
   # ssr-redir -h

   shadowsocks-libev 2018-03-07 with mbed TLS 2.8.0

     usage:

       ss-redir

          -s <server_host>           Host name or IP address of your remote server.
          -p <server_port>           Port number of your remote server.
          -l <local_port>            Port number of your local server.
          -k <password>              Password of your remote server.
          -m <encrypt_method>        Encrypt method: table, rc4, rc4-md5,
                                     aes-128-cfb, aes-192-cfb, aes-256-cfb,
                                     aes-128-ctr, aes-192-ctr, aes-256-ctr,
                                     bf-cfb, camellia-128-cfb, camellia-192-cfb,
                                     camellia-256-cfb, cast5-cfb, des-cfb,
                                     idea-cfb, rc2-cfb, seed-cfb, salsa20,
                                     chacha20 and chacha20-ietf.
                                     The default cipher is rc4-md5.

          -o <obfs>                  Obfs of your remote server: plain,
                                     http_simple, http_post and tls1.2_ticket_auth.
          -g <obfs-param>            Obfs-Param of your remote server.
          -O <protocol>              Protocol of your remote server: orgin,
                                     auth_sha1, auth_sha1_v2, auth_sha1_v4,
                                     auth_aes128_md5, auth_aes128_sha1,
                                     auth_chain_a, auth_chain_b, auth_chain_c,
                                     auth_chain_d, auth_chain_e and auth_chain_f.
          -G <protocol-param>        Protocol-Param of your remote server.

          [-a <user>]                Run as another user.
          [-f <pid_file>]            The file path to store pid.
          [-t <timeout>]             Socket timeout in seconds.
          [-c <config_file>]         The path to config file.
          [-n <number>]              Max number of open files.
          [-b <local_address>]       Local address to bind.

          [-u]                       Enable UDP relay.
                                     TPROXY is required in redir mode.
          [-U]                       Enable UDP relay and disable TCP relay.

          [--mtu <MTU>]              MTU of your network interface.
          [--mptcp]                  Enable Multipath TCP on MPTCP Kernel.

          [-v]                       Verbose mode.
          [-h, --help]               Print this message.

   ```

Exclude Error
---
   Error Message: ```error: MBEDTLS_CAMELLIA_C required```  
   Solution: ```rm -rf package/libs/mbedtls```
