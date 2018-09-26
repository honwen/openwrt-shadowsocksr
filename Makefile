# OpenWRT/LEDE Makefile of https://github.com/shadowsocksrr/shadowsocksr-libev

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2018-03-07
PKG_RELEASE:=d63ff863800a5645aca4309d5dd5962bd1e95543

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocksrr/shadowsocksr-libev.git
PKG_SOURCE_VERSION:=$(PKG_RELEASE)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=chenhw2 <https://github.com/chenhw2>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=libmbedltls libpcre

PKG_CONFIG_DEPENDS:= \
	CONFIG_SHADOWSOCKSR_STATIC_LINK \
	CONFIG_SHADOWSOCKSR_WITH_PCRE \
	CONFIG_SHADOWSOCKSR_WITH_MBEDTLS

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy
	URL:=https://github.com/shadowsocksrr/shadowsocksr-libev
	DEPENDS:=+zlib +libpthread \
		+!SHADOWSOCKSR_WITH_PCRE:libpcre \
		+!SHADOWSOCKSR_WITH_MBEDTLS:libmbedtls
endef

Package/shadowsocksr-libev = $(call Package/shadowsocksr-libev/Default)

define Package/shadowsocksr-libev/config
menu "Shadowsocksr-libev Compile Configuration"
	depends on PACKAGE_shadowsocksr-libev
	config SHADOWSOCKSR_STATIC_LINK
		bool "enable static link libraries."
		default n

		menu "Select libraries"
			depends on SHADOWSOCKSR_STATIC_LINK
			config SHADOWSOCKSR_WITH_PCRE
				bool "static link libpcre."
				default y
			config SHADOWSOCKSR_WITH_MBEDTLS
				bool "static link libmbedtls."
				default y
		endmenu
endmenu
endef

define Package/shadowsocksr-libev/description
shadowsocksr-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert --with-crypto-library=mbedtls

ifeq ($(CONFIG_SHADOWSOCKSR_STATIC_LINK),y)
	ifeq ($(CONFIG_SHADOWSOCKSR_WITH_PCRE),y)
		CONFIGURE_ARGS += --with-pcre="$(STAGING_DIR)/usr"
	endif
	ifeq ($(CONFIG_SHADOWSOCKSR_WITH_MBEDTLS),y)
		CONFIGURE_ARGS += --with-mbedtls="$(STAGING_DIR)/usr"
	endif
	CONFIGURE_ARGS += LDFLAGS="-Wl,-static -static -static-libgcc"
endif
define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(LN) ssr-local $(1)/usr/bin/ssr-tunnel
endef

$(eval $(call BuildPackage,shadowsocksr-libev))
