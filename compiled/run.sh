#!/bin/bash
# переменные
site_folder="/var/www/miitexam"
service_name="miitexam.service"

# настройка nginx и копирование конфигов
sudo apt-get install nginx -y
mkdir $site_folder
sudo chmod 755 $site_folder
sudo cp --verbose -a . $site_folder
sudo cp --verbose ./default /etc/nginx/sites-available/default
sudo cp --verbose ./miitexam.service /etc/systemd/system
sudo cp --verbose ./preferences /etc/apt/preferences
systemctl daemon-reload
sudo systemctl restart nginx && systemctl status nginx --no-pager

# настройка dotnet
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt install -y apt-transport-https net-tools
apt update
apt install -y dotnet-sdk-6.0
rm packages-microsoft-prod.deb
apt update

# запуск приложения
systemctl start $service_name
systemctl enable $service_name
systemctl status $service_name --no-pager

# вывод адреса подключения
echo "http://"$(ifconfig | grep inet -m1 | awk '{print $2}')