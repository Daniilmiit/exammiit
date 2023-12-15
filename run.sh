#!/bin/bash
apt remove 'dotnet*' 'aspnet*' 'netstandard*' -y

preferences_file="/etc/apt/preferences"

# Create the preferences file
touch "$preferences_file"

# Add content to the preferences file
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

ifconfig

dotnet out/app.dll
