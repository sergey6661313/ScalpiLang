@echo off
PUSHD .
cd translated_manually
set include=..\..\..\fasmg\examples\x86\include
..\..\..\fasmg\fasmg main.asm ..\..\x86_64_bin.exe
POPD
