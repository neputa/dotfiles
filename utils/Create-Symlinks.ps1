function Create-Symlinks {
    param (
        [string]$SourceFolder,
        [string]$TargetFolder
    )

    # フォルダーを対象にシンボリックリンクを作成
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

    # ファイルを対象にシンボリックリンクを作成
    Get-ChildItem -File -Path $SourceFolder -Filter ".*" | ForEach-Object {
        $SourcePath = $_.FullName
        $TargetPath = Join-Path -Path $HOME -ChildPath $_.Name

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
}
