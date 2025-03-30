$PossiblePaths = @(
    Join-Path -Path $env:LOCALAPPDATA -ChildPath "Programs\UniGetUI\UniGetUI.exe",
    Join-Path -Path $env:LOCALAPPDATA -ChildPath "UniGetUI\UniGetUI.exe",
    "C:\Program Files\UniGetUI\UniGetUI.exe"
)

$IsInstalled = $false
foreach ($Path in $PossiblePaths) {
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
