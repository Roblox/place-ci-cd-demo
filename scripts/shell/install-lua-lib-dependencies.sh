#!/bin/bash

# Update package list
sudo apt-get update

# Install Lua and its development files
sudo apt-get install -y lua5.3 liblua5.3-dev

# Install other required dependencies
sudo apt-get install -y build-essential libreadline-dev unzip

# Set LuaRocks version
LUAROCKS_VERSION="3.9.2"

# Download LuaRocks
wget "https://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz"

# Extract the archive
tar zxpf "luarocks-$LUAROCKS_VERSION.tar.gz"

# Change to LuaRocks directory
cd "luarocks-$LUAROCKS_VERSION"

# Configure, build, and install LuaRocks
./configure --with-lua-include=/usr/include/lua5.3
make
sudo make install

# Verify the installation
luarocks --version

# Clean up
cd ..
rm -rf "luarocks-$LUAROCKS_VERSION"*

echo "LuaRocks installation completed successfully!"