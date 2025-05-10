@echo off
setlocal enabledelayedexpansion

set BACKUPDIR=%USERPROFILE%\Documents\RegBackups
set DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
set TIME=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
if "%TIME:~0,1%"==" " set TIME=0%TIME:~1%
set DATETIME=%DATE%_%TIME%
mkdir "%BACKUPDIR%" 2>nul

REM 古いバックアップを削除（7日以上前のファイル）
forfiles /p "%BACKUPDIR%" /s /m *.reg /d -7 /c "cmd /c del @path" || (
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
