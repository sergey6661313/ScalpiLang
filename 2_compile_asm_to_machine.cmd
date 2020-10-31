@echo off
PUSHD .
cd output
cd asm
set include=..\..\..\fasmg\examples\x86\include
..\..\..\fasmg\fasmg main.asm ..\x86_64_bin.exe
POPD
