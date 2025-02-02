#!/bin/bash

UTILS="src/basic_installation/utils"

source $UTILS/ask_yes_no.sh

RED='\033[0;31m'
NC='\033[0m'       # Reset (color por defecto)


pause(){
    read -p "Presione ENTER para continuar..."
    tput cuu1 && tput el
}

mount_mnt() {
    local mnt_device="$1"
    mount "$mnt_device" /mnt
}

Unmount_mnt() {
    local mnt_device="$1"
    umount -r /mnt
}

make_root_partition() {
    echo -e "${RED}PELIGRO: Formateando la partición '$1'${NC}"
    mkfs.ext4 "$1"
}

check_mnt(){
    echo "Verificando si la carpeta mnt esta correctamente montada en el sistema"
    echo "Tenga en cuenta que se entiende que /mnt esta montado y vacio."
    if is_mounted "/mnt"; then
        echo "Continuando con la instalación...."
    else
        echo "Se requiere montar el dispositivo de almacenamiento, para la raíz"
        echo "del sistema a instalar."
        response=$(ask_yes_no "desea montar /mnt ??", "n")
        echo -e "$response"
        if [[ "$response" =~ ^[yY]$ ]]; then
            read -p "Ingrese el PATH del dispositivo de almacenamiento a montar:" root_device
            if mount_mnt "$root_device"; then
                echo "Dispositivo montado correctamente."
            else
                echo "ERROR al Montar el dispositivo '$root_device'"
                make_root_partition "$root_device"
            fi
        fi
    fi
}

is_mounted() {
    local mount_folder="$1"

    if findmnt -n "$mount_folder" >/dev/null 2>&1; then
        echo "✅ '$mount_folder' está montada en el sistema."
        return 0
    else
        echo "❌ la carpeta '$mount_folder', NO está montada."
        return 1
    fi
}

###############################################################################
## Start SCRIPT
echo "##########################################################################"
echo "ADVERTENCIA: ############################################################"
echo "# Este script esta pensado para instalar un sistema operativo."
echo "TENGA CUIDADO. PUEDE AFECTAR SUS DISPOSITIVOS DE ALMACENAMIENTO!!!!"
echo "##########################################################################"
echo "ATENCION: Tenga en cuenta que el sistema de archivos a instalar debe"
echo "cumplir con la disposición de los ejemplos de almacenamiento según la WIKI"
echo "de Arch literal 1.9.1"
echo "claramente dependiendo de las caracteristicas del sistema deseado."
echo ""
echo "##########################################################################"
echo ""
echo "ROOT: / /mnt"
echo ""
echo "Un sistema de archivos compatible con un sistema POSIX o Unix-like, parte"
echo "del directorio raíz."
echo "La Raíz del sistema a instalar es normalmente una partición de un" 
echo "dispositivo de almacenamiento que es montado en la carpeta /mnt en el"
echo "ArchISO"
pause
echo ""
echo "BOOT: /boot /mnt/boot"
echo ""
echo "Dependiendo del tipo de maquina que va a usar hay ciertas caracteristicas"
echo "que son importantes de determinar. (Ej. un sistema UEFI, o VIRT)"
echo "En el caso de tener una maquina con un BOOT dual o con una partición"
echo "especial para gestionar el arranque o booteo de la maquina es importante"
echo "verificar que esta sea correctamente montada en el sistema de archivos a"
echo "instalar."
pause
echo ""
echo "[SWAP] /dev/**"
echo ""
echo "En ciertos sistemas es de utilidad tener habilitado el sistema SWAP, este"
echo "es un dispositivo o partición de almacenamiento destinado para este fin."
echo "Vease mayor información del sistema SWAP en la WIKI."
echo "https://wiki.archlinux.org/title/Swap"
pause
echo ""
echo "Tenga en cuenta que si lo desea puede separar el sistema de archivos del"
echo "usurario en una particion independiente."
echo ""
echo "HOME: /home /mnt/home"
echo ""
pause
echo "##########################################################################"
echo "ATENCION: Por el momento no se cuenta con la posibilidad de cambiar la"
echo "estructura de los dispositivos de almacenamiento, ya que normalmente al"
echo "al momento de ejecutar la instalación ya suelo tener preparadas o definidas"
echo "las particiones del sistema."
echo "##########################################################################"
$UTILS/disc_detector.sh
pause
check_mnt
Unmount_mnt
pause
