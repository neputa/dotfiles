@echo off
setlocal enabledelayedexpansion

set BACKUPDIR=%USERPROFILE%\Documents\RegBackups
for /f "tokens=*" %%I in ('PowerShell -Command "(Get-Date).ToString(\"yyyyMMdd_HHmmss\")"') do set DATETIME=%%I
if "%DATETIME%"=="" (
    echo Error retrieving date and time.
    pause
    exit /b 1
)
set DATE=%DATETIME:~0,8%
set TIME=%DATETIME:~9,6%
mkdir "%BACKUPDIR%" 2>nul

REM Delete old backup files (older than 7 days)
PowerShell -Command "Get-ChildItem -Path '%BACKUPDIR%' -Filter '*.reg' | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Force" || (
    echo Error deleting old backup files.
    pause
    exit /b 1
)

echo [%DATE% %TIME%] Backing up HKLM... >> "%BACKUPDIR%\backup.log"
reg export HKLM "%BACKUPDIR%\HKLM_%DATETIME%.reg" /y || (
    echo Error exporting HKLM registry.
    echo [%DATE% %TIME%] Error exporting HKLM registry. >> "%BACKUPDIR%\backup.log"
    pause
    exit /b 1
)

echo [%DATE% %TIME%] Backing up HKCU... >> "%BACKUPDIR%\backup.log"
reg export HKCU "%BACKUPDIR%\HKCU_%DATETIME%.reg" /y || (
    echo Error exporting HKCU registry.
    echo [%DATE% %TIME%] Error exporting HKCU registry. >> "%BACKUPDIR%\backup.log"
    pause
    exit /b 1
)

echo Backup completed successfully.
echo [%DATE% %TIME%] Backup completed successfully. >> "%BACKUPDIR%\backup.log"
endlocal
