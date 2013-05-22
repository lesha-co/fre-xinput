@echo off
call setupvars.bat

::clearing build
call clean.bat

::copying last dll 
copy "..\%dllLocation%%_dll%" . /Y

::creating an SWC
call swc.bat
if %ERRORLEVEL%==1 goto end
cd %CURRENTDIR%

::extracting library.swf
7z e %_swc% library.swf
if %ERRORLEVEL%==1 goto end
::creating an ANE
call ane.bat
:end
pause