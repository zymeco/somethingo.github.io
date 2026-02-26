@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

echo [INFO] Building Windows app package...
call :ensure_node
if %errorlevel% neq 0 (
  echo [ERROR] Node.js/npm setup failed.
  pause
  exit /b 1
)

echo [1/2] Installing dependencies...
call npm install
if %errorlevel% neq 0 (
  echo [ERROR] npm install failed.
  pause
  exit /b 1
)

echo [2/2] Building Windows installer and portable exe...
call npm run desktop:pack
if %errorlevel% neq 0 (
  echo [ERROR] Build failed.
  pause
  exit /b 1
)

echo Build completed. Check dist folder.
pause
exit /b 0

:ensure_node
where npm >nul 2>nul
if %errorlevel% equ 0 exit /b 0

echo [WARN] npm not found. Trying to install Node.js LTS automatically...

where winget >nul 2>nul
if %errorlevel% equ 0 (
  winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  if %errorlevel% equ 0 (
    echo [INFO] Node.js installed via winget. Please close this window and run again.
    pause
    exit /b 1
  )
)

echo [WARN] winget unavailable or install failed. Trying portable Node.js download...
set "NODE_VER=20.18.0"
set "NODE_ZIP=node-v%NODE_VER%-win-x64.zip"
set "NODE_URL=https://nodejs.org/dist/v%NODE_VER%/%NODE_ZIP%"
set "NODE_DIR=%~dp0.tools\node-v%NODE_VER%-win-x64"
set "NODE_ZIP_PATH=%~dp0.tools\%NODE_ZIP%"

if not exist "%~dp0.tools" mkdir "%~dp0.tools"

where powershell >nul 2>nul
if %errorlevel% neq 0 (
  echo [ERROR] powershell not found, cannot auto-download portable Node.js.
  exit /b 1
)

if not exist "%NODE_DIR%\npm.cmd" (
  echo [INFO] Downloading %NODE_URL%
  powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%NODE_URL%' -OutFile '%NODE_ZIP_PATH%'"
  if %errorlevel% neq 0 (
    echo [ERROR] Portable Node.js download failed.
    exit /b 1
  )

  tar -xf "%NODE_ZIP_PATH%" -C "%~dp0.tools"
  if %errorlevel% neq 0 (
    echo [ERROR] Portable Node.js extraction failed.
    exit /b 1
  )
)

if exist "%NODE_DIR%\npm.cmd" (
  set "PATH=%NODE_DIR%;%PATH%"
  where npm >nul 2>nul
  if %errorlevel% equ 0 (
    echo [INFO] Portable Node.js activated.
    exit /b 0
  )
)

echo [ERROR] npm still unavailable after portable setup.
exit /b 1
