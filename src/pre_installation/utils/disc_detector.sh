#!/bin/bash

echo ""
echo "Detectando Dispositivos de almacenamiento...."
sleep 1
echo "Dispositivos de almacenamiento detectados:"
echo "------------------------------------------"

lsblk -l -o NAME,VENDOR,MODEL,PATH,UUID,SIZE,MOUNTPOINT,MODE

echo ""
echo "✅ Detección completada."

