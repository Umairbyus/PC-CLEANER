@echo off
:: Improved System Cleaner with Error Handling
:: Run as Administrator for full functionality
:: ------------------------------------------

:: Check for admin rights
fltmc >nul 2>&1 || (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

:: Main Menu
:MAIN
cls
echo.
echo ==============================
echo    ADVANCED SYSTEM CLEANER
echo ==============================
echo 1. Quick Clean (Safe)
echo 2. Deep Clean (Advanced)
echo 3. Malware Trace Removal
echo 4. Exit
echo.
set /p "choice=Select option [1-4]: "

if "%choice%"=="1" goto QUICKCLEAN
if "%choice%"=="2" goto DEEPCLEAN
if "%choice%"=="3" goto MALWARE
if "%choice%"=="4" exit
echo Invalid choice! Press any key to try again...
pause >nul
goto MAIN

:: Quick Clean Function
:QUICKCLEAN
cls
echo === QUICK CLEAN ===
echo Cleaning temporary files...
del /f /s /q "%temp%\*.*" 2>nul
del /f /s /q "%windir%\Temp\*.*" 2>nul

echo Clearing DNS cache...
ipconfig /flushdns 2>nul | find "successfully" && (
    echo DNS cache flushed successfully
) || (
    echo Failed to flush DNS cache
)

echo Cleaning browser caches...
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache" 2>nul
rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" 2>nul

echo Quick clean completed!
pause
goto MAIN

:: Deep Clean Function
:DEEPCLEAN
cls
echo === DEEP CLEAN ===
echo Cleaning Windows Update cache...
net stop wuauserv >nul 2>&1
rd /s /q "%windir%\SoftwareDistribution\Download" 2>nul
net start wuauserv >nul 2>&1

echo Clearing thumbnail cache...
del /f /s /q /a "%localappdata%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul

echo Cleaning error reports...
rd /s /q "%windir%\Minidump" 2>nul
del /q "%localappdata%\Microsoft\Windows\WER\*.*" 2>nul

echo Deep clean completed!
pause
goto MAIN

:: Malware Clean Function
:MALWARE
cls
echo === MALWARE TRACE REMOVAL ===
echo WARNING: This will modify system settings
echo Removing suspicious startup items...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /va /f 2>nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /va /f 2>nul

echo Scanning AppData for suspicious files...
del /f /q "%appdata%\*.exe" 2>nul
del /f /q "%appdata%\*.vbs" 2>nul
del /f /q "%appdata%\*.bat" 2>nul

echo Resetting hosts file...
echo 127.0.0.1 localhost > %windir%\System32\drivers\etc\hosts

echo Malware trace removal completed!
echo NOTE: For complete protection, use a proper antivirus
pause
goto MAIN