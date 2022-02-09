#!/bin/sh

sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq install $(curl -fsSL git.io/depends-ubuntu-2004)
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "Asia/Shanghai"

git clone https://github.com/coolsnowwolf/lede openwrt
cd openwrt

curl https://raw.githubusercontent.com/yrmt/build_some/main/openwrt_ac2100/feeds.conf.default > feeds.conf.default
curl https://raw.githubusercontent.com/yrmt/build_some/main/openwrt_ac2100/ac2100.config > .config

./scripts/feeds update -a
./scripts/feeds install -a

make download -j8 V=s
find dl -size -1024c -exec ls -l {} \;

make -j$(nproc) || make -j1 || make -j1 V=s
