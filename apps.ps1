

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

    if (winget list --id $app --exact | Select-String -SimpleMatch $app) {

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

# ===== Idioma do Windows: Português (Portugal) =====

$resposta = Read-Host "Queres alterar o idioma do Windows para Português (Portugal)? (S/N)"

if ($resposta -match '^(S|SIM)$') {
    try {
        # Instala o pacote de idioma, se o comando estiver disponível.
        if (Get-Command Install-Language -ErrorAction SilentlyContinue) {
            Install-Language -Language pt-PT -ErrorAction Stop
        }
        else {
            throw "Install-Language não está disponível nesta versão do Windows."
        }

        $listaIdiomas = New-WinUserLanguageList -Language "pt-PT"
        Set-WinUserLanguageList -LanguageList $listaIdiomas -Force
        Set-WinUILanguageOverride -Language "pt-PT"
        Set-Culture -CultureInfo "pt-PT"
        Set-WinSystemLocale -SystemLocale "pt-PT"
        Set-WinHomeLocation -GeoId 193

        Write-Host "Idioma configurado para Português (Portugal). Reinicia o PC para aplicar todas as alterações." -ForegroundColor Green
    }
    catch {
        Write-Host "Não foi possível alterar o idioma: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Confirma que estás a executar o PowerShell como administrador e que esta versão do Windows suporta a instalação do idioma." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Idioma do Windows mantido sem alterações." -ForegroundColor Gray
}

# ===== Instalação do Office =====

#$OfficeSetup = "$env:TEMP\OfficeSetup.exe"

#Invoke-WebRequest `
  #  -Uri "https://raw.githubusercontent.com/JFWonder/Apps/main/OfficeSetup.exe" `
  #  -OutFile $OfficeSetup

#Start-Process $OfficeSetup -Wait


