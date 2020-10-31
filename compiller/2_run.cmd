@echo off
pushd .
cd ..
x86_64_bin.exe examples\12_message_box.txt
echo error = %ERRORLEVEL%
net helpmsg %ERRORLEVEL%
popd
pause
