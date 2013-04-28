
call setupvars.bat

::clearing build
call clean.bat

::copying last dll 
copy "..\%dllLocation%%_dll%" . /Y

::creating an SWC
call swc.bat
cd %CURRENTDIR%

::extracting library.swf
7z e %_swc% library.swf

::creating an ANE
call ane.bat