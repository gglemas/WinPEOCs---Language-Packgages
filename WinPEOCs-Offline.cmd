@echo off
setlocal
rem WinPE OCs - offline edition launcher: starts WinPEOCs-Offline.ps1 elevated in Windows PowerShell 5.1 (STA).
rem Arguments are passed on, e.g.  WinPEOCs-Offline.cmd -Repo "D:\WinPEOCs\Repo"  or  -ShowConsole
set "WPEOCS_PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set "WPEOCS_SCRIPT=%~dp0WinPEOCs-Offline.ps1"
set "WPEOCS_ARGS=%*"
if not exist "%WPEOCS_SCRIPT%" (
    echo WinPEOCs-Offline.ps1 bulunamadi: "%WPEOCS_SCRIPT%"
    pause
    exit /b 1
)

net session >nul 2>&1
if not errorlevel 1 goto run

rem Not elevated: start PowerShell elevated (UAC prompt). The paths travel in environment variables,
rem so spaces, parentheses and apostrophes in the folder name need no quoting here.
echo Yonetici izni isteniyor (UAC)...
"%WPEOCS_PS%" -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath $env:WPEOCS_PS -Verb RunAs -WindowStyle Hidden -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -Sta -File \"' + $env:WPEOCS_SCRIPT + '\" ' + $env:WPEOCS_ARGS) -ErrorAction Stop } catch { Write-Host ('Yonetici izni alinamadi: ' + $_.Exception.Message); exit 1 }"
if errorlevel 1 pause
exit /b

:run
rem Already elevated: own (hidden) console for PowerShell, this window closes right away.
rem Start-up errors are shown in a message box by the script.
start "" "%WPEOCS_PS%" -NoProfile -ExecutionPolicy Bypass -Sta -WindowStyle Hidden -File "%WPEOCS_SCRIPT%" %*
exit /b 0
