# My dotfiles for Ubuntu and Windows

This is my personal dotfiles repository.

## Supported environments

- Ubuntu 22.04 LTS or later
- Windows 11 or later

## Installation method

### Ubuntu

- Run the following in a terminal.

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/neputa/dotfiles/refs/heads/main/setup_ubuntu.sh)"
```

- The Japanese language pack has been added using the setup script, and the language settings have been changed.
- If you want to install the Japanese manual, please execute the following command after rebooting.

```bash
sudo apt -y install manpages-ja manpages-ja-dev
```

### Windows

- Start Powershell with administrator privileges and run the following command.

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/neputa/dotfiles/refs/heads/main/Setup-Windows.ps1").Content
```

- There are cases where the execution of scripts is restricted by PowerShell's execution policy.
- In such cases, you can temporarily disable the execution policy using the following command:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

- After the script has run, the location of the UniGetUI README Path will be displayed, so please follow the instructions to install the additional application.

## Installed settings and apps

### Ubuntu

- Applications
  - curl
  - fcitx5
  - gcc
  - make
  - ripgrep
  - tree
  - unzip
  - wget
  - xclip
  - language-pack-japanese
  - lazygit
  - neovim
  - node.js
    - fnm
    - pnpm

- settings
  - .bashrc
  - .gitconfig
  - .editorconfig
  - HackGen Font
  - lazygit
  - neovim

### Windows

The application is installed manually using UniGetUI after the setup script has been processed.

- Applications
  - UniGetUI

- settings
  - .gitconfig
  - .editorconfig
  - lazygit
  - neovim

