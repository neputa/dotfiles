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

echo "# シンボリックリンク作成スクリプト"
echo "# '${WORK_DIR}'のdotで始まるファイルにシンボリックリンクを作成"

# ディレクトリ内の、ドットから始まり2文字以上の名前のファイルにシンボリックリンクを追加する
log_task "処理開始..."
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitconfig.local.template" ] && continue
    [ "$f" = ".gitmodules" ] && continue
    [ "$f" = ".require_oh-my-zsh" ] && continue

    # シンボリックリンクを貼る
    ln -snfv ${PWD}/"$f" ~/
done

# Neovim
NVIM_CONFIG="$HOME/.config/nvim"
BACKUP_DIR="$NVIM_CONFIG.backup"
DOTFILES_NVIM="${ROOT_DIR}/.config/nvim"

# ~/.config/nvim が存在するかチェック
if [ -e "$NVIM_CONFIG" ]; then
    echo "既存の ~/.config/nvim をバックアップします: $BACKUP_DIR"
    mv "$NVIM_CONFIG" "$BACKUP_DIR"
fi

# シンボリックリンクを作成
ln -snfv "$DOTFILES_NVIM" "$NVIM_CONFIG"

log_task "# 完了!"

