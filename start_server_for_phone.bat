@echo off
echo Starting PHP Server for External Access...
echo.
echo IP Address to use in your App: 192.168.0.149
echo.
echo Ensure your phone and PC are connected to the SAME WiFi network.
echo.
echo Server is running... Leave this window OPEN.
echo.
php -S 0.0.0.0:8000 -t backend
pause
