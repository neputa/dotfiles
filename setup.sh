#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -u # 未定義があったら終了する

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

DOTFILES_REPO_HOST=${DOTFILES_REPO_HOST:-"https://github.com"}
DOTFILES_USER=${DOTFILES_USER:-"neputa"}
DOTFILES_REPO="${DOTFILES_REPO_HOST}/${DOTFILES_USER}/dotfiles"
DOTFILES_BRANCH=${DOTFILES_BRANCH:-"main"}
DOTFILES_DIR="${HOME}/.dotfiles"

if ! command -v git >/dev/null 2>&1; then
  log_task "APT を使用して git をインストール"
  sudo apt update
  sudo env DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends git
fi

if [ -d "${DOTFILES_DIR}" ]; then
  git_clean "${DOTFILES_DIR}" "${DOTFILES_REPO}" "${DOTFILES_BRANCH}"
else
  log_task "Cloning '${DOTFILES_REPO}' at branch '${DOTFILES_BRANCH}' to '${DOTFILES_DIR}'"
  git clone --recursive --branch "${DOTFILES_BRANCH}" "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

# dotfilesインストール
DOTFILES_INSTALL_SCRIPT="${DOTFILES_DIR}/config/install-dotfiles.sh"

if [ -f "${DOTFILES_INSTALL_SCRIPT}" ]; then
  log_task "Running '${DOTFILES_INSTALL_SCRIPT}'"
  bash "${DOTFILES_INSTALL_SCRIPT}" "$@"
else
  error "install-dotfiles.shが見つかりません。"
fi

# applicationインストール
APPS_INSTALL_SCRIPT="${DOTFILES_DIR}/apps/install-apps.sh"

if [ -f "${APPS_INSTALL_SCRIPT}" ]; then
  log_task "Running '${APPS_INSTALL_SCRIPT}'"
  bash "${APPS_INSTALL_SCRIPT}" "$@"
else
  error "install-apps.shが見つかりません。"
fi
