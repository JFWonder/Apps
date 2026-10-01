# Elevar privilégios se não for administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell "-ExecutionPolicy Bypass -Command `"& {iwr -useb '$($PSCommandPath)' | iex}`"" -Verb RunAs
    exit
}

# ===== Ativar Administrator =====
Enable-LocalUser -Name "Administrator"
$senha = Read-Host "Coloca a Password para a conta Administrator" -AsSecureString
Set-LocalUser -Name "Administrator" -Password $senha

# ===== Wallpapers =====
$dest = "C:\Windows"
$wallpaper1 = "https://jfwonder.github.io/Apps/wallpaper_wondercom.png"
$wallpaper2 = "https://jfwonder.github.io/Apps/wallpaper_wondertrade.png"

Invoke-WebRequest -Uri $wallpaper1 -OutFile "$dest\wallpaper_wondercom.png"
Invoke-WebRequest -Uri $wallpaper2 -OutFile "$dest\wallpaper_wondertrade.png"

Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$dest\wallpaper_wondercom.png"
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters /f

# ===== Instalação de apps via Winget =====
$apps = @(
    "Google.Chrome",
    "Notepad++.Notepad++",
    "PuTTY.PuTTY",
    "Dell.CommandUpdate",
    "TheDocumentFoundation.LibreOffice",
    "Citrix.Workspace",
    "7zip.7zip"
)

foreach ($app in $apps) {
    winget install --id=$app -e --exact --silent --accept-package-agreements --accept-source-agreements
}
