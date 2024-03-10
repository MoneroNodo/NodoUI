#!/bin/bash

source set_nodo_install_var.sh

sudo apt-get update

sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools build-essential libqt5virtualkeyboard5-dev qtdeclarative5-dev qml-module-qtquick-controls2 qml-module-qtquick-controls qml-module-qtwebkit libpugixml-dev libcurlpp-dev libcurl4-gnutls-dev qml-module-qtwebview libqt5quickcontrols2-5 qtquickcontrols2-5-dev '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev python3-pyqt5 libqt5svg5-dev qtbase5-private-dev   qml-module-qt-labs-folderlistmodel qml-module-qtquick-shapes sddm x11-xserver-utils  qml-module-qtwebengine qml-module-qtquick-virtualkeyboard qtvirtualkeyboard-plugin qml-module-qtquick2 qtvirtualkeyboard5-examples qttools5-dev-tools

#create folders if they don't exist
if [ ! -d $NODO_APP_PATH ]; then
    sudo mkdir -p $NODO_APP_PATH
    sudo mkdir -p $NODO_I18N_PATH
fi

if [ ! -d $NODO_SDDM_PATH ]; then
    sudo mkdir -p $NODO_SDDM_PATH
fi

if [ ! -d $NODO_XSESSIONS_PATH ]; then
    sudo mkdir -p $NODO_XSESSIONS_PATH
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

#compile the projects
qmake
make $PARALLEL_BUILD

#copy files
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/autologin.conf $NODO_SDDM_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embeddedui.desktop $NODO_XSESSIONS_PATH

sudo cp $EMBEDDED_UI_PROJECT_PATH/build/EmbeddedUI $NODO_APP_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embeddedUI.sh $NODO_APP_PATH
sudo cp $EMBEDDED_UI_PROJECT_PATH/config/embedded.config.json $NODO_CONFIG_PATH

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

sudo chown nodo:nodo $NODO_CONFIG_PATH/embedded.config.json

sudo systemctl enable nodo-dbus.service
sudo systemctl start nodo-dbus.service
sudo systemctl set-default graphical.target

