#!/bin/bash

read -p "SMTP_HOST: " smtphost
read -p "SMTP_FROM: " smtpfrom
read -p "SMTP_PORT: " smtpport
read -p "SMTP_USERNAME: " smtpusername
read -s -p "SMTP_PASSWORD: " smtppassword 
echo 
read -p "Ingrese el nombre que definira al configurar el rclone: " conexion 
read -p "Ingrese puerto que sera para exponer el servicio vaultwarden: " port
read -p "Ingrese contraseña para cifrado de ZIP FILE BACKUP" cifrado
echo

# Generar el token aleatorio y almacenarlo en la variable de entorno ADMIN_TOKEN
ADMIN_TOKEN=$(openssl rand -base64 48)

# Mostrar el token generado en la consola
echo "El token generado es: $ADMIN_TOKEN"
echo 
read -p "Ingrese nombre de dominio para el certificado autofirmando:  " domain
# Generar certificado autofirmado
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=US/ST=California/L=Los Angeles/O=MyOrg/OU=MyDept/CN=$domain.com"

# Copiar certificado a la carpeta ssl en la ruta ./vaultwarden/ssl
mkdir -p ./vaultwarden/ssl
sudo cp /etc/ssl/private/apache-selfsigned.key ./vaultwarden/ssl/
sudo cp /etc/ssl/certs/apache-selfsigned.crt ./vaultwarden/ssl/

# Crear archivo docker-compose.yml
cat <<EOF >./vaultwarden/docker-compose.yml
version: '3.4'

services:

  vaultwarden:
    image: vaultwarden/server:latest
    restart: always
    ports:
      - $port:80
    volumes:
      - ./ssl:/ssl/
      - vaultwarden-data:/data/
    environment:
    # - SIGNUPS_ALLOWED=false
      - ADMIN_TOKEN=$admin_token
      - ROCKET_TLS={certs="/ssl/apache-selfsigned.crt",key="/ssl/apache-selfsigned.key"}
      - SMTP_HOST=$smtphost
      - SMTP_FROM=$smtpfrom
      - SMTP_PORT=$smtpport
      - SMTP_SECURITY=starttls
      - SMTP_USERNAME=$smtpusername
      - SMTP_PASSWORD=$smtppassword

  backup:
    image: ttionya/vaultwarden-backup:latest
    restart: always
    environment:
        RCLONE_REMOTE_NAME: '$conexion'
        RCLONE_REMOTE_DIR: '/bitwardenBackup/'
        RCLONE_GLOBAL_FLAG: ''
        CRON: '5 * * * *'
        ZIP_ENABLE: 'TRUE'
        ZIP_PASSWORD: '$cifrado'
        ZIP_TYPE: 'zip'
        BACKUP_FILE_DATE_SUFFIX: ''
        BACKUP_KEEP_DAYS: 0
    #   PING_URL: ''
    #   MAIL_SMTP_ENABLE: 'TRUE'
    #   MAIL_SMTP_VARIABLES: ''
    #   MAIL_TO: ''
    #   MAIL_WHEN_SUCCESS: 'TRUE'
    #   MAIL_WHEN_FAILURE: 'TRUE'
    #   TIMEZONE: 'UTC'
    volumes:
      - vaultwarden-data:/bitwarden/data/
      - vaultwarden-rclone-data:/config/

volumes:
  vaultwarden-data:
    name: vaultwarden-data
  vaultwarden-rclone-data:
    external: true
    name: vaultwarden-rclone-data
EOF

# Configurar rclone
docker run --rm -it --mount type=volume,source=vaultwarden-rclone-data,target=/config/ ttionya/vaultwarden-backup:latest rclone config
