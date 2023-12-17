# задаём переменные
service_name="miitexam.service"
site_folder="/var/www/miitexam"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
