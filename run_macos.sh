﻿#!/bin/bash
# задаём переменные
service_name="miitexam.service"
site_folder="/usr/www/miitexam"

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

export DOTNET_ROOT="/usr/local/opt/dotnet@6/libexec"
echo 'export PATH="/usr/local/opt/dotnet@6/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
dotnet --version

dotnet restore
dotnet publish -c Release -o out app.csproj

cp -a out/. /user