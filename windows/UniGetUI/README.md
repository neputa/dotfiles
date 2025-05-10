# UniGetUIの設定およびアプリのインストール方法

## インストールアプリリストのインポート

### インポートするファイルの場所

- エクスプローラ
  - %USERPROFILE%\.dotfiles\windows\UniGetUI
- Powershell
  - $HOME\.dotfiles\windows\UniGetUI

### ファイルのインポート

- UniGetUIを起動する
- 画面左の「パッケージバンドル」>「バンドルを開く」をクリックする
- 「インポートするファイルの場所」にある「packagesBundle.ubundle」を選択する

## アプリケーションのインストール

- 画面左の「パッケージバンドル」をクリックする
- インストールしたいアプリあるいは全部チェックを選択する
- 「選択したものをインストール」をクリックする

## アプリケーションインストール後に行うこと

### C compiler のセットアップ

- Neovimのプラグインで使用する
- [MSYS2](https://www.msys2.org/#installation) からインストーラをダウンロードし、インストール
- C:\tools\msys64\msys2.exe からツールを起動
- 以下コマンドでgccをインストール

```bash MSYS2
pacman -Syu
pacman -S mingw-w64-x86_64-gcc
```

- 環境変数パスに以下を追加
- C:\tools\msys64\mingw64\bin

### WSL Ubuntu

- PowershellでUbuntuをインストールする

```powershell
wsl --install
wsl -d Ubuntu
This might take a while...
Create a default Unix user account: takum
New password:
Retype new password:
passwd: password updated successfully
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```

### IME

コマンドではできないため、設定から行う

- 時刻と言語 > 言語と地域 > Microsoft IME > キーとタッチのカスタマイズ > キーの割り当て
  - 各キー/キーの組み合わせに好みの機能を割り当てます → オンにする
  - 無変換キー → IME-オフ
  - 変換キー → IME-オン

### Windowsセキュリティ

- GoogleDriveにあるdefender_exclusions.txtを参照し、Windowsセキュリティの除外設定を行う
- .regファイルでレジストリ更新を行うのはリスクがあるので今のところこの方法で

### SSH

- メールアドレスが含まれるため、Joplinに記載したノートを参照してgithubとconoha用の鍵を生成し、サービス側に登録する

