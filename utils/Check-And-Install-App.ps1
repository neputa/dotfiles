function Check-And-Install-App {
    param (
        [string[]]$PossiblePaths,
        [string]$WingetId
    )

    $IsInstalled = $false
    foreach ($Path in $PossiblePaths) {
        if (Test-Path $Path) {
            $IsInstalled = $true
            break
        }
    }

    if (-not $IsInstalled) {
        Write-Host "$WingetIdがインストールされていません。インストールを開始します。"
        winget install --id=$WingetId -e
        Write-Host "$WingetIdのインストールが完了しました。"
    } else {
        Write-Host "$WingetIdは既にインストールされています。"
    }
}