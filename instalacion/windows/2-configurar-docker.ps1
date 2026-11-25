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
    Write-Host "ERROR: Ubuntu no tiene el usuario del curso. Vuelve a dar doble clic a instalar-windows; si sigue igual, avisa al instructor." -ForegroundColor Red
    exit 1
}

# Convierte una ruta de Windows a como la ve Ubuntu (C:\Users\Jose -> /mnt/c/Users/Jose).
# Se calcula aqui y no con "wslpath": PowerShell 5.1 descompone los acentos al leer
# la respuesta de Ubuntu (por ejemplo, un usuario "Jose" con acento). Las comillas
# simples se escapan porque la ruta va dentro de '...' en bash.
function ConvertTo-WslPath([string]$Ruta) {
    $completa = [IO.Path]::GetFullPath($Ruta)
    if ($completa -notmatch '^([A-Za-z]):\\(.*)$') {
        throw "La carpeta del curso debe estar en un disco de esta computadora (por ejemplo C:), no en una unidad de red: $completa"
    }
    ("/mnt/" + $Matches[1].ToLower() + "/" + ($Matches[2] -replace '\\', '/')).TrimEnd('/') -replace "'", "'\''"
}

# Rutas vistas desde Ubuntu
$Instalacion  = Split-Path -Parent $Here
$Curso        = Split-Path -Parent $Instalacion
$WslPath      = ConvertTo-WslPath $Here                                   # instalacion\windows
$ProyectoPath = ConvertTo-WslPath (Join-Path $Instalacion "proyecto")     # compartido con Mac
$ComunPath    = ConvertTo-WslPath (Join-Path $Instalacion "comun")        # compartido con Mac
$AlumnosPath  = ConvertTo-WslPath (Join-Path $Curso "alumnos")

Write-Host "Instalando Docker dentro de $Distro (pedira tu clave de Ubuntu si hace falta)..." -ForegroundColor Cyan
# sed elimina finales de linea de Windows (CRLF) por si git/editor los convirtio
wsl.exe -d $Distro -u root -- bash -c "sed 's/\r$//' '$WslPath/wsl/setup-docker.sh' | bash -s -- '$LinuxUser'"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la instalacion de Docker." -ForegroundColor Red; exit 1 }

# Reiniciar WSL para activar systemd y el grupo docker
Write-Host "Reiniciando WSL..." -ForegroundColor Cyan
wsl.exe --shutdown
Start-Sleep -Seconds 3

Write-Host "Instalando / actualizando Claude Code y herdr..." -ForegroundColor Cyan
wsl.exe -d $Distro -- bash -c "sed 's/\r$//' '$ComunPath/setup-claude.sh' | bash"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la instalacion de Claude Code." -ForegroundColor Red; exit 1 }

Write-Host "Copiando el proyecto y los archivos de ejemplo a ~/proyecto-python y arrancando la aplicacion..." -ForegroundColor Cyan
wsl.exe -d $Distro -- bash -c "sed 's/\r$//' '$ComunPath/build-proyecto.sh' | bash -s -- '$ProyectoPath' '$AlumnosPath'"
if ($LASTEXITCODE -ne 0) { Write-Host "Fallo la construccion del contenedor." -ForegroundColor Red; exit 1 }

# --- Accesos directos al proyecto (Escritorio y carpeta del curso) ---
function New-AccesosDirectos([string]$Carpeta) {
    try {
        New-Item -ItemType Directory -Force $Carpeta | Out-Null
        $sh = New-Object -ComObject WScript.Shell

        # Ubuntu ya ubicado en la carpeta del proyecto: solo falta escribir "claude"
        $lnk = $sh.CreateShortcut((Join-Path $Carpeta "Curso - Terminal.lnk"))
        $lnk.TargetPath       = Join-Path $env:WINDIR "System32\wsl.exe"
        $lnk.Arguments        = "-d $Distro --cd /home/$LinuxUser/proyecto-python"
        $lnk.WorkingDirectory = $env:USERPROFILE
        $lnk.Description      = "Abre Ubuntu en el proyecto del curso. Para empezar escribe: claude"
        $lnk.Save()

        # Los archivos del proyecto en el Explorador
        $lnk = $sh.CreateShortcut((Join-Path $Carpeta "Curso - Archivos del proyecto.lnk"))
        $lnk.TargetPath  = Join-Path $env:WINDIR "explorer.exe"
        $lnk.Arguments   = "\\wsl$\$Distro\home\$LinuxUser\proyecto-python"
        $lnk.Description = "Archivos del proyecto del curso (dentro de Ubuntu)"
        $lnk.Save()

        # La aplicacion en el navegador
        Set-Content -Path (Join-Path $Carpeta "Curso - Mi tablero.url") -Encoding ASCII `
            -Value "[InternetShortcut]`r`nURL=http://localhost:8000"
    } catch {
        Write-Host "AVISO: no se pudieron crear los accesos directos en $Carpeta" -ForegroundColor Yellow
    }
}
Write-Host "Creando accesos directos en el Escritorio y en la carpeta del curso..." -ForegroundColor Cyan
New-AccesosDirectos ([Environment]::GetFolderPath("Desktop"))
New-AccesosDirectos $Curso

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
Write-Host " Listo. Tu aplicacion ya se ve en el navegador:  http://localhost:8000"
Write-Host ""
Write-Host " En tu Escritorio quedaron tres accesos directos:"
Write-Host "   Curso - Terminal               abre Ubuntu en el proyecto; escribe: claude"
Write-Host "   Curso - Archivos del proyecto  los archivos que va creando Claude"
Write-Host "   Curso - Mi tablero             tu aplicacion en el navegador"
Write-Host " Los archivos de ejemplo estan en ~/proyecto-python/archivos_ejemplo"
Write-Host " Desde VS Code: 'code ~/proyecto-python' (extension WSL)."
Write-Host "==================================================================" -ForegroundColor Green
