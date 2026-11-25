<#
  PASO 1 - Instala WSL 2 + Ubuntu en Windows 10 (2004+) / Windows 11.
  Ejecutar en PowerShell NORMAL (no "como administrador"):
      powershell -ExecutionPolicy Bypass -File .\1-instalar-wsl.ps1
  (desde la carpeta instalacion\windows)

  Solo la activacion de componentes de Windows necesita administrador: el script
  abre una ventana elevada para eso y Windows pide permiso (o la clave de un
  administrador). Ubuntu se instala despues en la cuenta normal, porque cada
  distribucion de WSL queda registrada para el usuario de Windows que la instala.
#>
param(
    # Uso interno: lo pasa el propio script a la ventana de administrador
    [switch]$Componentes
)

$ErrorActionPreference = "Stop"
$Distro = "Ubuntu-24.04"

function Test-Admin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# --- Funcion: listar distros (wsl.exe devuelve UTF-16, limpiamos los nulos) ---
function Get-WslDistros {
    try { (wsl.exe -l -q 2>$null) -replace "`0", "" | Where-Object { $_.Trim() -ne "" } }
    catch { @() }
}

function Write-AvisoActualizarWindows {
    Write-Host ""
    Write-Host "AVISO: tu version de Windows no reconoce los comandos nuevos de WSL." -ForegroundColor Yellow
    Write-Host "  1. Abre Configuracion > Windows Update e instala TODAS las actualizaciones." -ForegroundColor Yellow
    Write-Host "  2. Reinicia Windows." -ForegroundColor Yellow
    Write-Host "  3. Vuelve a ejecutar este paso 1." -ForegroundColor Yellow
}

# =====================================================================
#  Parte de administrador: activa componentes e instala/actualiza WSL.
#  Deja el resultado en $script:codigo:
#  0 = listo, 3010 = hace falta reiniciar, 1 = error.
#  (Las funciones no usan "return" con valores: la salida de wsl.exe se
#   mezclaria con el valor devuelto.)
# =====================================================================
$script:codigo = 0
$script:instalado = $false

function Install-Componentes {
    $script:codigo = 0
    $reiniciar = $false
    $aviso = $false

    Write-Host "Habilitando componentes de Windows (WSL y Plataforma de Maquina Virtual)..." -ForegroundColor Cyan
    foreach ($f in "Microsoft-Windows-Subsystem-Linux", "VirtualMachinePlatform") {
        dism.exe /online /enable-feature /featurename:$f /all /norestart | Out-Null
        if ($LASTEXITCODE -eq 3010) { $reiniciar = $true }
        elseif ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: no se pudo activar $f (codigo $LASTEXITCODE)." -ForegroundColor Red
            Read-Host "Presiona Enter para cerrar esta ventana"
            $script:codigo = 1; return
        }
    }

    Write-Host "Instalando / actualizando WSL..." -ForegroundColor Cyan
    wsl.exe --install --no-distribution
    if ($LASTEXITCODE -ne 0) { $aviso = $true }
    wsl.exe --update
    if ($LASTEXITCODE -ne 0) { $aviso = $true }
    # Puede fallar antes de reiniciar; no importa
    try { wsl.exe --set-default-version 2 *> $null } catch { }

    if ($aviso) {
        Write-AvisoActualizarWindows
        Read-Host "Presiona Enter para cerrar esta ventana"
        $script:codigo = 1; return
    }
    if ($reiniciar) { $script:codigo = 3010 }
}

if ($Componentes) {
    # Estamos en la ventana elevada que abrio la parte normal del script
    Write-Host "Ventana de administrador: se cerrara sola al terminar." -ForegroundColor Cyan
    Install-Componentes
    exit $script:codigo
}

# =====================================================================
#  Parte normal (cuenta del participante)
# =====================================================================

# --- Verificar version de Windows ---
$build = [int](Get-CimInstance Win32_OperatingSystem).BuildNumber
if ($build -lt 19041) {
    Write-Host "ERROR: Se requiere Windows 10 version 2004 (build 19041) o superior. Build actual: $build" -ForegroundColor Red
    Write-AvisoActualizarWindows
    exit 1
}

# --- Si Ubuntu ya esta instalado, no hacer nada ---
if ((Get-WslDistros) -contains $Distro) {
    Write-Host "$Distro ya esta instalado. Sigue con el paso 2." -ForegroundColor Green
    exit 0
}

if (Test-Admin) {
    Write-Host "AVISO: abriste PowerShell como administrador. Si esta no es tu propia cuenta de" -ForegroundColor Yellow
    Write-Host "Windows, cierra esta ventana y ejecuta el script desde una PowerShell normal." -ForegroundColor Yellow
}

function Invoke-Componentes {
    if (Test-Admin) { Install-Componentes; return }
    Write-Host "Se necesita permiso de administrador para activar WSL." -ForegroundColor Cyan
    Write-Host "Windows te preguntara si permites los cambios: responde 'Si'" -ForegroundColor Cyan
    Write-Host "(si tu cuenta no es de administrador, te pedira el usuario y la clave de uno)." -ForegroundColor Cyan
    try {
        $p = Start-Process powershell -Verb RunAs -Wait -PassThru `
            -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Componentes"
        $script:codigo = $p.ExitCode
    } catch {
        Write-Host "ERROR: no se dio el permiso de administrador. Sin el no se puede instalar WSL." -ForegroundColor Red
        Write-Host "Si la computadora es de tu institucion, pide ayuda a tu area de sistemas." -ForegroundColor Red
        $script:codigo = 1
    }
}

function Install-Distro {
    Write-Host ""
    Write-Host "Instalando $Distro en tu cuenta..." -ForegroundColor Cyan
    Write-Host "Al terminar, Ubuntu te pedira crear un usuario en esta misma ventana:" -ForegroundColor Yellow
    Write-Host "  - 'Enter new UNIX username': un nombre corto, en minusculas, sin espacios" -ForegroundColor Yellow
    Write-Host "    ni acentos (por ejemplo: maria)." -ForegroundColor Yellow
    Write-Host "  - 'New password' y 'Retype new password': una contrasena. Al escribirla NO" -ForegroundColor Yellow
    Write-Host "    aparece nada en pantalla; es normal. Anotala." -ForegroundColor Yellow
    Write-Host "  - Cuando veas una linea que termina en  `$  escribe  exit  y presiona Enter." -ForegroundColor Yellow
    Write-Host ""
    wsl.exe --install -d $Distro
    # Listo si Ubuntu quedo registrado en esta cuenta (el codigo de salida es el de la shell)
    $script:instalado = ((Get-WslDistros) -contains $Distro)
}

# --- Componentes: si WSL ya funciona no hace falta pedir administrador ---
$elevado = $false
try { wsl.exe --status *> $null; $wslListo = ($LASTEXITCODE -eq 0) } catch { $wslListo = $false }
if (-not $wslListo) {
    Invoke-Componentes
    $elevado = $true
    if ($script:codigo -eq 1) { exit 1 }
}

# --- Ubuntu, en la cuenta normal ---
if ($script:codigo -ne 3010) {
    Install-Distro
    if (-not $script:instalado -and -not $elevado) {
        # WSL parecia listo pero algo falta: activar componentes y reintentar
        Invoke-Componentes
        if ($script:codigo -eq 1) { exit 1 }
        if ($script:codigo -ne 3010) { Install-Distro }
    }
}
$codigo = $script:codigo
$instalado = $script:instalado

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
if ($instalado) {
    Write-Host " Ubuntu quedo instalado con tu usuario."
    Write-Host " Sigue el paso 2 (si usas instalar-windows, continua solo)."
} else {
    Write-Host " Falta un reinicio para terminar de activar WSL:"
    Write-Host "  1. REINICIA Windows."
    Write-Host "  2. Vuelve a dar doble clic a instalar-windows (o ejecuta otra vez este paso 1)."
    Write-Host " Si ya reiniciaste y vuelve a salir este mensaje, revisa que la"
    Write-Host " virtualizacion este activada (ver 'Problemas comunes' en la guia)."
}
Write-Host "==================================================================" -ForegroundColor Green

if ($instalado) { exit 0 }

$r = Read-Host "Reiniciar ahora? (s/n)"
if ($r -eq "s") { Restart-Computer }
exit 3010
