#!/bin/sh

yum install epel-release -y
yum install wget gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel -y

mkdir -p /tmp/ssr; cd /tmp/ssr

# Installation of libsodium
export LIBSODIUM_VER=1.0.16
wget https://download.libsodium.org/libsodium/releases/old/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
sudo make install
popd
sudo ldconfig

# Installation of MbedTLS
export MBEDTLS_VER=2.6.0
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS="-O2 -fPIC"
sudo make DESTDIR=/usr install
popd
sudo ldconfig

git clone https://github.com/shadowsocks/shadowsocks-libev.git
pushd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh && ./configure && make
make install
echo "ssr编译完成"


mkdir -p /etc/shadowsocks
cat > /etc/shadowsocks/ssr.json << EOF
{
        "server": "",
        "server_port": ,
        "password": "",
        "method": "aes-128-gcm",
        "plugin": "v2ray-plugin",
        "plugin_opts": "",
        "local_port": "1080"
}
EOF

echo "配置文件 /etc/shadowsocks/ssr.json"
cat /etc/shadowsocks/ssr.json
echo "启动命令: ss-local -c /etc/shadowsocks/ssr.json"
echo "编译目录在 `pwd` 下注意清理"