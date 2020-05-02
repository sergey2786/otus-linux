#!/bin/bash
sudo su 
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

apt update 
timedatectl set-timezone Europe/Samara
apt-get install openvpn easy-rsa zip -y

mkdir -p /etc/openvpn/keys

#Создаем файл с данными для ключей 
cd /usr/share/easy-rsa/
cat << EOF > vars
export EASY_RSA="/usr/share/easy-rsa/" #Путь к easy-rsa.
export KEY_CONFIG="$EASY_RSA/openssl-1.0.0.cnf" #Конфиг OpenSSL
export KEY_ALTNAMES="something"
export KEY_DIR="/etc/openvpn/keys" #Каталог, в котором мы будем держать ключи.
export KEY_SIZE=2048 # Размер ключа
export CA_EXPIRE=3650 # Срок действия CA
export KEY_EXPIRE=3650 # Срок действия ключа
export KEY_COUNTRY="RU" # Двухбуквенный код страны
export KEY_CITY="Izhevsk" # Город
export KEY_ORG="Test Ltd" # Компания
export KEY_EMAIL="test@test.su" # Email
EOF

#Создаём ключи 
source ./vars
./clean-all # Убиваем старые ключи, если они были.
openvpn --genkey --secret ta.key # Ключ TLS-auth
sudo openssl dhparam -outform PEM -out dh2048.pem 2048 #Ключ Диффи-Хеллмана
./pkitool --initca # Certificate Authority для сервера. 
./pkitool --server vpsrv # Сертификат сервера.

#Разрешаем неуникальные имена
cat << EOF > /etc/openvpn/keys/index.txt.attr
unique_subject = no
EOF
./pkitool vpclient # Сертификат клиента

#Устанавливаем ключи
mv ./ta.key /etc/openvpn/keys
mv ./dh2048.pem /etc/openvpn/keys

# Создаем конфиг сервера
cat << EOF > /etc/openvpn/server.conf
mode server
tls-server
proto tcp-server
dev tap
port 5555 # Порт
daemon
tls-auth /etc/openvpn/keys/ta.key 0
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/vpsrv.crt
key /etc/openvpn/keys/vpsrv.key
dh /etc/openvpn/keys/dh2048.pem
ifconfig 10.10.0.1 255.255.255.0 # Внутренний IP сервера
ifconfig-pool 10.10.0.2 10.10.0.128 # Пул адресов.
;push "redirect-gateway def1" # Перенаправлять default gateway на vpn-сервер. Если не нужно - закомментировать.
push "route-gateway 10.10.0.1"
duplicate-cn
verb 3
cipher DES-EDE3-CBC # Тип шифрования.
persist-key
log-append /var/log/openvpn.log # Лог-файл.
persist-tun
comp-lzo
EOF

systemctl start openvpn@server
systemctl enable openvpn@server

#Готовим ключи для клиента и кладем их в root 
cd /root
mkdir clientkeys
cd clientkeys
cp /etc/openvpn/keys/ta.key ./
cp /etc/openvpn/keys/ca.crt ./
cp /etc/openvpn/keys/vpclient.crt ./
cp /etc/openvpn/keys/vpclient.key ./

# Тут же делаем сертификат клиента 
cat << EOF > client.ovpn
client
dev tap
proto tcp
remote 192.168.11.150 5555
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert vpclient.crt
key vpclient.key
ns-cert-type server
tls-auth ta.key 1
cipher DES-EDE3-CBC
comp-lzo
verb 3
EOF

zip -9 -y -r -P1234 /var/www/distrib/vpnkeys.zip * # Складываем в zip задаем пароль архиву 

