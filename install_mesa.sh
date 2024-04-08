#!/bin/bash

sudo apt install -y build-essential meson git python3-mako libexpat1-dev bison flex libwayland-egl-backend-dev libxext-dev libxfixes-dev libxcb-glx0-dev libxcb-shm0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxshmfence-dev libxxf86vm-dev libxrandr-dev libdrm-dev libunwind-dev cmake

sudo apt-get -y build-dep mesa

git clone https://github.com/MoneroNodo/mesa.git

cd mesa
mkdir build
cd build

CFLAGS="-O3" meson -Dgallium-drivers=panfrost,swrast -Dvulkan-drivers= -Dllvm=disabled  -Dbuildtype=release --prefix=/opt/panfrost

ninja -j8

sudo ninja install

echo /opt/panfrost/lib/aarch64-linux-gnu | sudo tee /etc/ld.so.conf.d/0-panfrost.conf
sudo ldconfig
