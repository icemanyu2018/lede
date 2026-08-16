#!/bin/bash

# 1. 修改默认 LAN 口 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 设置 root 默认密码为 123456789
sed -i 's/root:::0:99999:7:::/root:$1$wE47n1$yv2Kq5m7qIe3oR5v1hGjH\/:19000:0:99999:7:::/g' package/base-files/files/etc/shadow

# 3. 将默认登录 Shell 改为 zsh
sed -i 's/\/bin\/ash/\/bin\/zsh/g' package/base-files/files/etc/passwd

# 4. 设置默认时区为上海 (CST-8) 并锁定中文
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/set system.@system\[-1\].timezone='CST-8'/a \\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
sed -i 's/auto/zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 5. 设置默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 6. 自定义默认 WiFi SSID 为 ImmortalWrt-2.4G / 5G
sed -i 's/OpenWrt/ImmortalWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ImmortalWrt-2.4/ImmortalWrt-2.4G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ImmortalWrt-5.8/ImmortalWrt-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 7. 清理 feeds 中可能引发冲突的同名包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-openclash

# 8. 直接拉取所需的所有独立插件到 package 目录
rm -rf package/passwall2 package/passwall_packages package/mosdns package/v2ray-geodata package/openclash package/daed package/pushbot
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall_packages
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/vernesong/OpenClash.git package/openclash
git clone --depth 1 https://github.com/wkccd/luci-app-daed-runfiles.git package/daed
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot.git package/pushbot
