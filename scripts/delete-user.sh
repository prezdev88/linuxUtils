#!/bin/bash

# Verificar si se pasó un nombre de usuario
if [ -z "$1" ]; then
    echo "Uso: $0 nombre_usuario"
    exit 1
fi

USER_NAME="$1"

# Verificar si el usuario existe
if ! id "$USER_NAME" &>/dev/null; then
    echo "El usuario '$USER_NAME' no existe."
    exit 1
fi

# Preguntar si desea eliminar el home del usuario
echo "¿Quieres eliminar el directorio home de $USER_NAME? [s/n]"
read -r DELETE_HOME

if [ "$DELETE_HOME" = "s" ]; then
    sudo userdel -r "$USER_NAME"
    echo "Usuario '$USER_NAME' y su home eliminados."
else
    sudo userdel "$USER_NAME"
    echo "Usuario '$USER_NAME' eliminado, pero su home sigue en /home/$USER_NAME."
fi
 