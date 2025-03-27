# !/usr/bin/env bash

# -e: exit on error
# -u: exit on unset variables
set -u # 未定義があったら終了する

# log出力スクリプト
ROOT_DIR=$(realpath "$(dirname "$0")/..")
source "${ROOT_DIR}/log_functions.sh"

# work directory
WORK_DIR=$(realpath $(dirname "$0"))
cd $WORK_DIR

log_task "dotfilesのシンボリックリンク作成"

# ディレクトリ内の、ドットから始まり2文字以上の名前のファイルにシンボリックリンクを追加する
for f in .??*; do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitconfig.local.template" ] && continue
  [ "$f" = ".gitmodules" ] && continue
  [ "$f" = ".require_oh-my-zsh" ] && continue

  # ファイルのみを対象にする
  [ -f "$f" ] || continue

  # シンボリックリンクを貼る
  ln -snfv ${PWD}/"$f" ~/
done

echo "dotfilesのシンボリックリンク作成完了"

log_task ".config以下ディレクトリのシンボリックリンク作成"

# .config以下のディレクトリ
SOURCE_DIR="${WORK_DIR}/.config"
TARGET_DIR="$HOME/.config"

# .config 内のディレクトリをループ処理
for dir in "$SOURCE_DIR"/*/; do
  # ディレクトリ名を取得（フルパスから最後の部分のみ抽出）
  dirname=$(basename "$dir")

  # シンボリックリンクのパス
  symlink_target="$dir"
  symlink_path="$TARGET_DIR/$dirname"

  # 既存のディレクトリがある場合は .backup を付与して退避
  if [ -d "$symlink_path" ] && [ ! -L "$symlink_path" ]; then
    echo "Backing up existing directory: $symlink_path"
    mv "$symlink_path" "${symlink_path}.backup"
  fi

  # 既にシンボリックリンクがある場合は削除（上書き）
  if [ -L "$symlink_path" ]; then
    echo "Removing existing symlink: $symlink_path"
    rm "$symlink_path"
  fi

  # シンボリックリンクを作成
  ln -s "$symlink_target" "$symlink_path"
  echo "Created symlink: $symlink_path -> $symlink_target"
done

echo ".config以下ディレクトリのシンボリックリンク完了"
