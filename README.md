# AIR 3.1 Windows x86 Native Extension for XBox360 gamepads support

This extension provides basic API for interacting with XBox360 gamepads

### Features:  

implemented:  
+ getting information about gamepad state  

soon:  
+ vibration  
+ maybe «home» button  
+ other cool things from XInput library [\[msdn\]](http://msdn.microsoft.com/en-us/library/windows/desktop/ee417007\(v=vs.85\).aspx)  

### You will need:

+ 7z installed and path to it specified in PATH. If you want to use other archiver, edit `7z e ...` string in `build.bat`. it must extract `library.swf` file from root directory of archive.
+ Flex SDK installed and path to its /bin dir specified in PATH.
	
### How to build extension
in the /native/FREXInput folder is a VS2012 project that can build a dll  
also, in the /native/FREXInputTest folder the small program for debugging dll  
+ __STEP 1:__ Build FREXInput project  
in the /extension folder is a small utillity that can pack an ANE  
+ __STEP 2:__ Go to setupvars.bat and edit `Set FLEXSDK...` string to meet your Flex SDK location  
+ __STEP 3:__ Call build.bat  
NOTE: you must have Flex SDK installed and path to `adt` is specified in PATH  
If all done right you must see `xinput.ane` file appear in yor /extension dir (press f5 just in case)  
If not, call `go.bat` and type `build.bat`. Look for errors, google them or contact me. I'll try to help.  
In the /flex directory is a Flash Builder 4.6 project, also for testing purposes. You can skip further steps and use xinput.ane in your project
+ __STEP 4:__ import project in Flash Builder and press debug button.
	
