#!/bin/bash

echo "# Installing NodeJs"

# 作業ディレクトリ
WORK_DIR="temp$(date +"%Y%m%d%I%M%S")"

mkdir ${WORK_DIR}
cd ${WORK_DIR}

# fnmをダウンロードしてインストールする：
curl -o- https://fnm.vercel.app/install | bash

source ~/.bashrc

# Node.jsをダウンロードしてインストールする：
fnm install --lts

source ~/.bashrc

echo "# ディレクトリ: ${WORK_DIR} を削除..."
cd ../
rm -rf ${WORK_DIR}
