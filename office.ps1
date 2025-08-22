# ===== Instalação de setups .exe =====

# Caminhos ou URLs dos setups
$office1 = "https://jfwonder.github.io/Apps/officesetup.exe"
$office2 = "https://jfwonder.github.io/Apps/officetools.exe"

# Caminho temporário para guardar os setups
$tempPath = "$env:TEMP"

# Função para baixar e executar setup silenciosamente
function Install-Exe($url, $filename, $args="/quiet /norestart") {
    $destFile = Join-Path $tempPath $filename
    Invoke-WebRequest -Uri $url -OutFile $destFile
    Start-Process -FilePath $destFile -ArgumentList $args -Wait
}

# Executar os setups
Install-Exe $office1 "officesetup.exe"
Install-Exe $office2 "officetools.exe"
