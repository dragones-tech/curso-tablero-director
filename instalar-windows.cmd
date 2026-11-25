@echo off
rem ======================================================================
rem  Instalador del curso "El tablero del director con IA" para Windows.
rem  Uso: doble clic. Se puede volver a abrir las veces que haga falta
rem  (por ejemplo, despues de reiniciar): sigue donde se quedo.
rem
rem  Si este archivo esta dentro de la carpeta del curso, usa esos archivos.
rem  Si se descargo solo, primero baja los materiales del curso de GitHub a
rem  Documentos\curso-tablero-director (o a C:\Users\<usuario>\ si Documentos
rem  esta en una unidad de red, que Ubuntu no puede leer).
rem ======================================================================
setlocal
title Instalacion del curso - El tablero del director

set "LOCAL=%~dp0instalacion\windows\instalar.ps1"
if exist "%LOCAL%" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%LOCAL%"
  goto fin
)

echo Descargando los materiales del curso...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $doc=[Environment]::GetFolderPath('MyDocuments'); $base=$env:USERPROFILE; try { if ($doc -match '^[A-Za-z]:\\' -and (New-Object IO.DriveInfo($doc.Substring(0,1))).DriveType -eq 'Fixed') { $base=$doc } } catch { }; $d=Join-Path $base 'curso-tablero-director'; $z=Join-Path $env:TEMP 'curso-tablero-director.zip'; $x=Join-Path $env:TEMP 'curso-tablero-director-zip'; try { Invoke-WebRequest -UseBasicParsing 'https://github.com/dragones-tech/curso-tablero-director/archive/refs/heads/main.zip' -OutFile $z; if (Test-Path $x) { Remove-Item $x -Recurse -Force }; Expand-Archive $z $x -Force; $s=(Get-ChildItem $x -Directory | Select-Object -First 1).FullName; robocopy $s $d /E /NFL /NDL /NJH /NJS /NP | Out-Null; if ($LASTEXITCODE -ge 8) { throw 'no se pudieron copiar los archivos' }; Get-ChildItem $d -Recurse -File | Unblock-File; Remove-Item $z,$x -Recurse -Force; Write-Host ('Materiales del curso en ' + $d) -ForegroundColor Green } catch { Write-Host ('ERROR al descargar los materiales del curso: ' + $_) -ForegroundColor Red; Write-Host 'Revisa tu conexion a internet y vuelve a dar doble clic.' -ForegroundColor Red; exit 1 }; & (Join-Path $d 'instalacion\windows\instalar.ps1')"

:fin
echo.
echo Puedes cerrar esta ventana.
pause >nul
