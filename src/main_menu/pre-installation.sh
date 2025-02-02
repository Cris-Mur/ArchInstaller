#!/usr/bin/env bash

###############################################################################
#### PRE - INSTALLATION SCRIPT  ###############################################
###############################################################################
loadkeymap () {
    echo "Configurando la sigiente distribución: $1"
    if [ ! $(localectl list-keymaps | grep -x $1) ]; then
        echo "Distribución incorrecta..."
        return 1
    fi
    loadkeys $1
    echo $1
}

kbd_setup() {
    KBD_KEYMAP="us"
    echo ""
    echo "Por defecto el teclado configurado usa la distribución us"
    echo "usted puede configurar temporalmente su distribución de teclado."
    echo ""
    while true; do
        echo "################################################################"
        echo "Distribución actual: $KBD_KEYMAP"
        echo "################################################################"
        echo "1. Lista de distribuciones de teclado"
        echo "2. Configuración"
        echo "3. Probar distribución"
        echo "4. Dejar tal cual. (Default)"
        echo "################################################################"
        read -p "Seleccione una opción: " OPTION
        
        case $OPTION in
            1) localectl list-keymaps ;;
            2) read -p "Ingrese la distribución escogida:" KBD_KEYMAP ; loadkeymap $KBD_KEYMAP ;;
            3) read -p ":KEYMAP TESTER > " ;;
            *) echo " # Configuración de teclado terminada"; return 0 ;;
        esac

        read -p "Presione Enter para continuar..."
        clear
    done


}

boot_system_checker() {
    echo "Verificando su sistema de arranque ..."
    sleep 1
    if [ ! $(dmesg | grep "EFI v") ]; then
        echo -e "\033[0;33m Su sistema ha arrancado en modo sistema BIOS - Legacy.\033[0m"
        return 0
    fi
    echo -e "\033[0;33m Su sistema es un sistema efi....\033[0m"
    dmesg | grep "EFI v"

}

internet_checker() {
    local SRV_TO_CONNECT="8.8.8.8"
    echo "Verificando si esta conectado a internet...."
    echo "usando ${SRV_TO_CONNECT}"
    if ping -c 5 -i 0.2 "$SRV_TO_CONNECT" >/dev/null 2>&1; then
        echo -e "\033[0;32m\tConexión a internet verificada satisfactoriamente\033[0m"
    else
        echo -e "\033[0;31m\tNo se ha podido verificar la conexión a internet... D:\033[0m"
    fi
    sleep 2
    return 1
}

rtc_sync_checker() {
    echo "Evaluando si el reloj interno se encuentra sincronizado...."
    timedatectl
    if timedatectl | grep -x "System clock synchronized: yes"; then
        echo "Sincronización del reloj interno Activada"
    else
        echo "Sincronización del reloj interno Desactivada"
    fi
    sleep 2
}

storage_devices_detector() {
    echo ""
    echo "Detectando Dispositivos de almacenamiento...."
    sleep 1
    echo "Dispositivos de almacenamiento detectados:"
    echo "------------------------------------------"
    lsblk -l -o NAME,VENDOR,MODEL,PATH,UUID,SIZE,MOUNTPOINT,MODE
    echo ""
    echo "✅ Detección completada."
}
###############################################################################
clear
echo "PRE INSTALLATION SCRIPT"
echo "1. Configuración de teclado."
kbd_setup
echo "2. Verificación de sistema de arranque."
boot_system_checker
sleep 2
echo "3. Conexión de Internet."
internet_checker
sleep 2
echo "4. Sincronización del Reloj interno. RTC-NTP"
rtc_sync_checker
sleep 2
echo "5. Acceso a dispositivos de almacenamiento."
storage_devices_detector
echo "Script de pre-instalación completado."
