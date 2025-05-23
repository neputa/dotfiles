#!/bin/bash

if ! fc-list | grep -qi "HackGen"; then
  echo "# Installing HackGen Font"

  # 作業ディレクトリ
  WORK_DIR="temp$(date +"%Y%m%d%I%M%S")"

  mkdir ${WORK_DIR}
  cd ${WORK_DIR}

  curl -OL https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_NF_v2.10.0.zip

  filename=HackGen_NF_v2.10.0.zip
  extension="${filename##*.}"
  filename="${filename%.*}"

  mkdir ${filename} && pushd ${filename}

  unzip ../${filename}.${extension}
  popd

  mkdir -p ~/.fonts

  mv ${filename} ~/.fonts/
  fc-cache -fv

  echo "# ディレクトリ: ${WORK_DIR} を削除..."
  cd ../
  rm -rf ${WORK_DIR}
else
  echo "HackGen Font is already installed."
fi
