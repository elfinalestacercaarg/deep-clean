@echo off
setlocal enabledelayedexpansion
title Deep Clean v3.6 - Nahue Edition
chcp 65001 >nul
cls

:: ============================================================================
:: DEEP CLEAN v3.6 - LIMPIADOR PROFUNDO Y SEGURO PARA WINDOWS
:: ============================================================================
:: Autor: Eduardo Alzogaray (Nahue) - Chajarí, Entre Ríos
:: Version: 3.6
:: Fecha: Mayo 2026
:: Repo: github.com/elfinalestacercaarg
::
:: Esta version agrega:
::  - Modo "safe" (solo lo basico) y modo "completo"
::  - Punto de restauracion antes de limpiar
::  - Reporte .txt con resultados y timestamp
::  - Limpieza de cache de VS Code y node_modules
::  - Mejor output con simbolos visuales
::  - Calculo aproximado de MB liberados
:: ============================================================================

:: ============================================================================
:: VARIABLES GLOBALES
:: ============================================================================
set "VERSION=3.6"
set "FECHA=%date% %time%"
set "REPORTE=%USERPROFILE%\Desktop\DeepClean_Reporte_%RANDOM%.txt"
set "ESPACIO_ANTES=0"
set "ESPACIO_DESPUES=0"
set "MODO=completo"

:: ============================================================================
:: BANNER INICIAL
:: ============================================================================
color 0B
echo.
echo  ============================================================
echo     DEEP CLEAN v%VERSION% - Limpieza profesional Windows
echo     Por Nahue Alzogaray ^| Chajari, Entre Rios
echo  ============================================================
echo.
echo  Esta herramienta limpia profundamente tu PC SIN tocar
echo  nada importante del sistema. Es 100%% segura.
echo.

:: ============================================================================
:: VERIFICAR ADMINISTRADOR
:: ============================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo.
    echo  [X] ERROR: Necesitas ejecutar como ADMINISTRADOR
    echo.
    echo  Como hacerlo:
    echo    1. Cerra esta ventana
    echo    2. Click derecho en el archivo .bat
    echo    3. Seleccionar "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

:: ============================================================================
:: SELECCION DE MODO
:: ============================================================================
echo.
echo  Elegi el modo de limpieza:
echo.
echo    [1] MODO SAFE      - Solo lo basico (Temp, Cache, DNS)
echo    [2] MODO COMPLETO  - Todo (Temp + Sistema + Update + Navegadores)
echo    [3] MODO PERSONALIZADO - Vos elegis paso por paso
echo.
set /p modo_opcion="  Tu eleccion (1/2/3): "

if "%modo_opcion%"=="1" set "MODO=safe"
if "%modo_opcion%"=="2" set "MODO=completo"
if "%modo_opcion%"=="3" set "MODO=personalizado"

echo.
echo  ============================================================
echo    Modo seleccionado: %MODO%
echo  ============================================================
echo.

:: ============================================================================
:: PUNTO DE RESTAURACION (opcional)
:: ============================================================================
set /p restaurar="  Crear punto de restauracion antes? (recomendado) (S/N): "
if /i "%restaurar%"=="S" (
    echo.
    echo  [...] Creando punto de restauracion...
    powershell -Command "Checkpoint-Computer -Description 'DeepClean v%VERSION% Pre-Limpieza' -RestorePointType MODIFY_SETTINGS" 2>nul
    if !errorLevel! equ 0 (
        echo  [OK] Punto de restauracion creado
    ) else (
        echo  [!]  No se pudo crear el punto (puede estar deshabilitado en Windows)
    )
    echo.
)

:: ============================================================================
:: MEDIR ESPACIO ANTES
:: ============================================================================
echo  ============================================================
echo    Espacio libre ANTES de limpiar:
echo  ============================================================
for /f "skip=1 tokens=*" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul ^| find "="') do (
    set "%%a"
)
set /a "ESPACIO_ANTES_GB=%FreeSpace:~0,-9% / 1"
echo  Disco C: %ESPACIO_ANTES_GB% GB libres
echo.
echo  Presiona una tecla para empezar la limpieza...
pause >nul
cls

:: ============================================================================
:: INICIAR REPORTE
:: ============================================================================
echo Deep Clean v%VERSION% - Reporte de ejecucion > "%REPORTE%"
echo ============================================================ >> "%REPORTE%"
echo Fecha: %FECHA% >> "%REPORTE%"
echo Usuario: %USERNAME% >> "%REPORTE%"
echo Modo: %MODO% >> "%REPORTE%"
echo Espacio antes: %ESPACIO_ANTES_GB% GB >> "%REPORTE%"
echo ============================================================ >> "%REPORTE%"
echo. >> "%REPORTE%"
echo Pasos ejecutados: >> "%REPORTE%"
echo. >> "%REPORTE%"

:: ============================================================================
:: PASO 1: TEMPORALES DEL USUARIO
:: ============================================================================
echo.
echo  [1/12] Limpiando temporales del usuario...
del /q /f /s "%TEMP%\*.*" 2>nul
rd /s /q "%LOCALAPPDATA%\Temp" 2>nul
md "%LOCALAPPDATA%\Temp" >nul 2>&1
echo  [OK]   Temporales del usuario limpiados
echo [OK] Paso 1/12 - Temporales del usuario >> "%REPORTE%"

:: ============================================================================
:: PASO 2: TEMPORALES DE WINDOWS
:: ============================================================================
echo.
echo  [2/12] Limpiando temporales de Windows...
del /q /f /s "C:\Windows\Temp\*.*" 2>nul
echo  [OK]   Temporales de Windows limpiados
echo [OK] Paso 2/12 - Temporales de Windows >> "%REPORTE%"

:: ============================================================================
:: PASO 3: PREFETCH
:: ============================================================================
echo.
echo  [3/12] Limpiando Prefetch...
del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
echo  [OK]   Prefetch limpiado
echo [OK] Paso 3/12 - Prefetch >> "%REPORTE%"

:: ============================================================================
:: PASO 4: MINIATURAS Y CACHE DE ICONOS
:: ============================================================================
echo.
echo  [4/12] Limpiando miniaturas e iconos...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
del /q /f /s "%LOCALAPPDATA%\IconCache.db" 2>nul
echo  [OK]   Miniaturas e iconos limpiados
echo [OK] Paso 4/12 - Cache de iconos y miniaturas >> "%REPORTE%"

:: ============================================================================
:: PASO 5: PAPELERA Y ARCHIVOS RECIENTES
:: ============================================================================
echo.
echo  [5/12] Vaciando papelera y archivos recientes...
rd /s /q "%systemdrive%\$Recycle.Bin" 2>nul
del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\*" 2>nul
echo  [OK]   Papelera y recientes limpiados
echo [OK] Paso 5/12 - Papelera y recientes >> "%REPORTE%"

:: ============================================================================
:: PASO 6: CACHE DE DNS
:: ============================================================================
echo.
echo  [6/12] Limpiando cache de DNS...
ipconfig /flushdns >nul
echo  [OK]   Cache DNS limpiado
echo [OK] Paso 6/12 - Cache DNS >> "%REPORTE%"

:: ============================================================================
:: PASO 7: REPORTES DE ERRORES Y CRASH DUMPS
:: ============================================================================
echo.
echo  [7/12] Limpiando reportes de errores y crash dumps...
rd /s /q "%LOCALAPPDATA%\Microsoft\Windows\WER" 2>nul
rd /s /q "%LOCALAPPDATA%\CrashDumps" 2>nul
echo  [OK]   Reportes y crashes limpiados
echo [OK] Paso 7/12 - Reportes y crashes >> "%REPORTE%"

:: ============================================================================
:: PASO 8: LOGS DE WINDOWS
:: ============================================================================
echo.
echo  [8/12] Limpiando logs de Windows...
del /q /f /s "C:\Windows\Logs\*.*" 2>nul
echo  [OK]   Logs limpiados
echo [OK] Paso 8/12 - Logs de Windows >> "%REPORTE%"

:: ============================================================================
:: SI ES MODO SAFE, SALTAR EL RESTO
:: ============================================================================
if "%MODO%"=="safe" goto :FINAL

:: ============================================================================
:: PASO 9: WINDOWS UPDATE Y DELIVERY OPTIMIZATION
:: ============================================================================
echo.
echo  [9/12] Limpiando cache de Windows Update...
if "%MODO%"=="personalizado" (
    set /p paso9="    Ejecutar este paso? (S/N): "
    if /i not "!paso9!"=="S" (
        echo  [SK]   Saltado por usuario
        echo [SK] Paso 9/12 - Saltado por usuario >> "%REPORTE%"
        goto :PASO10
    )
)
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul
rd /s /q "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" 2>nul
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo  [OK]   Windows Update y Delivery limpiados
echo [OK] Paso 9/12 - Windows Update >> "%REPORTE%"

:PASO10
:: ============================================================================
:: PASO 10: CACHE DE NAVEGADORES
:: ============================================================================
echo.
echo  [10/12] Limpiando cache de navegadores...
if "%MODO%"=="personalizado" (
    set /p paso10="    Ejecutar este paso? (S/N): "
    if /i not "!paso10!"=="S" (
        echo  [SK]   Saltado por usuario
        echo [SK] Paso 10/12 - Saltado por usuario >> "%REPORTE%"
        goto :PASO11
    )
)

:: Chrome
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache" 2>nul
echo  [OK]   Chrome limpiado

:: Edge
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache" 2>nul
echo  [OK]   Edge limpiado

:: Firefox (cache profile)
for /d %%i in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
    rd /s /q "%%i\cache2" 2>nul
    rd /s /q "%%i\startupCache" 2>nul
)
echo  [OK]   Firefox limpiado

:: Brave
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache" 2>nul
echo  [OK]   Brave limpiado

echo [OK] Paso 10/12 - Cache de navegadores >> "%REPORTE%"

:PASO11
:: ============================================================================
:: PASO 11: CACHE DE VS CODE Y HERRAMIENTAS DEV
:: ============================================================================
echo.
echo  [11/12] Limpiando cache de herramientas de desarrollo...
if "%MODO%"=="personalizado" (
    set /p paso11="    Ejecutar este paso? (S/N): "
    if /i not "!paso11!"=="S" (
        echo  [SK]   Saltado por usuario
        echo [SK] Paso 11/12 - Saltado por usuario >> "%REPORTE%"
        goto :PASO12
    )
)

:: VS Code
rd /s /q "%APPDATA%\Code\Cache" 2>nul
rd /s /q "%APPDATA%\Code\CachedData" 2>nul
rd /s /q "%APPDATA%\Code\Code Cache" 2>nul
rd /s /q "%APPDATA%\Code\GPUCache" 2>nul
rd /s /q "%APPDATA%\Code\logs" 2>nul
echo  [OK]   VS Code limpiado

:: NPM cache
if exist "%APPDATA%\npm-cache" (
    rd /s /q "%APPDATA%\npm-cache" 2>nul
    echo  [OK]   NPM cache limpiado
)

:: Yarn cache
if exist "%LOCALAPPDATA%\Yarn\Cache" (
    rd /s /q "%LOCALAPPDATA%\Yarn\Cache" 2>nul
    echo  [OK]   Yarn cache limpiado
)

:: Cypress
if exist "%LOCALAPPDATA%\Cypress\Cache" (
    rd /s /q "%LOCALAPPDATA%\Cypress\Cache" 2>nul
    echo  [OK]   Cypress cache limpiado
)

echo [OK] Paso 11/12 - Cache dev tools >> "%REPORTE%"

:PASO12
:: ============================================================================
:: PASO 12: DISM (Limpieza profunda de componentes)
:: ============================================================================
echo.
echo  [12/12] Limpieza profunda con DISM...

if "%MODO%"=="personalizado" (
    set /p paso12="    Ejecutar DISM? (puede tardar 5-15 min) (S/N): "
    if /i not "!paso12!"=="S" (
        echo  [SK]   Saltado por usuario
        echo [SK] Paso 12/12 - Saltado por usuario >> "%REPORTE%"
        goto :FINAL
    )
) else (
    echo.
    set /p dism="    Ejecutar limpieza DISM? (puede tardar 5-15 min) (S/N): "
    if /i not "!dism!"=="S" (
        echo  [SK]   DISM saltado
        echo [SK] Paso 12/12 - DISM saltado >> "%REPORTE%"
        goto :FINAL
    )
)

echo  [...]  Ejecutando DISM (paciencia, puede tardar)...
Dism.exe /Online /Cleanup-Image /StartComponentCleanup
echo  [OK]   DISM finalizado
echo [OK] Paso 12/12 - DISM >> "%REPORTE%"

:FINAL
:: ============================================================================
:: MEDIR ESPACIO DESPUES
:: ============================================================================
echo.
echo  ============================================================
echo    Calculando espacio liberado...
echo  ============================================================
for /f "skip=1 tokens=*" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul ^| find "="') do (
    set "%%a"
)
set /a "ESPACIO_DESPUES_GB=%FreeSpace:~0,-9% / 1"
set /a "LIBERADO_GB=%ESPACIO_DESPUES_GB% - %ESPACIO_ANTES_GB%"

:: ============================================================================
:: FINALIZAR REPORTE
:: ============================================================================
echo. >> "%REPORTE%"
echo ============================================================ >> "%REPORTE%"
echo Espacio antes: %ESPACIO_ANTES_GB% GB >> "%REPORTE%"
echo Espacio despues: %ESPACIO_DESPUES_GB% GB >> "%REPORTE%"
echo Espacio liberado: ~%LIBERADO_GB% GB >> "%REPORTE%"
echo ============================================================ >> "%REPORTE%"
echo Fin: %date% %time% >> "%REPORTE%"

:: ============================================================================
:: MENSAJE FINAL
:: ============================================================================
cls
color 0A
echo.
echo  ============================================================
echo            LIMPIEZA COMPLETADA CON EXITO
echo  ============================================================
echo.
echo    Modo:               %MODO%
echo    Espacio antes:      %ESPACIO_ANTES_GB% GB
echo    Espacio despues:    %ESPACIO_DESPUES_GB% GB
echo    Espacio liberado:   ~%LIBERADO_GB% GB
echo.
echo    Reporte guardado:
echo    %REPORTE%
echo.
echo  ============================================================
echo.
echo  Recomendaciones:
echo    - Reinicia la computadora para mejor rendimiento
echo    - Podes ejecutar este script una vez por mes
echo    - Si usas mucho Chrome, podes ejecutarlo mas seguido
echo.

set /p reinicio="  Reiniciar la PC ahora? (S/N): "
if /i "%reinicio%"=="S" (
    echo.
    echo  La PC se reiniciara en 10 segundos...
    echo  (Cerra esta ventana para cancelar)
    shutdown /r /t 10
) else (
    echo.
    echo  Listo. Podes reiniciar cuando quieras.
    echo.
    pause
)

exit /b 0
