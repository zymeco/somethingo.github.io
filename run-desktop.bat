@echo off
setlocal
cd /d %~dp0

echo [INFO] Starting desktop mode...

where npm >nul 2>nul
if %errorlevel% neq 0 (
  echo [WARN] npm not found. Trying to install Node.js LTS automatically...

  where winget >nul 2>nul
  if %errorlevel% neq 0 (
    echo [WARN] winget not found. Falling back to web mode.
    goto :fallback_web
  )

  winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  if %errorlevel% neq 0 (
    echo [WARN] Node.js auto-install failed. Falling back to web mode.
    goto :fallback_web
  )

  echo [INFO] Node.js installed. Please close this window and run run-desktop.bat again.
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

echo [2/2] Launching desktop app...
call npm run desktop
exit /b %errorlevel%

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
