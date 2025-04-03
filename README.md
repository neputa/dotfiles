# My dotfiles for Ubuntu and Windows

This is my personal dotfiles repository.

## Supported environments

- Ubuntu 22.04 LTS or later
- Windows 11 or later

## Installation method

### Ubuntu

- Run the following in a terminal.

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/neputa/dotfiles/refs/heads/main/setup.sh)"
```

Windows

- Start Powershell with administrator privileges and run the following command.

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/neputa/dotfiles/refs/heads/main/setup-windows.ps1").Content
```

- There are cases where the execution of scripts is restricted by PowerShell's execution policy.
- In such cases, you can temporarily disable the execution policy using the following command:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

- After the script has run, the location of the UniGetUI README Path will be displayed, so please follow the instructions to install the additional application.

## Japanese localization

- The Japanese language pack has been added using the setup script, and the language settings have been changed.
- If you want to install the Japanese manual, please execute the following command after rebooting.

```bash
$ sudo apt -y install manpages-ja manpages-ja-dev
```

## Repositories used as references

- [felipecrs/dotfiles: Bootstrap your Ubuntu in a single command!](https://github.com/felipecrs/dotfiles)
- [victoriadrake/dotfiles: Dotfiles and automagic set-up scripts for Linux flavours](https://github.com/victoriadrake/dotfiles)