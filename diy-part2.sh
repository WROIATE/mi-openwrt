#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate
pushd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config
popd

# Add luci-app-ustb
git clone https://github.com/WROIATE/luci-app-ustb

pushd package/lean/default-settings/files
sed -i "/commit luci/i\uci set luci.main.mediaurlbase='/luci-static/argon'" zzz-default-settings
sed -i "/uci commit system/a\uci set dhcp.@dnsmasq[0].filter_aaaa='0'" zzz-default-settings
sed -i "/dhcp.@dnsmasq/a\uci commit dhcp" zzz-default-settings
sed -i "/-j REDIRECT --to-ports 53/d" zzz-default-settings
sed -i "/REDIRECT --to-ports 53/a\echo '# iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user" zzz-default-settings
sed -i "/exit 0/i\uci set network.globals.ula_prefix='dead:2333:6666::/48'" zzz-default-settings
sed -i "/exit 0/i\uci commit network" zzz-default-settings
popd
