

# ===== Instalação de apps via Winget =====
$apps = @(
    "Google.Chrome",
    "Notepad++.Notepad++",
    "PuTTY.PuTTY",
    "Adobe.Acrobat.Reader.64-bit",
    "Dell.CommandUpdate",
    "Citrix.Workspace",
    "Mozilla.Firefox",
    "7zip.7zip",
    "Microsoft.Office"
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
