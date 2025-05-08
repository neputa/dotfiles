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
        Write-Host "$WingetId is not installed. install WingetId..."
        winget install --id=$WingetId -e
        Write-Host "done!"
    } else {
        Write-Host "$WingetId is already installed."
    }
}
