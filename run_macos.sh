#!/bin/bash

rm -rf out/ bin/ obj/

if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew is not installed."
    echo "🚀 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 Homebrew is already installed."
fi

brew update

brew install dotnet@6
brew install nginx

cp nginx-macos.conf /usr/local/etc/nginx/nginx.conf


nginx -t
if [ $? -ne 0 ]; then
    echo "Nginx configuration test failed. Exiting script."
    exit 1
fi

export DOTNET_ROOT="/usr/local/opt/dotnet@6/libexec"
echo 'export PATH="/usr/local/opt/dotnet@6/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
dotnet --version

dotnet restore
dotnet publish -c Release -o out app.csproj
cp -a out/. /usr/local/var/www/miitexam
cp compiled/index.html /usr/local/var/www/miitexam
brew services restart nginx
dotnet /usr/local/var/www/miitexam/app.dll