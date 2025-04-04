$GitRepositoryHost = "https://github.com"
$GitUserName = "neputa"
$GitRepositoryUri = "{0}/{1}/dotfiles" -f $GitRepositoryHost, $GitUserName
$GitBranch = "main"
$DotfilesFolderName = ".dotfiles"
$DotfilesFolderPath = Join-Path -Path $HOME -ChildPath $DotfilesFolderName

# -=-=-=- Git関連の処理 -=-=-=-
# wingetのインストール確認
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "wingetがインストールされていません。以下のURLからインストールしてください:"
    Write-Host "https://learn.microsoft.com/ja-jp/windows/package-manager/winget/"
    exit 1
}

# gitのインストール確認
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "gitがインストールされていません。wingetでインストールします。"
    winget install --id Git.Git -e
}

# $DotfilesFolderPathの確認
if (Test-Path $DotfilesFolderPath) {
    Write-Host "既存のリポジトリをクリーンアップします。"
    git -C $DotfilesFolderPath clean -fdx
    git -C $DotfilesFolderPath fetch origin $GitBranch
    git -C $DotfilesFolderPath reset --hard origin/$GitBranch
} else {
    Write-Host "リポジトリをクローンします。"
    git clone --recursive --branch $GitBranch $GitRepositoryUri $DotfilesFolderPath
}

# utilsスクリプトのインポート
cd $DotfilesFolderPath
. ./utils/Check-And-Install-App.ps1
. ./utils/Create-Symlinks.ps1

# -=-=-=- シンボリックリンクの作成 -=-=-=-
Write-Host "シンボリックリンク作成を行います。"

$CommonConfigPath = Join-Path -Path $DotfilesFolderPath -ChildPath "common\config"
$WindowsConfigPath = Join-Path -Path $DotfilesFolderPath -ChildPath "windows\config"

Create-Symlinks -SourceFolder $CommonConfigPath -TargetFolder $env:LOCALAPPDATA
Create-Symlinks -SourceFolder $WindowsConfigPath -TargetFolder $env:LOCALAPPDATA

Write-Host "シンボリックリンクの作成が完了しました。"

# アプリケーションのインストール
$PossiblePaths = @(
    $env:LOCALAPPDATA + "\Programs\UniGetUI\UniGetUI.exe",
    $env:LOCALAPPDATA + "\UniGetUI\UniGetUI.exe",
    "C:\Program Files\UniGetUI\UniGetUI.exe"
)

Check-And-Install-App -PossiblePaths $PossiblePaths -WingetId "MartiCliment.UniGetUI"

# UniGetUIの設定案内
Write-Host "UniGetUIにインストールアプリリストをインポートしてください:"
Write-Host "$DotfilesFolderPath\windows\UniGetUI\README.md"

Write-Host "処理が完了しました。"
