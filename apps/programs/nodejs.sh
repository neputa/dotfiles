#!/bin/bash

echo "# Installing NodeJs"

# 作業ディレクトリ
WORK_DIR="temp$(date +"%Y%m%d%I%M%S")"

mkdir ${WORK_DIR}
cd ${WORK_DIR}

# fnmをダウンロードしてインストールする：
if ! command -v fnm &>/dev/null; then
  curl -o- https://fnm.vercel.app/install | bash
  source ~/.bashrc
fi

# Node.jsをダウンロードしてインストールする：
if ! command -v node &>/dev/null; then
  fnm install --lts
  source ~/.bashrc
fi

# pnpmをインストール
if ! command -v pnpm &>/dev/null; then
  npm install -g pnpm
fi

echo "# ディレクトリ: ${WORK_DIR} を削除..."
cd ../
rm -rf ${WORK_DIR}
