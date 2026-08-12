@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: install.bat — install Lithiumwow/mpv-config into mpv's portable_config folder
::
:: Usage:
::   install.bat
::   install.bat "C:\ProgramData\chocolatey\lib\mpvio.install\tools"
::   install.bat --appdata
::
:: Default target: chocolatey mpv tools dir\portable_config
:: --appdata installs to %APPDATA%\mpv instead (no admin usually needed)

set "REPO_OWNER=Lithiumwow"
set "REPO_NAME=mpv-config"
set "BRANCH=eng"
set "ZIP_URL=https://github.com/%REPO_OWNER%/%REPO_NAME%/archive/refs/heads/%BRANCH%.zip"
set "DEFAULT_MPV_DIR=C:\ProgramData\chocolatey\lib\mpvio.install\tools"

set "USE_APPDATA=0"
set "MPV_DIR="

if /I "%~1"=="--appdata" (
  set "USE_APPDATA=1"
) else if not "%~1"=="" (
  set "MPV_DIR=%~1"
)

if "%USE_APPDATA%"=="1" (
  set "DEST=%APPDATA%\mpv"
) else (
  if "!MPV_DIR!"=="" set "MPV_DIR=%DEFAULT_MPV_DIR%"
  if not exist "!MPV_DIR!\mpv.exe" (
    echo [error] mpv.exe not found in: !MPV_DIR!
    echo.
    echo Pass the folder that contains mpv.exe, for example:
    echo   %~nx0 "%DEFAULT_MPV_DIR%"
    echo Or install to AppData:
    echo   %~nx0 --appdata
    exit /b 1
  )
  set "DEST=!MPV_DIR!\portable_config"
)

:: Elevate when writing under ProgramData / Program Files
echo !DEST! | findstr /I /C:"\ProgramData\" /C:"\Program Files" >nul
if not errorlevel 1 (
  net session >nul 2>&1
  if errorlevel 1 (
    echo Requesting administrator rights to write to:
    echo   !DEST!
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -ArgumentList @('%*') -Verb RunAs"
    exit /b %ERRORLEVEL%
  )
)

set "TMPROOT=%TEMP%\%REPO_NAME%-install-%RANDOM%"
set "STAGE=%TMPROOT%\stage"
mkdir "%STAGE%" >nul 2>&1

echo.
echo === mpv-config installer ===
echo Destination: !DEST!
echo.

:: Prefer files next to this script (local clone); otherwise download from GitHub
if exist "%~dp0mpv.conf" (
  echo Using local files from:
  echo   %~dp0
  robocopy "%~dp0." "%STAGE%" /E /XD .git /NFL /NDL /NJH /NJS /nc /ns /np >nul
  set "RC=!ERRORLEVEL!"
) else (
  echo Downloading %REPO_OWNER%/%REPO_NAME% [%BRANCH%] ...
  set "ZIP=%TMPROOT%\config.zip"
  powershell -NoProfile -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " ^
    "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP%'; " ^
    "Expand-Archive -Path '%ZIP%' -DestinationPath '%TMPROOT%\extracted' -Force"
  if errorlevel 1 (
    echo [error] Download or extract failed.
    goto :cleanup_fail
  )
  :: GitHub zip extracts to repo-branch\
  set "EXTRACTED="
  for /d %%D in ("%TMPROOT%\extracted\%REPO_NAME%-*") do set "EXTRACTED=%%~fD"
  if "!EXTRACTED!"=="" (
    echo [error] Could not find extracted folder.
    goto :cleanup_fail
  )
  robocopy "!EXTRACTED!" "%STAGE%" /E /XD .git /NFL /NDL /NJH /NJS /nc /ns /np >nul
  set "RC=!ERRORLEVEL!"
)

if !RC! GEQ 8 (
  echo [error] Failed to stage files. robocopy code=!RC!
  goto :cleanup_fail
)

if not exist "%STAGE%\mpv.conf" (
  echo [error] Staged files look incomplete ^(missing mpv.conf^).
  goto :cleanup_fail
)

if not exist "!DEST!" mkdir "!DEST!" >nul 2>&1

echo Installing into:
echo   !DEST!
robocopy "%STAGE%" "!DEST!" /E /XD .git /NFL /NDL /NJH /NJS /nc /ns /np >nul
set "RC=!ERRORLEVEL!"
if !RC! GEQ 8 (
  echo [error] Install copy failed. robocopy code=!RC!
  goto :cleanup_fail
)

if exist "!DEST!\scripts\display-info.dll" (
  echo OK: display-info.dll present
) else (
  echo WARNING: display-info.dll missing
)

echo.
echo Install complete.
echo Restart mpv to load the new config.
echo.
goto :cleanup_ok

:cleanup_fail
rd /s /q "%TMPROOT%" >nul 2>&1
echo.
pause
exit /b 1

:cleanup_ok
rd /s /q "%TMPROOT%" >nul 2>&1
pause
exit /b 0
