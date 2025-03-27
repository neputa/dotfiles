# My initial configuration procedure for Ubuntu

- このリポジトリをホームディレクトリにクローン
- setup scriptsに権限付与
- 各スクリプトを実行

```bash
cd ~
git clone https://github.com/neputa/dotfiles.git
cd ./dotfiles
find ./setup-scripts -type f -exec chmod +x {} +
```

## apps for lazyvim (Neovim)

```bash
$ sudo add-apt-repository ppa:neovim-ppa/stable -y
$ sudo add-apt-repository ppa:neovim-ppa/unstable -y
$ sudo apt update
$ sudo apt install make gcc ripgrep unzip git xclip neovim
```

## Japanese localization

```bash
$ sudo apt update && sudo apt upgrade
$ sudo apt -y install language-pack-ja
$ sudo update-locale LANG=ja_JP.UTF8
```

- After restarting with Ctrl + d, check

```bash
$ locale
LANG=ja_JP.UTF8
...
```

- japanease manuaru

```bash
$ sudo apt -y install manpages-ja manpages-ja-dev
```

## Web sites and repositories used as references

- [felipecrs/dotfiles: Bootstrap your Ubuntu in a single command!](https://github.com/felipecrs/dotfiles)
- [victoriadrake/dotfiles: Dotfiles and automagic set-up scripts for Linux flavours](https://github.com/victoriadrake/dotfiles)
