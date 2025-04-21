#!/bin/bash

echo "# Installing NodeJs"

# 作業ディレクトリ
WORK_DIR="temp$(date +"%Y%m%d%I%M%S")"

mkdir ${WORK_DIR}
cd ${WORK_DIR}

# nodejsをダウンロードしてインストールする：
if ! command -v node &>/dev/null; then
  sudo apt install nodejs
fi

# npmをダウンロードしてインストールする：
if ! command -v npm &>/dev/null; then
  sudo apt install npm
fi

# n をインストールする：
sudo npm install n -g

# nodejsをnでインストールする：
sudo n lts

# pnpmをインストール
if ! command -v pnpm &>/dev/null; then
  sudo npm install -g pnpm
fi

# 古い nodejs npm の削除：
sudo apt purge nodejs npm -y
