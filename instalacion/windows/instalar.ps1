<#
  Instalacion completa en Windows, paso por paso. Lo ejecuta instalar-windows.cmd
  (doble clic). Se puede volver a ejecutar: revisa que falta y sigue desde ahi.
    - Si Ubuntu no esta instalado: paso 1 (WSL + Ubuntu + usuario de Ubuntu).
    - Despues: paso 2 (Git, Docker, Claude Code, herdr y el proyecto).
#>
$ErrorActionPreference = "Stop"
$Distro = "Ubuntu-24.04"
$Here   = Split-Path -Parent $PSCommandPath

function Get-WslDistros {
    try { (wsl.exe -l -q 2>$null) -replace "`0", "" | Where-Object { $_.Trim() -ne "" } }
    catch { @() }
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host " Instalacion del curso - El tablero del director" -ForegroundColor Cyan
Write-Host " No cierres esta ventana hasta que diga 'Listo' o te pida reiniciar." -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

if (-not ((Get-WslDistros) -contains $Distro)) {
    Write-Host ""
    Write-Host "PASO 1 de 2: Ubuntu (WSL)" -ForegroundColor Cyan
    & (Join-Path $Here "1-instalar-wsl.ps1")
    # 0 = Ubuntu listo; cualquier otro = reinicio pendiente o error (el paso 1 ya explico que hacer)
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    if (-not ((Get-WslDistros) -contains $Distro)) {
        Write-Host ""
        Write-Host "Ubuntu todavia no esta listo. Reinicia Windows y vuelve a dar doble clic" -ForegroundColor Yellow
        Write-Host "a instalar-windows. Si sigue igual, avisa al instructor." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "PASO 2 de 2: Git, Docker, Claude Code, herdr y el proyecto" -ForegroundColor Cyan
& (Join-Path $Here "2-configurar-docker.ps1")
exit $LASTEXITCODE
