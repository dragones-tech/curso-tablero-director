<#
  PASO 2 - Instala git, Docker Engine, Claude Code y herdr dentro de Ubuntu (WSL) y construye el
  contenedor de Python + SQLite. No necesita Docker Desktop.
  Ejecutar en PowerShell (no requiere administrador):
      powershell -ExecutionPolicy Bypass -File .\2-configurar-docker.ps1
  (desde la carpeta instalacion\windows)
#>

$ErrorActionPreference = "Stop"
$Distro = "Ubuntu-24.04"
$Here   = Split-Path -Parent $PSCommandPath

function Get-WslDistros {
    try { (wsl.exe -l -q 2>$null) -replace "`0", "" | Where-Object { $_.Trim() -ne "" } }
    catch { @() }
}

if (-not ((Get-WslDistros) -contains $Distro)) {
    Write-Host "ERROR: $Distro no esta instalado. Ejecuta primero .\1-instalar-wsl.ps1" -ForegroundColor Red
    exit 1
}

# Usuario por defecto de Ubuntu (el que se creo al abrirlo por primera vez)
$LinuxUser = (wsl.exe -d $Distro -- whoami).Trim()
if ($LinuxUser -eq "root" -or [string]::IsNullOrEmpty($LinuxUser)) {
    Write-Host "ERROR: Abre 'Ubuntu 24.04' desde el menu Inicio y crea tu usuario antes de continuar." -ForegroundColor Red
    exit 1
}

# Ruta de esta carpeta vista desde Linux (C:\... -> /mnt/c/...)
$WslPath = (wsl.exe -d $Distro -- wslpath -a ($Here -replace '\\', '/')).Trim()
# El proyecto Docker esta en la carpeta de arriba (instalacion\proyecto), compartido con Mac
$ProyectoPath = (wsl.exe -d $Distro -- wslpath -a ((Split-Path -Parent $Here) -replace '\\', '/')).Trim() + "/proyecto"
# Archivos de los alumnos: carpeta alumnos en la raiz del curso
$AlumnosPath = (wsl.exe -d $Distro -- wslpath -a ((Split-Path -Parent (Split-Path -Parent $Here)) -replace '\\', '/')).Trim() + "/alumnos"

Write-Host "Instalando Docker dentro de $Distro (pedira tu clave de Ubuntu si hace falta)..." -ForegroundColor Cyan
# sed elimina finales de linea de Windows (CRLF) por si git/editor los convirtio
wsl.exe -d $Distro -u root -- bash -c "sed 's/\r$//' '$WslPath/wsl/setup-docker.sh' | bash -s -- '$LinuxUser'"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la instalacion de Docker." -ForegroundColor Red; exit 1 }

# Reiniciar WSL para activar systemd y el grupo docker
Write-Host "Reiniciando WSL..." -ForegroundColor Cyan
wsl.exe --shutdown
Start-Sleep -Seconds 3

Write-Host "Instalando / actualizando Claude Code y herdr..." -ForegroundColor Cyan
wsl.exe -d $Distro -- bash -c "sed 's/\r$//' '$WslPath/wsl/setup-claude.sh' | bash"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la instalacion de Claude Code." -ForegroundColor Red; exit 1 }

Write-Host "Copiando el proyecto y los archivos de ejemplo a ~/proyecto-python y arrancando la aplicacion..." -ForegroundColor Cyan
wsl.exe -d $Distro -- bash -c "sed 's/\r$//' '$WslPath/wsl/build-proyecto.sh' | bash -s -- '$ProyectoPath' '$AlumnosPath'"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la construccion del contenedor." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
Write-Host " Listo. Tu aplicacion ya se ve en el navegador:  http://localhost:8000"
Write-Host " Para trabajar abre Ubuntu y ejecuta:"
Write-Host "   cd ~/proyecto-python"
Write-Host "   claude"
Write-Host " Los archivos de ejemplo estan en ~/proyecto-python/archivos_ejemplo"
Write-Host " Desde VS Code: 'code ~/proyecto-python' (extension WSL)."
Write-Host "==================================================================" -ForegroundColor Green
