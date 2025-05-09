#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -u

# -=-=-=- logger script -=-=-=-
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

# -=-=-=- root authority check -=-=-=-
# Function to execute commands using sudo if root privileges are required
sudo() {
  # shellcheck disable=SC2312
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    if ! command sudo --non-interactive true 2>/dev/null; then
      log_manual_action "Added settings to enable extra plugins related to copilot."
      command sudo --validate
    fi
    command sudo "$@"
  fi
}

# -=-=-=- Git -=-=-=-
# clean up git repository function
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

# install git
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

# clone repository or update
if [ -d "${DOTFILES_DIR}" ]; then
  git_clean "${DOTFILES_DIR}" "${DOTFILES_REPO}" "${DOTFILES_BRANCH}"
else
  log_task "Cloning '${DOTFILES_REPO}' at branch '${DOTFILES_BRANCH}' to '${DOTFILES_DIR}'"
  git clone --recursive --branch "${DOTFILES_BRANCH}" "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

# -=-=-=- common symbolic link -=-=-=-
# create_symbolicklink_function.shを読み込む
source "${DOTFILES_DIR}/utils/create_symbolicklink_function.sh"

# create symbolic links  for files
log_task "Create symbolic links to common configuration files"
create_symbolic_links_for_files "$DOTFILES_DIR/common/config" ~

# create symbolic links  for directories
log_task "Create symbolic links for common configuration directories"
create_symbolic_links_for_directories "$DOTFILES_DIR/common/config" "$HOME/.config"

# -=-=-=- ubuntu symbolic link -=-=-=-
# Create symbolic link under ubuntu/config

# Create symbolic links to files
log_task "Create symbolic links to Ubuntu configuration files"
create_symbolic_links_for_files "$DOTFILES_DIR/ubuntu/config" ~

# Create symbolic links to directories
log_task "Create symbolic links for Ubuntu configuration directories"
create_symbolic_links_for_directories "$DOTFILES_DIR/ubuntu/config" "$HOME/.config"

# -=-=-=- ubuntu copy files -=-=-=-
source "${DOTFILES_DIR}/utils/copy_file_function.sh"

copy_file_with_backup "$DOTFILES_DIR/ubuntu/copy/wsl.conf" "/etc"

# -=-=-=- applications -=-=-=-
# install application
log_task "Installing Applications"

sudo apt update && sudo apt full-upgrade -y

# Function to install the application
function install {
  if ! command -v "$1" &>/dev/null; then
    echo "Installing: $1..."
    sudo apt install -y "$1"
  else
    echo "Already installed: $1"
  fi
}

# Install required applications
apps=(
  curl
  fcitx5
  gcc
  make
  ripgrep
  openssh-server
  tree
  unzip
  wget
  xclip
)

for app in "${apps[@]}"; do
  install "$app"
done

# Do not execute a loop if there is no matching file in *.sh
shopt -s nullglob

# Run all scripts under ubuntu/apps
for script in $DOTFILES_DIR/ubuntu/apps/*.sh; do
  [ -f "$script" ] || continue # Skip if file does not exist
  bash "$script" -H
done

# Remove unnecessary packages and bring your system up to date
sudo apt upgrade -y
sudo apt autoremove -y

log_task "Application installation complete"

# -=-=-=- resolv.conf -=-=-=-
log_task "Delete and create new resolv.conf"

sudo rm -rf /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

log_task "Deletion and new creation of resolv.conf completed"

# -=-=-=- Newvim -=-=-=-
log_task "Restore Neovim plug-ins"

nvim --headless "+Lazy! restore" +qa

log_task "Completed restoration of neovim plug-ins"
