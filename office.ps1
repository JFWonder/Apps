# ===== Baixar e executar setups =====

$office1 = "https://jfwonder.github.io/Apps/officesetup.exe"
$office2 = "https://jfwonder.github.io/Apps/officetools.exe"

$tempPath = [System.IO.Path]::GetTempPath()

function Download-And-Run($url, $filename) {
    $destFile = Join-Path $tempPath $filename
    Write-Output "A baixar $filename..."
    Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing

    if (-Not (Test-Path $destFile)) {
        Write-Error "Falha ao baixar $filename"
        return
    }

    Write-Output "A executar $filename..."
    Start-Process -FilePath $destFile -Wait
    Write-Output "$filename executado."
}

# Executar os setups
Download-And-Run $office1 "officesetup.exe"
Download-And-Run $office2 "officetools.exe"
