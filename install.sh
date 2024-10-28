#!/bin/bash

source set_nodo_install_var.sh

sudo apt-get update

sudo apt-get install -y libglu1-mesa-dev qt6-base-dev libqt6qml6 libqt6qmlcompiler6 libqt6qmlcore6 libqt6quick6 libqt6quickcontrols2-6 qt6-declarative-dev qml6-module-qtquick-virtualkeyboard libqt6virtualkeyboard6 qt6-virtualkeyboard-dev qt6-virtualkeyboard-plugin libcurlpp-dev libcurl4-gnutls-dev qt6-l10n-tools qt6-tools-dev-tools qml6-module-qtquick-controls qml6-module-qtquick qml6-module-qtquick-dialogs qml6-module-qtquick-layouts qml6-module-qtquick-shapes qml6-module-qtquick-window qml6-module-qtqml-workerscript qml6-module-qtquick-templates qml6-module-qtwebengine qml6-module-qt-labs-folderlistmodel qt6-svg-dev- policykit-1 pkexec libpolkit-agent-1-0 xfsprogs qml6-module-qtwebview qt6-webview-plugins libpam0g-dev


#create folders if they don't exist
if [ ! -d $NODO_APP_PATH ]; then
    sudo mkdir -p $NODO_APP_PATH
    sudo mkdir -p $NODO_I18N_PATH
fi

if [ ! -d $NODO_CONFIG_PATH ]; then
    sudo mkdir -p $NODO_CONFIG_PATH
fi

#compile the projects
qmake6 "CONFIG-=qml_debug" "CONFIG+=qtquickcompiler" "CONFIG-=separate_debug_info"
make $PARALLEL_BUILD

if systemctl is-active --quiet nodo-dbus.service; then
    sudo systemctl stop nodo-dbus.service
fi

if systemctl is-active --quiet nodoUI.service; then
    sudo systemctl stop nodoUI.service
fi

if systemctl is-active --quiet nodonm-dbus; then
    sudo systemctl stop nodonm-dbus
fi


#copy files
sudo cp $NODO_UI_PROJECT_PATH/build/NodoUI $NODO_APP_PATH
sudo cp $NODO_UI_PROJECT_PATH/config/nodoUI.sh $NODO_APP_PATH
sudo cp $NODO_UI_PROJECT_PATH/config/nodoUI.feeds.json $NODO_CONFIG_PATH
sudo cp $NODO_UI_PROJECT_PATH/config/nodoUI.service /usr/lib/systemd/system/


sudo cp $NODO_DAEMON_PROJECT_PATH/build/NodoDaemon $NODO_APP_PATH
sudo cp $NODO_DAEMON_PROJECT_PATH/config/com.monero.nodo.conf /usr/share/dbus-1/system.d/
sudo cp $NODO_DAEMON_PROJECT_PATH/config/com.monero.nodo.service /usr/share/dbus-1/system-services/
sudo cp $NODO_DAEMON_PROJECT_PATH/config/nodo-dbus.service /usr/lib/systemd/system/
sudo cp $NODO_DAEMON_PROJECT_PATH/config/logind.conf /etc/systemd/

/usr/lib/qt6/bin/lupdate $NODO_UI_PROJECT_PATH/NodoUI.pro
/usr/lib/qt6/bin/lrelease $NODO_UI_PROJECT_PATH/NodoUI.pro

sudo cp $NODO_UI_PROJECT_PATH/i18n/*.qm $NODO_I18N_PATH

#permissions etc.
sudo chmod a+x $NODO_APP_PATH/nodoUI.sh

sudo cp -a $NODO_UI_PROJECT_PATH/build/NodoCanvas /opt/nodo
sudo cp -a $NODO_UI_PROJECT_PATH/build/QtQuick2QREncode /opt/nodo

sudo chown nodo:nodo $NODO_CONFIG_PATH/nodoUI.feeds.json

sudo usermod -aG video nodo
sudo usermod -aG input nodo

sudo usermod -aG adm nodo
sudo mkdir -p /etc/polkit-1/localauthority/50-local.d
sudo cp $NODO_UI_PROJECT_PATH/config/nm.pkla /etc/polkit-1/localauthority/50-local.d

sudo systemctl enable nodo-dbus.service
sudo systemctl start nodo-dbus.service

sudo systemctl enable nodoUI.service
sudo systemctl start nodoUI.service

sudo systemctl set-default graphical.target

