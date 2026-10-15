# ===== Instala/atualiza as aplicações da lista =====

$apps = @(
    "Google.Chrome",
    "Notepad++.Notepad++",
    "PuTTY.PuTTY",
    "Adobe.Acrobat.Reader.64-bit",
    "Citrix.Workspace",
    "Mozilla.Firefox",
    "7zip.7zip",
    "Google.EarthPro",
    "PDF24.PDF24Creator"
)

foreach ($id in $apps) {
    Write-Host "`nA verificar $id..." -ForegroundColor Cyan

    $lista = & winget list --id $id --exact --accept-source-agreements 2>&1
    $listaOk = $LASTEXITCODE -eq 0

    # Procura o ID exato na coluna de identificador da tabela do Winget.
    $instalada = $false
    if ($listaOk) {
        foreach ($linha in $lista) {
            $colunas = "$linha".Trim() -split '\s{2,}'
            if ($colunas.Count -ge 2 -and $colunas[1] -ieq $id) {
                $instalada = $true
                break
            }
        }
    }

    if ($instalada) {
        Write-Host "[ATUALIZAR] $id" -ForegroundColor Yellow

        & winget upgrade `
            --id $id `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements `
            --disable-interactivity

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$id atualizado (ou já estava atualizado)." -ForegroundColor Green
        }
        else {
            Write-Host "Não foi possível atualizar $id. Código: $LASTEXITCODE" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[INSTALAR] $id" -ForegroundColor Yellow

        & winget install `
            --id $id `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements `
            --disable-interactivity

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$id instalado com sucesso." -ForegroundColor Green
        }
        else {
            Write-Host "Não foi possível instalar $id. Código: $LASTEXITCODE" -ForegroundColor Red
        }
    }
}

# ===== Varredura geral e atualização com confirmação individual =====

Write-Host "`nA procurar atualizações para outras aplicações reconhecidas pelo Winget..." `
    -ForegroundColor Cyan

$saida = & winget upgrade `
    --include-unknown `
    --accept-source-agreements `
    --disable-interactivity 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "O Winget não conseguiu concluir a verificação geral." -ForegroundColor Red
    $saida | ForEach-Object { Write-Host $_ }
    exit 1
}

# Interpreta as linhas da tabela do Winget:
# Nome | ID | Versão instalada | Versão disponível | Fonte
$atualizacoes = foreach ($linha in $saida) {
    $colunas = "$linha".Trim() -split '\s{2,}'

    if (
        $colunas.Count -ge 4 -and
        $colunas[1] -match '^[A-Za-z0-9][A-Za-z0-9._-]*$' -and
        $colunas[1] -ne 'Id' -and
        $colunas[2] -ne 'Version'
    ) {
        [pscustomobject]@{
            Nome            = $colunas[0]
            Id              = $colunas[1]
            VersaoInstalada = $colunas[2]
            VersaoNova      = $colunas[3]
        }
    }
}

if (-not $atualizacoes) {
    Write-Host "Não foram encontradas mais atualizações disponíveis." -ForegroundColor Green
    exit 0
}

foreach ($app in $atualizacoes) {
    Write-Host "`n$($app.Nome) ($($app.Id)): $($app.VersaoInstalada) -> $($app.VersaoNova)" `
        -ForegroundColor Cyan

    $resposta = Read-Host "Queres atualizar esta aplicação? (S/N)"

    if ($resposta -match '^(S|SIM)$') {
        & winget upgrade `
            --id $app.Id `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements `
            --disable-interactivity

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$($app.Nome) atualizado com sucesso." -ForegroundColor Green
        }
        else {
            Write-Host "Falha ao atualizar $($app.Nome). Código: $LASTEXITCODE" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Atualização ignorada: $($app.Nome)." -ForegroundColor Yellow
    }
}
