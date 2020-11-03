@echo off
PUSHD .
cd translated_manually
set include=..\..\..\fasmg\examples\x86\include
..\..\..\fasmg\fasmg main.asm ..\..\ScalpiCompiller.exe
POPD
