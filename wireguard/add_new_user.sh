#!/bin/bash

# Путь к конфигурации WireGuard на сервере
WG_CONF_DIR="/etc/wireguard"
WG_CONF_FILE="$WG_CONF_DIR/wg0.conf"
CLIENTS_DIR="$WG_CONF_DIR/clients"

# Убедитесь, что вы запускаете этот скрипт с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами суперпользователя"
  exit
fi

# Создаем директорию для хранения конфигураций клиентов, если её не существует
mkdir -p $CLIENTS_DIR

# Генерация пользователя
read -p "Введите имя клиента: " CLIENT_NAME
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)
PRESHARED_KEY=$(wg genpsk)

# Получаем следующий доступный IP-адрес для клиента
LAST_IP=$(grep -oP 'AllowedIPs = 10\.0\.0\.\K[0-9]+' $WG_CONF_FILE | sort -n | tail -n 1)
if [ -z "$LAST_IP" ]; then
  CLIENT_IP="10.0.0.2"
else
  CLIENT_IP="10.0.0.$((LAST_IP + 1))"
fi

# Добавление клиента в конфигурационный файл сервера
echo -e "\n[Peer]" >> $WG_CONF_FILE
echo "PublicKey = $CLIENT_PUBLIC_KEY" >> $WG_CONF_FILE
echo "AllowedIPs = $CLIENT_IP/32" >> $WG_CONF_FILE
echo "PresharedKey = $PRESHARED_KEY" >> $WG_CONF_FILE

# Создание конфигурационного файла для клиента
CLIENT_CONF_FILE="$CLIENTS_DIR/$CLIENT_NAME.conf"
echo "[Interface]" > $CLIENT_CONF_FILE
echo "Address = $CLIENT_IP/8" >> $CLIENT_CONF_FILE
echo "PrivateKey = $CLIENT_PRIVATE_KEY" >> $CLIENT_CONF_FILE
echo "DNS = 8.8.8.8" >> $CLIENT_CONF_FILE

echo -e "\n[Peer]" >> $CLIENT_CONF_FILE
echo "PublicKey = $(cat $WG_CONF_DIR/publickey)" >> $CLIENT_CONF_FILE
echo "Endpoint = 130.193.38.194:51820" >> $CLIENT_CONF_FILE
echo "AllowedIPs = 10.0.0.0/8" >> $CLIENT_CONF_FILE
echo "PresharedKey = $PRESHARED_KEY" >> $CLIENT_CONF_FILE

# Установка прав доступа для файла клиента
chmod 600 $CLIENT_CONF_FILE

# Перезапуск WireGuard для применения изменений
wg-quick down wg0
wg-quick up wg0

# Информация для пользователя
echo "Конфигурация для клиента $CLIENT_NAME создана: $CLIENT_CONF_FILE"
echo "Передайте этот файл клиенту для настройки подключения."
