@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

cl /nologo /MD /O2 /std:c++20 -c -FoMinaCalc.obj MinaCalc/MinaCalc.cpp -DSTANDALONE_CALC
cl /nologo /MD /O2 /std:c++20 -c -FoAPI.obj API.cpp -DSTANDALONE_CALC
link -dll -out:minacalc.dll MinaCalc.obj API.obj /EXPORT:calc_version /EXPORT:create_calc /EXPORT:destroy_calc /EXPORT:calc_msd /EXPORT:calc_ssr /EXPORT:calc_msd_rate

pause
