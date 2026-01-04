@echo off
title Synchronizing Fiscal Noir

echo ==============================================
echo       FISCAL NOIR - GITHUB AUTOSYNC
echo ==============================================
echo.

echo [1/4] Pulling latest changes...
git pull origin main
if %errorlevel% neq 0 (
    echo Error pulling changes! Check your connection or conflicts.
    pause
    exit /b
)
echo.

echo [2/4] Adding changes...
git add .
echo.

set /p commitMsg="Enter the commit message (Press Enter for Auto Update): "

if "%commitMsg%"=="" (
    set commitMsg=Auto Update %date% %time%
)

echo [3/4] Committing with message: "%commitMsg%"
git commit -m "%commitMsg%"
echo.

echo [4/4] Pushing to GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo Error pushing changes!
    pause
    exit /b
)
echo.

echo ==============================================
echo             SYNC SUCCESSFUL!
echo ==============================================
pause
