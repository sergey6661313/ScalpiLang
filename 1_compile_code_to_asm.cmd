@echo off
x86_64_bin.exe %1
echo error = %ERRORLEVEL%
net helpmsg %ERRORLEVEL%
pause
