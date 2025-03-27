#!/bin/bash

# -e: exit on error
# -u: exit on unset variables
set -u # 未定義があったら終了する

# log出力スクリプト
source "$(dirname "$0")/../log_functions.sh"

log_task "# アプリケーションのインストール"

sudo apt update && sudo apt full-upgrade -y

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    log_task "Installing: ${1}..."
    sudo apt install -y $1
  else
    log_task "Already installed: ${1}"
  fi
}

install curl
install fcitx5
install gcc
install make
install ripgrep
install tree
install unzip
install wget
install xclip

# programs/ 以下の全scriptを実行
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y
