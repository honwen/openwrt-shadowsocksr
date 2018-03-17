ShadowsocksR-libev for OpenWrt
===

简介
---

 本项目是 [shadowsocksr-libev][1] 在 OpenWrt 上的移植  

特性
---

软件包只包含 [shadowsocksr-libev][1] 的可执行文件, 可与 [luci-app-shadowsocksr][3] 搭配使用  
可编译两种版本  

 - shadowsocksr-libev

   ```
   客户端/
   └── usr/
       └── bin/
           ├── ssr-redir       // 提供透明代理, 从 v2.2.0 开始支持 UDP
   ```

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译

   ```bash
   # 以 ar71xx 平台为例
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   # 添加 feeds
   git clone https://github.com/shadowsocks/openwrt-feeds.git package/feeds
   # 获取 shadowsocks-libev Makefile
   git clone https://github.com/chenhw2/openwrt-shadowsocksr.git package/feeds/shadowsocksr-libev
   # 选择要编译的包 Network -> shadowsocks-libev
   make menuconfig
   # 开始编译
   make package/shadowsocksr-libev/compile V=99
   ```

配置
---

   软件包本身并不包含配置文件, 配置文件内容为 JSON 格式, 支持的键:  

   键名           | 数据类型   | 说明
   ---------------|------------|-----------------------------------------------
   server         | 字符串     | 服务器地址, 可以是 IP 或者域名
   server_port    | 数值       | 服务器端口号, 小于 65535
   local_address  | 字符串     | 本地绑定的 IP 地址, 默认 127.0.0.1
   local_port     | 数值       | 本地绑定的端口号, 小于 65535
   password       | 字符串     | 服务端设置的密码
   method         | 字符串     | 加密方式, [详情参考][E]
   timeout        | 数值       | 超时时间（秒）, 默认 60
   fast_open      | 布尔值     | 是否启用 [TCP-Fast-Open][F], 只适用于 ssr-local
   nofile         | 数值       | 设置 Linux ulimit
   protocol       | 字符串     | [协议插件][P], 推荐使用 ```orgin, auth_aes128_{md5, sha1}, auth_chain_{a, b, c, d, e, f}```
   obfs           | 字符串     | [混淆插件][P], 推荐使用 ```plain, http_{simple, post}, tls1.2_ticket_auth```


  [1]: https://github.com/shadowsocksrr/shadowsocksr-libev/tree/Akkariiin/master
  [3]: https://github.com/chenhw2/luci-app-shadowsocksr
  [E]: http://shadowsocks.org/en/spec/Stream-Ciphers.html
  [F]: https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open
  [S]: https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [P]: https://github.com/shadowsocksrr/shadowsocks-rss/blob/master/ssr.md

用法
---

 - 以 ssr-redir 为例

   ```
   # ssr-redir -h
   
   shadowsocks-libev 2018-01-20 with mbed TLS 2.6.0
   
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

错误排除
---
   错误字样: ```error: MBEDTLS_CAMELLIA_C required```  
   解决方案: ```rm -rf package/libs/mbedtls```
