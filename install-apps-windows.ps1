$LocalAppDataPath1 = $env:LOCALAPPDATA + "\Programs\UniGetUI\UniGetUI.exe"
$LocalAppDataPath2 = $env:LOCALAPPDATA + "\UniGetUI\UniGetUI.exe"
$LocalAppDataPath3 = "C:\Program Files\UniGetUI\UniGetUI.exe"

$PossiblePaths = @(
    $LocalAppDataPath1,
    $LocalAppDataPath2,
    $LocalAppDataPath3
)

Write-Host "UniGetUIのインストールを確認しています..."
$IsInstalled = $false
foreach ($Path in $PossiblePaths) {
    Write-Host "Checking path: $Path"
    if (Test-Path $Path) {
        $IsInstalled = $true
        break
    }
}

if (-not $IsInstalled) {
    Write-Host "UniGetUIがインストールされていません。インストールを開始します。"
    winget install --id=MartiCliment.UniGetUI -e
    Write-Host "UniGetUIのインストールが完了しました。"
} else {
    Write-Host "UniGetUIは既にインストールされています。"
}
