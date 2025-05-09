#!/bin/bash

copy_file_with_backup() {
  local src="$1"
  local dest="$2"

  # Check if the source file exists
  if [[ ! -f "$src" ]]; then
    echo "Error: Source file '$src' does not exist."
    return 1
  fi

  # If the destination file exists, rename it with a .backup suffix
  if [[ -f "$dest" ]]; then
    local backup="${dest}.backup"
    echo "Backing up existing file: $dest -> $backup"
    sudo mv "$dest" "$backup"
  fi

  # Copy the source file to the destination
  echo "Copying file: $src -> $dest"
  sudo cp "$src" "$dest"
}
