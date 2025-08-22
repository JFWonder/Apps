# ===== Instalação de setups .exe ou .msi =====

$office1 = "https://jfwonder.github.io/Apps/officesetup.exe"
$office2 = "https://jfwonder.github.io/Apps/officetools.exe"

$tempPath = [System.IO.Path]::GetTempPath()

function Install-Setup($url, $filename) {
    $destFile = Join-Path $tempPath $filename
    Write-Output "A baixar $filename..."
    
    # Download do ficheiro
    Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing
    if (-Not (Test-Path $destFile)) {
        Write-Error "Falha ao baixar $filename"
        return
    }

    # Detectar tipo de ficheiro
    $ext = [System.IO.Path]::GetExtension($destFile).ToLower()
    
    switch ($ext) {
        ".exe" {
            $args = @("/quiet","/norestart")
        }
        ".msi" {
            $args = @("/quiet","/norestart","/i")
        }
        default {
            Write-Error "Tipo de ficheiro não suportado: $ext"
            return
        }
    }

    # Instalação
    Write-Output "A instalar $filename..."
    Start-Process -FilePath $destFile -ArgumentList $args -Wait
    Write-Output "$filename instalado com sucesso."
}

# Executar setups
Install-Setup $office1 "officesetup.exe"
Install-Setup $office2 "officetools.exe"
