#!/bin/bash

echo "# Installing Neovim"

if ! grep -r "neovim-ppa" /etc/apt/sources.list /etc/apt/sources.list.d/ >/dev/null; then
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
fi

if ! dpkg -l | grep -q neovim; then
  sudo apt install neovim -y
fi
