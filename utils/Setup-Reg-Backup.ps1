# reg_backup.bat を dotfiles ディレクトリに配置し、タスクスケジューラに登録するスクリプト

# タスク名
$TaskName = "RegistryBackup"

# バッチファイルのパス
$BatchFilePath = "$env:USERPROFILE\.dotfiles\windows\scripts\reg_backup.bat"

# トリガー（毎日22時に実行）
$Trigger = New-ScheduledTaskTrigger -Daily -At "22:00"

# アクション（バッチファイルを実行）
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$BatchFilePath`""

# タスクの設定
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# タスクを登録
try {
  Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action $Action -Principal $principal -Settings $Settings -Description "Daily registry backup at 22:00"
  Write-Host "Task registered successfully."
}
catch {
  Write-Error "Failed to register the task: $_"
}
