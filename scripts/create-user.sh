#!/bin/bash

# Verificar si se pasó un parámetro
if [ -z "$1" ]; then
    echo "Uso: $0 nombre_usuario"
    exit 1
fi

USER_NAME="$1"

# Crear el usuario con su home y bash como shell predeterminado
sudo useradd -m -s /bin/bash "$USER_NAME"

# Configurar contraseña
echo "Configurando la contraseña para $USER_NAME..."
sudo passwd "$USER_NAME"

# Agregar al grupo wheel (sudo) opcionalmente
echo "¿Quieres agregar $USER_NAME al grupo sudo (wheel)? [s/n]"
read -r ADD_SUDO
if [ "$ADD_SUDO" = "s" ]; then
    sudo usermod -aG wheel "$USER_NAME"
    echo "$USER_NAME agregado al grupo wheel."
fi

# Copiar .xinitrc si existe en el usuario actual
if [ -f ~/.xinitrc ]; then
    sudo cp ~/.xinitrc "/home/$USER_NAME/"
    sudo chown "$USER_NAME:$USER_NAME" "/home/$USER_NAME/.xinitrc"
    echo "Archivo .xinitrc copiado a /home/$USER_NAME/"
else
    echo "No se encontró .xinitrc en tu home. Puedes crearlo manualmente en /home/$USER_NAME/"
fi

# Preguntar si se quiere importar toda la configuración de .config
echo "¿Quieres importar toda la configuración de ~/.config al nuevo usuario? [s/n]"
read -r IMPORT_CONFIG

if [ "$IMPORT_CONFIG" = "s" ]; then
    # Crear la ruta de .config para el nuevo usuario
    sudo mkdir -p "/home/$USER_NAME/.config"
    
    # Copiar todo el contenido de .config al nuevo usuario
    sudo cp -r ~/.config/* "/home/$USER_NAME/.config/"
    
    # Cambiar la propiedad al nuevo usuario
    sudo chown -R "$USER_NAME:$USER_NAME" "/home/$USER_NAME/.config"
    
    echo "Toda la configuración de ~/.config ha sido copiada a /home/$USER_NAME/.config/"
fi

# Verificar si la línea %wheel está habilitada en el archivo sudoers
if sudo grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then
    echo "El grupo wheel ya tiene permisos sudo."
else
    echo "No se encuentra la configuración de sudo para el grupo wheel. Procediendo a agregarla."
    
    # Añadir la línea para el grupo wheel (debe estar en la línea correcta)
    echo "%wheel ALL=(ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
    echo "Se ha habilitado el acceso sudo para el grupo wheel."
fi

echo "Usuario $USER_NAME creado exitosamente."

# Agregar esto
# cp -r /home/prezdev/.icons /home/prezdev/.themes /home/prezdev/.Xresources /home/work/
# chown -R work:work /home/work/.icons /home/work/.themes /home/work/.Xresources

# cp -r /home/prezdev/.local/share/omf /home/work/.local/share/
# chown -R work:work /home/work/.config/fish /home/work/.local/share/omf

# cp -r /home/prezdev/.gitconfig /home/work/
# chown -R work:work /home/work/.gitconfig