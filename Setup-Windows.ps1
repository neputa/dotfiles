$GitRepositoryHost = "https://github.com"
$GitUserName = "neputa"
$GitRepositoryUri = "{0}/{1}/dotfiles" -f $GitRepositoryHost, $GitUserName
$GitBranch = "main"
$DotfilesFolderName = ".dotfiles"
$DotfilesFolderPath = Join-Path -Path $HOME -ChildPath $DotfilesFolderName

# -=-=-=- Git and Others -=-=-=-
# winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "wingetis not installed. install it from here:"
    Write-Host "https://learn.microsoft.com/ja-jp/windows/package-manager/winget/"
    exit 1
}

# git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "GIt is not installed. I install it by winget."
    winget install --id Git.Git -e
}

# check $DotfilesFolderPath
if (Test-Path $DotfilesFolderPath) {
    Write-Host "clean up existing repository"
    git -C $DotfilesFolderPath clean -fdx
    git -C $DotfilesFolderPath fetch origin $GitBranch
    git -C $DotfilesFolderPath reset --hard origin/$GitBranch
} else {
    Write-Host "clone repostiroy"
    git clone --recursive --branch $GitBranch $GitRepositoryUri $DotfilesFolderPath
}

# import utils scripts
cd $DotfilesFolderPath
. ./utils/Check-And-Install-App.ps1
. ./utils/Create-Symlinks.ps1

# -=-=-=- symboliklink -=-=-=-
Write-Host "create symloliklink..."

$CommonConfigPath = Join-Path -Path $DotfilesFolderPath -ChildPath "common\config"
$WindowsConfigPath = Join-Path -Path $DotfilesFolderPath -ChildPath "windows\config"

Create-Symlinks -SourceFolder $CommonConfigPath -TargetFolder $env:LOCALAPPDATA
Create-Symlinks -SourceFolder $WindowsConfigPath -TargetFolder $env:LOCALAPPDATA

# Terminal
$TerminalConfigPathSource = Join-Path -Path $DotfilesFolderPath -ChildPath "windows\terminal\settings.json"
$TerminalConfigPathTarget = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Create-Single-Symlink -SourcePath $TerminalConfigPathSource -TargetPath $TerminalConfigPathTarget

Write-Host "done!"

# -=-=-=- environment path -=-=-=-
# Visual Studio nuget package directory
[Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "C:\nuget", "Machine")

# applications
$PossiblePaths = @(
    $env:LOCALAPPDATA + "\Programs\UniGetUI\UniGetUI.exe",
    $env:LOCALAPPDATA + "\UniGetUI\UniGetUI.exe",
    "C:\Program Files\UniGetUI\UniGetUI.exe"
)

Check-And-Install-App -PossiblePaths $PossiblePaths -WingetId "MartiCliment.UniGetUI"

# UniGetUIの
Write-Host "innstall apps with UniGetUI:"
Write-Host "$DotfilesFolderPath\windows\UniGetUI\README.md"

Write-Host "done!"
