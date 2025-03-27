#!/bin/bash

echo "# Installing Lazygit"

# 作業ディレクトリ
WORK_DIR="temp$(date +"%Y%m%d%I%M%S")"

mkdir ${WORK_DIR}
cd ${WORK_DIR}

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "# ディレクトリ: ${WORK_DIR} を削除..."
cd ../
rm -rf ${WORK_DIR}
