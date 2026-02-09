@echo off
echo Starting PHP Backend Server on 0.0.0.0:8000...
echo Ensure your phone is connected to the same Wi-Fi.
echo Your IP is likely: 192.168.0.149
echo.
php -S 0.0.0.0:8000 -t backend
pause
