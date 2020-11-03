@echo off
pushd .
cd ..
ScalpiCompiller.exe examples\12_message_box.txt
net helpmsg %ERRORLEVEL%
popd
pause
