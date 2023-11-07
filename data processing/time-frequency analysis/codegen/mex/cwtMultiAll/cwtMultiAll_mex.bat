@echo off
call setEnv.bat
"D:\Program Files\MATLAB\R2021b\toolbox\shared\coder\ninja\win64\ninja.exe" -t compdb cc cxx cudac > compile_commands.json
"D:\Program Files\MATLAB\R2021b\toolbox\shared\coder\ninja\win64\ninja.exe" -v %*
