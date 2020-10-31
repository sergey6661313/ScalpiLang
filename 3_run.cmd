@echo off
PUSHD .
cd output
x86_64_bin.exe
echo error = %ERRORLEVEL%
net helpmsg %ERRORLEVEL%
POPD
