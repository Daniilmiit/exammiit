#!/bin/bash

# Add Microsoft package repository
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

# Install .NET 6 SDK
apt-get update
apt-get install -y apt-transport-https
apt-get update
apt-get install -y dotnet-sdk-6.0

# Clean up
rm packages-microsoft-prod.deb

# Verify installation
dotnet --version