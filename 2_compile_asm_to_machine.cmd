@echo off
PUSHD .
cd output
set include=..\..\fasmg\examples\x86\include
..\..\fasmg\fasmg main.asm x86_64_bin.exe
POPD
