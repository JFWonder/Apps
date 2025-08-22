# Evita confirmações interativas
$ErrorActionPreference = "Stop"

# Lista de apps a instalar via winget
$apps = @(
    "Google.Chrome",
    "Notepad++.Notepad++",
    "PuTTY.PuTTY",
    "Dell.CommandUpdate",
    "TheDocumentFoundation.LibreOffice",
    "Citrix.Workspace",
    "7zip.7zip"
)

# Instalar cada app
foreach ($app in $apps) {
    Write-Host "Instalando $app..."
    winget install --id=$app -e --exact --silent --accept-package-agreements --accept-source-agreements
}

# Exemplo para instalar driver local (se tens o instalador .exe)
$driverPath = "C:\Caminho\PL23XX-M_LogoDriver_Setup_408_20220725.exe"
if (Test-Path $driverPath) {
    Write-Host "Instalando driver Prolific..."
    Start-Process -FilePath $driverPath -ArgumentList "/S" -Wait
}
