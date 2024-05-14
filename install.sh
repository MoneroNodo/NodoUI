#!/bin/bash

source set_nodo_install_var.sh

sudo apt-get update

sudo bash -e ./install_mesa.sh

sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools build-essential libqt5virtualkeyboard5-dev qtdeclarative5-dev qml-module-qtquick-controls2 qml-module-qtquick-controls qml-module-qtwebkit libpugixml-dev libcurlpp-dev libcurl4-gnutls-dev qml-module-qtwebview libqt5quickcontrols2-5 qtquickcontrols2-5-dev libglu1-mesa-dev python3-pyqt5 libqt5svg5-dev qtbase5-private-dev qml-module-qt-labs-folderlistmodel qml-module-qtquick-shapes qml-module-qtwebengine qml-module-qtquick-virtualkeyboard qtvirtualkeyboard-plugin qml-module-qtquick2 qttools5-dev-tools

#create folders if they don't exist
if [ ! -d $NODO_APP_PATH ]; then
    sudo mkdir -p $NODO_APP_PATH
    sudo mkdir -p $NODO_I18N_PATH
fi

if [ ! -d $NODO_CONFIG_PATH ]; then
    sudo mkdir -p $NODO_CONFIG_PATH
fi

#remove old executables
if [ -e /opt/nodo/NodoUI ]; then
    rm /opt/nodo/NodoUI
fi

if [ -e /opt/nodo/NodoUI.sh ]; then
    rm /opt/nodo/NodoUI.sh
fi

if [ -e /usr/bin/NodoUI ]; then
    rm /usr/bin/NodoUI
fi

if [ -e /usr/bin/NodoUI.sh ]; then
    rm /usr/bin/NodoUI.sh
fi

#git clone https://github.com/toby20130333/qtquickqrencode.git  qtquickqrencode
#cd qtquickqrencode
#qmake "CONFIG-=qml_debug" "CONFIG+=qtquickcompiler" "CONFIG-=separate_debug_info"
#make $PARALLEL_BUILD
#sudo make install
#cd ..

#compile the projects
qmake "CONFIG-=qml_debug" "CONFIG+=qtquickcompiler" "CONFIG-=separate_debug_info"
make $PARALLEL_BUILD

sudo systemctl stop nodo-dbus
sudo systemctl stop embeddedUI

#copy files
sudo cp $EMBEDDED_UI_PROJECT_PATH/build/EmbeddedUI $NODO_APP_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embeddedUI.sh $NODO_APP_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embedded.config.json $NODO_CONFIG_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embeddedUI.service /usr/lib/systemd/system/

sudo cp $NODO_DAEMON_PROJECT_PATH/build/NodoDaemon $NODO_APP_PATH
sudo cp $NODO_DAEMON_PROJECT_PATH/config/com.monero.nodo.conf /usr/share/dbus-1/system.d/
sudo cp $NODO_DAEMON_PROJECT_PATH/config/com.monero.nodo.service /usr/share/dbus-1/system-services/
sudo cp $NODO_DAEMON_PROJECT_PATH/config/nodo-dbus.service /usr/lib/systemd/system/

lupdate $EMBEDDED_UI_PROJECT_PATH/EmbeddedUI.pro
lrelease $EMBEDDED_UI_PROJECT_PATH/EmbeddedUI.pro

sudo cp $EMBEDDED_UI_PROJECT_PATH/i18n/*.qm $NODO_I18N_PATH

#permissions etc.
sudo chmod a+x $NODO_APP_PATH/EmbeddedUI
sudo chmod a+x $NODO_APP_PATH/embeddedUI.sh

sudo cp -a $EMBEDDED_UI_PROJECT_PATH/build/NodoCanvas /opt/nodo
sudo cp -a $EMBEDDED_UI_PROJECT_PATH/build/QtQuick2QREncode /opt/nodo

sudo chown nodo:nodo $NODO_CONFIG_PATH/embedded.config.json

sudo usermod -aG video monero
sudo usermod -aG input monero

sudo systemctl enable nodo-dbus.service
sudo systemctl start nodo-dbus.service

sudo systemctl enable embeddedUI.service
sudo systemctl start embeddedUI.service

sudo systemctl set-default graphical.target

