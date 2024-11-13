#!/bin/bash

export QT_QPA_EGLFS_HIDECURSOR=1

tries=0
while true; do
	tries=$((tries + 1))
	if [ "$tries" -ge 10 ]; then
		break
	fi
	/opt/nodo/NodoUI -platform eglfs && break
done &> /home/nodo/log.txt
