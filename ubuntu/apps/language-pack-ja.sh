#!/bin/bash

if ! dpkg -l | grep -q language-pack-ja; then
  echo "# Installing language-pack-ja"
  sudo apt -y install language-pack-ja
  sudo update-locale LANG=ja_JP.UTF8
else
  echo "language-pack-ja is already installed."
fi
