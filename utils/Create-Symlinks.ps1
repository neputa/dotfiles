function Create-Symlinks {
    param (
        [string]$SourceFolder,
        [string]$TargetFolder
    )

    # フォルダーを対象にシンボリックリンクを作成
    Get-ChildItem -Directory $SourceFolder | ForEach-Object {
        $SourcePath = $_.FullName
        $TargetPath = Join-Path -Path $TargetFolder -ChildPath $_.Name
        Create-Symlink -SourcePath $SourcePath -TargetPath $TargetPath
    }

    # ファイルを対象にシンボリックリンクを作成
    Get-ChildItem -File -Path $SourceFolder -Filter ".*" | ForEach-Object {
        $SourcePath = $_.FullName
        $TargetPath = Join-Path -Path $HOME -ChildPath $_.Name
        Create-Symlink -SourcePath $SourcePath -TargetPath $TargetPath
    }
}