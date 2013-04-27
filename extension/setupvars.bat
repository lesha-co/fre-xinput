for /F "tokens=*" %%i in ('cd') do set CURRENTDIR=%%i

Set _swc=FREXInput.swc
Set dllLocation=..\native\FREXInput\Release\
Set _dll=FREXInput.dll
Set _ane=xinput.ane
::Set swcsource=FREXInput.as
Set descriptor=descriptor.xml
Set importclasses=com.amdevcorp.FREXInput.FREXInputLib com.amdevcorp.FREXInput.XINPUT_GAMEPAD


Set FLEXSDK=C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\bin
