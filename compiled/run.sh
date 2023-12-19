#!/bin/bash
# переменные
site_folder="/var/www/miitexam"
service_name="miitexam.service"

# зачиска прошлого запуска
sudo rm -rf $site_folder
sudo systemctl stop $service_name && systemctl disable $service_name

# настройка nginx и копирование конфигов
sudo apt-get install nginx -y
sudo mkdir $site_folder
sudo chmod 755 $site_folder
sudo cp --verbose -a . $site_folder
sudo cp --verbose ./default /etc/nginx/sites-available/default
sudo cp --verbose ./miitexam.service /etc/systemd/system
sudo cp --verbose ./preferences /etc/apt/preferences
sudo systemctl daemon-reload
sudo systemctl restart nginx && systemctl status nginx --no-pager

# настройка dotnet
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
sudo wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt install -y apt-transport-https net-tools
sudo apt update
sudo apt install -y dotnet-sdk-6.0
sudo rm packages-microsoft-prod.deb
sudo apt update

# запуск приложения
sudo systemctl start $service_name
sudo systemctl enable $service_name
sudo systemctl status $service_name --no-pager

# вывод адреса подключения
echo "http://"$(ifconfig | grep inet -m1 | awk '{print $2}')