#!/bin/bash

echo "# Installing Neovim"

sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim
