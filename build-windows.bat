@echo off
setlocal
cd /d %~dp0

echo [INFO] Building Windows app package...

where npm >nul 2>nul
if %errorlevel% neq 0 (
  echo [WARN] npm not found. Trying to install Node.js LTS automatically...

  where winget >nul 2>nul
  if %errorlevel% neq 0 (
    echo [ERROR] winget not found, so Node.js auto-install is not available.
    echo         Please install Node.js LTS manually: https://nodejs.org
    pause
    exit /b 1
  )

  winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  if %errorlevel% neq 0 (
    echo [ERROR] Node.js auto-install failed.
    echo         Please install Node.js LTS manually: https://nodejs.org
    pause
    exit /b 1
  )

  echo [INFO] Node.js installed. Please close this window and run build-windows.bat again.
  pause
  exit /b 0
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
