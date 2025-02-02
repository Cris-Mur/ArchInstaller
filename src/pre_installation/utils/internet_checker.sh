#!/bin/bash

check_internet() {
    local ip="$1"
    local intentos="$2"

    # Verificar que se hayan pasado los parámetros
    if [ -z "$ip" ] || [ -z "$intentos" ]; then
        echo "❌ Uso: verificar_conexion <IP> <número_de_pings>"
        return 1
    fi

    # Realizar los pings y contar cuántos tuvieron éxito
    if ping -c "$intentos" -q "$ip" >/dev/null 2>&1; then
        echo "✅ Conexión exitosa con $ip"
        return 0
    else
        echo "❌ No se pudo conectar con $ip"
        return 1
    fi
}

check_internet 8.8.8.8 5
