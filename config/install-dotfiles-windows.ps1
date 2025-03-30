param (
    [string]$DotfilesFolderPath
)

$WorkFolder = Join-Path -Path $DotfilesFolderPath -ChildPath "config"
Set-Location -Path $WorkFolder

$SourceFolder = Join-Path -Path $WorkFolder -ChildPath ".config"
$TargetFolder = $env:LOCALAPPDATA

Get-ChildItem -Directory $SourceFolder | ForEach-Object {
    $SourcePath = $_.FullName
    $TargetPath = Join-Path -Path $TargetFolder -ChildPath $_.Name

    if (Test-Path $TargetPath) {
        $TargetItem = Get-Item -Path $TargetPath -ErrorAction SilentlyContinue
        # シンボリックリンクかどうかを確認
        if ($TargetItem -and $TargetItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item -Path $TargetPath -Force
        } else {
            Rename-Item -Path $TargetPath -NewName "$($TargetPath).backup"
        }
    }

    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
}

Write-Host "シンボリックリンクの作成が完了しました。"
