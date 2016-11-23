#
# Copyright (C) 2016 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2.5.6
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/breakwa11/shadowsocks-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=d022e3177c4bbcd3a13dbb41aa3c2a7dbf50a672
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Max Lv <max.c.lv@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy $(2)
	URL:=https://github.com/shadowsocksr/shadowsocksr-libev
	VARIANT:=$(1)
	DEPENDS:=$(3) +libpcre +libpthread
endef

Package/shadowsocksr-libev = $(call Package/shadowsocksr-libev/Default,openssl,(OpenSSL),+libopenssl +zlib)
Package/shadowsocksr-libev-server = $(Package/shadowsocksr-libev)
Package/shadowsocksr-libev-mbedtls = $(call Package/shadowsocksr-libev/Default,mbedtls,(mbedTLS),+libmbedtls)
Package/shadowsocksr-libev-server-mbedtls = $(Package/shadowsocksr-libev-mbedtls)
Package/shadowsocksr-libev-polarssl = $(call Package/shadowsocksr-libev/Default,polarssl,(PolarSSL),+libpolarssl)
Package/shadowsocksr-libev-server-polarssl = $(Package/shadowsocksr-libev-polarssl)

define Package/shadowsocksr-libev/description
shadowsocksr-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-server/description = $(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-mbedtls/description = $(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server-mbedtls/description = $(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-polarssl/description = $(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server-polarssl/description = $(Package/shadowsocksr-libev/description)

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local  $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir  $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
endef

Package/shadowsocksr-libev-mbedtls/install = $(Package/shadowsocksr-libev/install)
Package/shadowsocksr-libev-polarssl/install = $(Package/shadowsocksr-libev/install)

define Package/shadowsocksr-libev-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin
endef

Package/shadowsocksr-libev-server-mbedtls/install = $(Package/shadowsocksr-libev-server/install)
Package/shadowsocksr-libev-server-polarssl/install = $(Package/shadowsocksr-libev-server/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-server))
$(eval $(call BuildPackage,shadowsocksr-libev-mbedtls))
$(eval $(call BuildPackage,shadowsocksr-libev-server-mbedtls))
$(eval $(call BuildPackage,shadowsocksr-libev-polarssl))
$(eval $(call BuildPackage,shadowsocksr-libev-server-polarssl))
