#!/bin/bash

# Verifica si el usuario tiene permisos de root
if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script debe ejecutarse como root o con sudo."
    exit 1
fi

# Ejecutar el comando
echo "⏳ Habilitando sincronización de tiempo con NTP..."
if timedatectl set-ntp true; then
    echo "✅ Sincronización de tiempo habilitada correctamente."
else
    echo "❌ Error al habilitar la sincronización de tiempo."
    exit 1
fi

