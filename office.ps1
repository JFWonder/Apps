# ===== Instalação de setups .exe =====

$office1 = "https://jfwonder.github.io/Apps/officesetup.exe"
$office2 = "https://jfwonder.github.io/Apps/officetools.exe"

$tempPath = [System.IO.Path]::GetTempPath()

function Install-Exe($url, $filename, $args="/quiet /norestart") {
    $destFile = Join-Path $tempPath $filename
    Write-Output "A baixar $filename..."
    Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing
    Write-Output "A instalar $filename..."
    Start-Process -FilePath $destFile -ArgumentList $args -Wait -PassThru
    Write-Output "$filename instalado."
}

Install-Exe $office1 "officesetup.exe"
Install-Exe $office2 "officetools.exe"
