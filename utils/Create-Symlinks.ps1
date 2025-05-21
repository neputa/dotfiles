function Create-Symlinks {
    param (
        [string]$SourceFolder,
        [string]$TargetFolder
    )

    # create symboliklink for directories
    Get-ChildItem -Directory $SourceFolder | ForEach-Object {
        $SourcePath = $_.FullName
        $TargetPath = Join-Path -Path $TargetFolder -ChildPath $_.Name

        if (Test-Path $TargetPath) {
            $TargetItem = Get-Item -Path $TargetPath -ErrorAction SilentlyContinue

            # check a existing symboliklink or not
            if ($TargetItem -and $TargetItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                Remove-Item -Path $TargetPath -Force
            } else {
                Rename-Item -Path $TargetPath -NewName "$($TargetPath).backup"
            }
        }

        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
    }

    # create symboliklink for files
    Get-ChildItem -File -Path $SourceFolder | Where-Object { $_.Name -match '^[._]' } | ForEach-Object {
        $SourcePath = $_.FullName
        $TargetPath = Join-Path -Path $HOME -ChildPath $_.Name

        if (Test-Path $TargetPath) {
            $TargetItem = Get-Item -Path $TargetPath -ErrorAction SilentlyContinue

            # check a existing symboliklink or not
            if ($TargetItem -and $TargetItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                Remove-Item -Path $TargetPath -Force
            } else {
                Rename-Item -Path $TargetPath -NewName "$($TargetPath).backup"
            }
        }

        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
    }
}

function Create-Single-Symlink {
    param (
        [string]$SourcePath,
        [string]$TargetPath
    )

    if (Test-Path $TargetPath) {
        $TargetItem = Get-Item -Path $TargetPath -ErrorAction SilentlyContinue

        # check a existing symboliklink or not
        if ($TargetItem -and $TargetItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item -Path $TargetPath -Force
        } else {
            Rename-Item -Path $TargetPath -NewName "$($TargetPath).backup"
        }
    }

    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
}

