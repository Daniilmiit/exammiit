#!/bin/bash

rm -rf out/

if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew is not installed."
    echo "🚀 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 Homebrew is already installed."
fi

brew update
source ~/.zshrc
brew install dotnet@6
brew install nginx

cp nginx-macos.conf /usr/local/etc/nginx/nginx.conf
brew services restart nginx

export DOTNET_ROOT="/usr/local/opt/dotnet@6/libexec"
echo 'export PATH="/usr/local/opt/dotnet@6/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
dotnet --version

dotnet restore
dotnet publish -c Release -o out app.csproj

cp --verbose -a out/. /var/www/miitexam