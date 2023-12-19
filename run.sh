#!/bin/bash
# задаём переменные
service_name="miitexam.service"
site_folder="/var/www/miitexam"

# предварительная очистка, если скрипт уже запускался
# остановить сервис, если запущен
systemctl stop $service_name
systemctl disable $service_name
# убить все процессы dotnet
kill $(ps -ef | grep dotnet | awk '{print $2}')
#удалить установленные пакеты dotnet
apt remove 'dotnet*' 'aspnet*' 'netstandard*' -y
# удалить папки скомпилированного приложения и сайта Ngnix
rm -rf bin obj out
rm -rf $site_folder

# конфигурация репозитория для загрузки dotnet в Ubuntu
preferences_file="/etc/apt/preferences"
touch "$preferences_file"

echo "Package: dotnet* aspnet* netstandard*" | tee -a "$preferences_file"
echo "Pin: origin \"packages.microsoft.com\"" | tee -a "$preferences_file"
echo "Pin-Priority: -10" | tee -a "$preferences_file"

# Get Ubuntu version
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install Microsoft signing key and repository
dpkg -i packages-microsoft-prod.deb

apt install -y net-tools
apt install -y apt-transport-https
apt update
apt install -y dotnet-sdk-6.0
# Clean up
rm packages-microsoft-prod.deb

# Update packages
apt update

# Build 
dotnet restore
dotnet publish -c Release -o out app.csproj

# Настройка NGINX
# Install Nginx if not already installed
apt install nginx -y

# Create a new Nginx configuration file
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name miitexam.app;
	
	root $site_folder;

    location /api {
        proxy_pass http://localhost:5000;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# Enable the Nginx configuration by creating a symlink
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Restart Nginx to apply the changes
service nginx restart

# создать папку сайта проекта
mkdir $site_folder
chmod 755 $site_folder
# копировать файлы скомпилированного приложения в папку деплоя
cp -a out/. $site_folder

# создаем index.html для взаимодействия с API
cat <<EOF > $site_folder/index.html
<!DOCTYPE html>
<html>
<head>
    <title>MiitExamPonomarevD</title>
    <!-- Add Bootstrap CDN link -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Miitexam_Ponomarev_D</h1>
        <h2>Car</h2>
        <form action="/api/car/set" method="post">
            <div class="form-group">
                <label for="maker">Maker:</label>
                <input type="text" name="givenMaker" id="maker" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="model">Model:</label>
                <input type="text" name="givenModel" id="model" class="form-control" required>
            </div>
            <input type="submit" value="Set" class="btn btn-primary">
        </form>
		<hr>
        <h2>Driver</h2>
        <form action="/api/driver/set" method="post">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" name="givenName" id="name" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="age">Age:</label>
                <input type="number" name="givenAge" id="age" class="form-control" required>
            </div>
            <input type="submit" value="Set" class="btn btn-primary">
        </form>
		<hr>
        <h2>Запустить Heathcheck</h2>
        <a href="/api/healthcheck" class="btn btn-primary">Проверить работу API</a>
    </div>

    <!-- Add Bootstrap JS CDN link -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
EOF

# конвертируем в utf-8 with bom
sed -i '1s/^/\xef\xbb\xbf/' $site_folder/index.html

# создаем даемон автозапуска приложения
rm -f /etc/systemd/system/$service_name
cat << EOF > /etc/systemd/system/$service_name
[Unit]
Description=MiitExam
After=network.target

[Service]
ExecStart=dotnet $site_folder/app.dll
WorkingDirectory=$site_folder

[Install]
WantedBy=default.target
EOF
systemctl daemon-reload
systemctl start $service_name
systemctl enable $service_name
systemctl status $service_name --no-pager
# выводим айпи системы, чтобы перейти по нему и открыть сайт
echo "http://"$(ifconfig | grep inet -m1 | awk '{print $2}')
