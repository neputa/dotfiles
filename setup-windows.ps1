$GitRepositoryHost = "https://github.com"
$GitUserName = "neputa"
$GitRepositoryUri = "{0}/{1}/dotfiles" -f $GitRepositoryHost, $GitUserName
$GitBranch = "main"
$DotfilesFolderName = ".dotfiles"
$DotfilesFolderPath = Join-Path -Path $HOME -ChildPath $DotfilesFolderName
$DotfilesInstallScriptPath = Join-Path -Path $DotfilesFolderPath -ChildPath "config/install-dotfiles-windows.ps1"
$AppsInstallScriptPath = Join-Path -Path $DotfilesFolderPath -ChildPath "apps/install-apps-windows.ps1"

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

# $DotfilesInstallScriptPathの確認
if (Test-Path $DotfilesInstallScriptPath) {
    Write-Host "dotfilesのインストールスクリプトを実行します。"
    & $DotfilesInstallScriptPath $DotfilesFolderPath
} else {
    Write-Host "エラー: $DotfilesInstallScriptPath が存在しません。"
    exit 1
}

# $AppsInstallScriptPathの確認
if (Test-Path $AppsInstallScriptPath) {
    Write-Host "アプリケーションのインストールスクリプトを実行します。"
    & $AppsInstallScriptPath
} else {
    Write-Host "エラー: $AppsInstallScriptPath が存在しません。"
    exit 1
}

# 環境変数設定
# Write-Host "環境変数を設定します。"
[System.Environment]::SetEnvironmentVariable("LAZYGIT_SHELL", "pwsh -c", "User")
$Env:LAZYGIT_SHELL = "pwsh -c"

Write-Host "LAZYGIT_SHELL has been set to 'pwsh -c'"

# UniGetUIの設定案内
Write-Host "UniGetUIにインストールアプリリストをインポートしてください:"
Write-Host "$DotfilesFolderPath\windows\UniGetUI\README.md"

Write-Host "処理が完了しました。"