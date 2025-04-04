#!/bin/bash

# Function to create symbolic links for dotfiles
function create_symbolic_links_for_files() {
  local source_dir="$1"
  local target_dir="$2"

  for f in "$source_dir"/.*; do
    [ "$(basename "$f")" = ".git" ] && continue
    [ "$(basename "$f")" = ".gitconfig.local.template" ] && continue
    [ "$(basename "$f")" = ".gitmodules" ] && continue
    [ "$(basename "$f")" = ".require_oh-my-zsh" ] && continue

    # ファイルのみを対象にする
    [ -f "$f" ] || continue

    local target_file="$target_dir/$(basename "$f")"

    # 同名の実ファイルが存在する場合、.backupを付与して退避
    if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
      echo "Backing up existing file: $target_file"
      mv "$target_file" "${target_file}.backup"
    fi

    # 既にシンボリックリンクが存在する場合は上書き
    if [ -L "$target_file" ]; then
      echo "Removing existing symlink: $target_file"
      rm "$target_file"
    fi

    # シンボリックリンクを貼る
    ln -snfv "$f" "$target_file"
  done
}

# Function to handle directories with symbolic links
function create_symbolic_links_for_directories() {
  local source_dir="$1"
  local target_dir="$2"

  for dir in "$source_dir"/*/; do
    local dirname=$(basename "$dir")
    local symlink_target="$dir"
    local symlink_path="$target_dir/$dirname"

    if [ -d "$symlink_path" ] && [ ! -L "$symlink_path" ]; then
      echo "Backing up existing directory: $symlink_path"
      mv "$symlink_path" "${symlink_path}.backup"
    fi

    if [ -L "$symlink_path" ]; then
      echo "Removing existing symlink: $symlink_path"
      rm "$symlink_path"
    fi

    ln -s "$symlink_target" "$symlink_path"
    echo "Created symlink: $symlink_path -> $symlink_target"
  done
}
