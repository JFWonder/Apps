

# ===== Instalação de apps via Winget =====
$apps = @(
    "Google.Chrome",
    "Notepad++.Notepad++",
    "PuTTY.PuTTY",
    "Adobe.Acrobat.Reader.64-bit",
    "Citrix.Workspace",
    "Mozilla.Firefox",
    "7zip.7zip",
    "PDF24.PDF24Creator"
)

foreach ($app in $apps) {

    if (winget list --id $app --exact | Select-String $app) {

        Write-Host "[UPDATE] $app" -ForegroundColor Cyan

        winget upgrade `
            --id $app `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements
    }
    else {

        Write-Host "[INSTALL] $app" -ForegroundColor Yellow

        winget install `
            --id $app `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements
    }
}

# ===== Instalação do Office =====

$OfficeSetup = ".\OfficeSetup.exe"
if (Test-Path $OfficeSetup) { 
Write-Host "[INSTALL] Microsoft Office" -ForegroundColor Yellow
Start-Process `
-FilePath $OfficeSetup `
-ArgumentList "/quiet" `
-Wait
}
else {
Write-Host "[ERRO] OfficeSetup.exe não encontrado em $PSScriptRoot" -ForegroundColor Red
}
