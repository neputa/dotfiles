#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -u # 未定義があったら終了する

# -=-=-=- ログ出力関数 -=-=-=-
# 絵文字を使ったログ出力関数を定義
log_color() {
  color_code="$1"
  shift
  printf "\033[${color_code}m%s\033[0m\n" "$*" >&2
}

log_red() {
  log_color "0;31" "$@"
}

log_blue() {
  log_color "0;34" "$@"
}

log_task() {
  log_blue "🔃" "$@"
}

log_manual_action() {
  log_red "⚠️" "$@"
}

log_error() {
  log_red "❌" "$@"
}

error() {
  log_error "$@"
  exit 1
}

# -=-=-=- ルート権限チェック -=-=-=-
# ルート権限が必要な場合、sudoを使用してコマンドを実行する関数
sudo() {
  # shellcheck disable=SC2312
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    if ! command sudo --non-interactive true 2>/dev/null; then
      log_manual_action "ルート権限が必要です。パスワードを以下に入力してください。"
      command sudo --validate
    fi
    command sudo "$@"
  fi
}

# -=-=-=- Git -=-=-=-
# gitリポジトリをクリーンアップする関数
git_clean() {
  path=$(realpath "$1")
  remote="$2"
  branch="$3"

  log_task "Cleaning '${path}' with '${remote}' at branch '${branch}'"
  git="git -C ${path}"
  # Ensure that the remote is set to the correct URL
  if ${git} remote | grep -q "^origin$"; then
    ${git} remote set-url origin "${remote}"
  else
    ${git} remote add origin "${remote}"
  fi
  ${git} checkout -B "${branch}"
  ${git} fetch origin "${branch}"
  ${git} reset --hard FETCH_HEAD
  ${git} clean -fdx
  unset path remote branch git
}

# gitインストール
DOTFILES_REPO_HOST=${DOTFILES_REPO_HOST:-"https://github.com"}
DOTFILES_USER=${DOTFILES_USER:-"neputa"}
DOTFILES_REPO="${DOTFILES_REPO_HOST}/${DOTFILES_USER}/dotfiles"
DOTFILES_BRANCH=${DOTFILES_BRANCH:-"main"}
DOTFILES_DIR="${HOME}/.dotfiles"

if ! command -v git >/dev/null 2>&1; then
  log_task "Installing git using APT"
  sudo apt update
  sudo env DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends git
fi

# gitリポジトリのクローンまたは更新
if [ -d "${DOTFILES_DIR}" ]; then
  git_clean "${DOTFILES_DIR}" "${DOTFILES_REPO}" "${DOTFILES_BRANCH}"
else
  log_task "Cloning '${DOTFILES_REPO}' at branch '${DOTFILES_BRANCH}' to '${DOTFILES_DIR}'"
  git clone --recursive --branch "${DOTFILES_BRANCH}" "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

# -=-=-=- common シンボリックリンク -=-=-=-
# create_symbolicklink_function.shを読み込む
source "${DOTFILES_DIR}/utils/create_symbolicklink_function.sh"

# ファイルのシンボリックリンク作成
log_task "Create symbolic links to common configuration files"
create_symbolic_links_for_files "$DOTFILES_DIR/common/config" ~

# ディレクトリのシンボリックリンク作成
log_task "Create symbolic links for common configuration directories"
create_symbolic_links_for_directories "$DOTFILES_DIR/common/config" "$HOME/.config"

# -=-=-=- ubuntu シンボリックリンク -=-=-=-
# ubuntu/config以下のシンボリックリンク作成

# ファイルのシンボリックリンク作成
log_task "Create symbolic links to Ubuntu configuration files"
create_symbolic_links_for_files "$DOTFILES_DIR/ubuntu/config" ~

# ディレクトリのシンボリックリンク作成
log_task "Create symbolic links for Ubuntu configuration directories"
create_symbolic_links_for_directories "$DOTFILES_DIR/ubuntu/config" "$HOME/.config"

# -=-=-=- ubuntu ファイルコピー -=-=-=-
source "${DOTFILES_DIR}/utils/copy_file_function.sh"

copy_file_with_backup "$DOTFILES_DIR/ubuntu/copy/wsl.conf" "/etc"

# -=-=-=- アプリケーション -=-=-=-
# applicationインストール
log_task "Installing Applications"

sudo apt update && sudo apt full-upgrade -y

# アプリケーションをインストールする関数
function install {
  if ! command -v "$1" &>/dev/null; then
    echo "Installing: $1..."
    sudo apt install -y "$1"
  else
    echo "Already installed: $1"
  fi
}

# 必要なアプリケーションをインストール
apps=(
  curl
  fcitx5
  gcc
  make
  ripgrep
  tree
  unzip
  wget
  xclip
)

for app in "${apps[@]}"; do
  install "$app"
done

# *.sh に一致するファイルがない場合、ループを実行しないようにする
shopt -s nullglob

# ubuntu/apps 以下の全scriptを実行
for script in $DOTFILES_DIR/ubuntu/apps/*.sh; do
  [ -f "$script" ] || continue # ファイルが存在しない場合はスキップ
  bash "$script" -H
done

# 不要なパッケージを削除し、システムを最新状態に
sudo apt upgrade -y
sudo apt autoremove -y
