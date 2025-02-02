#!/bin/bash

########################################################################
## Arch Pre-Instalation Script  ########################################
########################################################################

UTILS="src/basic_installation/utils"
BASIC_INSTALLATION_SCRIPTS="src/basic_installation"

source $UTILS/ask_yes_no.sh

pause(){
    read -p "Presione ENTER para continuar..."
}

pre_installation() {
    echo "#########################################################################"
    echo "Verificando conexion a internet"
    $UTILS/internet_checker.sh
    echo "Verificando el reloj del sistema"
    manage_timedate
    $UTILS/disc_detector.sh
    response=$(ask_yes_no "¿Todo está correctamente, para continuar?" "n")

    if [[ "$response" =~ ^[nN]$ ]]; then
        exit 1
    fi
    
}


manage_timedate() {
    echo ""
    echo "Por favor verifique si la maquina usa la sincronizacion NTP."
    echo ""
    timedatectl
    response=$(ask_yes_no "¿Es correcta la configuración?" "y")

    if [[ ! "$response" =~ ^[yY]$ ]]; then
        $BASIC_INSTALLATION_SCRIPTS/enable_ntp.sh
        pause
    fi
}

root_checker() {
    # Verifica si el usuario tiene permisos de root (requerido para obtener información completa)
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Este script debe ejecutarse como root o con sudo."
        exit 1
    fi
}

# TODO
    ## Manage Storage System PARTITIONS
    ## Curl to https://archlinux.org/mirrorlist/?country=CO&country=JP&country=MX&country=US&protocol=http&protocol=https&ip_version=4
    ## set mirrorlist
    ## pacstrap installation

main_script (){
### Script runing
    clear
    $BASIC_INSTALLATION_SCRIPTS/manage_storage.sh
}
RED='\033[0;31m'
NC='\033[0m'       # Reset (color por defecto)
clear
echo "#########################################################################"
echo "Ejecutando script de Pre-instalación ...."
sleep 1
pre_installation
echo -e "${RED}#########################################################################"
echo "ADVERTENCIA: ############################################################"
echo "# Este script esta pensado para instalar un sistema operativo."
echo "TENGA CUIDADO. PUEDE AFECTAR SUS DISPOSITIVOS DE ALMACENAMIENTO!!!!"
echo -e "#########################################################################${NC}"
echo "#########################################################################"
sleep 5
main_script
