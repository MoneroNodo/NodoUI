#!/bin/bash

sudo apt-get update

sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools build-essential libqt5virtualkeyboard5-dev qtdeclarative5-dev qml-module-qtquick-controls2 qml-module-qtquick-controls qml-module-qtwebkit libpugixml-dev libcurlpp-dev libcurl4-gnutls-dev qml-module-qtwebview libqt5quickcontrols2-5 qtquickcontrols2-5-dev '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev python3-pyqt5 libqt5svg5-dev qtbase5-private-dev   qml-module-qt-labs-folderlistmodel qml-module-qtquick-shapes sddm x11-xserver-utils  qml-module-qtwebengine qml-module-qtquick-virtualkeyboard qtvirtualkeyboard-plugin qml-module-qtquick2 qtvirtualkeyboard5-examples

sudo mkdir -p /opt/nodo
sudo mkdir -p /opt/nodo/i18n
sudo mkdir -p /etc/sddm.conf.d
sudo mkdir -p /usr/share/xsessions

sudo cp config/autologin.conf /etc/sddm.conf.d
sudo cp config/embeddedui.desktop /usr/share/xsessions

qmake
make

sudo cp NodoUI /opt/nodo
sudo cp config/NodoUI.sh /opt/nodo
sudo cp config/embedded.config.json /home/nodo/variables

sudo cp i18n/*.qm /opt/nodo/i18n

sudo chmod a+x /opt/nodo/NodoUI
sudo chmod a+x /opt/nodo/NodoUI.sh

sudo chown nodo:nodo /home/nodo/variables/embedded.config.json

