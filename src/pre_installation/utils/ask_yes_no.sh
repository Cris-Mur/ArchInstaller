ask_yes_no() {
    local prompt="$1"     # Pregunta al usuario
    local default="$2"    # Respuesta por defecto ('y' o 'n')

    # Validar que el valor por defecto sea correcto
    if [[ ! "$default" =~ ^[yYnN]$ ]]; then
        echo "❌ Error: El valor por defecto debe ser 'y' o 'n'."
        return 1
    fi

    # Convertir el valor por defecto a mayúsculas para mostrarlo
    local default_upper=$(echo "$default" | tr '[:lower:]' '[:upper:]')

    while true; do
        read -p "$prompt [y/n] (Default: $default_upper): " answer

        # Si el usuario presiona Enter, usar el valor por defecto
        if [[ -z "$answer" ]]; then
            answer="$default"
        fi

        # Validar entrada
        if [[ "$answer" =~ ^[yYnN]$ ]]; then
            echo "$answer"
            return 0
        else
            echo "⚠ Entrada inválida. Solo se permite 'y' o 'n'."
        fi
    done
}

