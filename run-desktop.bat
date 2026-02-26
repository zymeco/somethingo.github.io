@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

echo [INFO] Starting desktop mode...
call :ensure_node
if %errorlevel% neq 0 (
  echo [WARN] Node.js/npm setup unavailable. Falling back to web mode.
  goto :fallback_web
)

echo [1/2] Installing dependencies...
call npm install
if %errorlevel% neq 0 (
  echo [ERROR] npm install failed.
  pause
  exit /b 1
)

echo [2/2] Launching desktop app...
call npm run desktop
exit /b %errorlevel%

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

:fallback_web
echo [INFO] Trying Python web mode on http://localhost:4173 ...
where py >nul 2>nul
if %errorlevel% neq 0 (
  where python >nul 2>nul
  if %errorlevel% neq 0 (
    echo [ERROR] Python launcher (py/python) not found.
    echo         Install one of these first:
    echo         1) Node.js LTS: https://nodejs.org
    echo         2) Python: https://python.org
    pause
    exit /b 1
  )
  start "" http://localhost:4173
  python -m http.server 4173
  exit /b %errorlevel%
)

start "" http://localhost:4173
py -m http.server 4173
exit /b %errorlevel%
