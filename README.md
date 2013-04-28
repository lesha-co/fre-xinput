# AIR 3.1 Windows x86 Native Extension for XBox360 gamepads support

This extension provides basic API for interacting with XBox360 gamepads

### Features:  

implemented:  
+ getting information about gamepad state (buttons, sticks, triggers, even guide buutton);
+ setting vibration state;  
soon:   
+ other cool things from XInput library [\[msdn\]](http://msdn.microsoft.com/en-us/library/windows/desktop/ee417007\(v=vs.85\).aspx)  

### You will need:

+ To be awesome  
+ Have XInput1_3.dll on your PC and path to it specified in PATH.  

additionally, for building:
+ Have 7z installed and path to it specified in PATH. If you want to use other archiver, you need to edit `7z e ...` string in `build.bat`. it must extract `library.swf` file from root directory of archive.
+ Have Flex SDK (I'm working with v4.6) installed and path to its `/bin` dir specified in PATH.

### How to use:
+ navigate to `/extension` dir. Grab `xinput.ane` file.  

##### For FlashBuilder users:  
+ Open the project in which you want to use the xinput;  
+ Go to Project properties → Flex Build Path → Native Extensions tab;  
+ Click «Add ANE...» and specify path to xinput.ane, press OK;  
+ The ane info should appear with green V next to it;  
+ Go to Flex Build Packaging → Native Extensions tab;  
+ Find xinput.ane and check «Package» box;  
+ go to your document class, import `com.amdevcorp.FREXInput.FREXInputLib` and `com.amdevcorp.FREXInput.XINPUT_GAMEPAD` classes, press build. If there are no errors, congrats!

##### For FlashDevelop users:
I will add it later.

### API
I will add it later.

### How to build your own:
In the /native/FREXInput folder is a VS2012 project that can build a DLL  
Also, in the /native/FREXInputTest folder the small program for debugging DLL  
+ __STEP 1:__ Build FREXInput project  
in the /extension folder is a small utillity that can pack an ANE  
+ __STEP 2:__ Go to setupvars.bat and edit `Set FLEXSDK...` string to meet your Flex SDK location  
+ __STEP 3:__ Call build.bat   
If all done right you must see `xinput.ane` file appear in yor /extension dir (press f5 just in case)  
If not, call `go.bat` and type `build.bat`. Look for errors, google them or contact me. I'll try to help.  
In the /flex directory is a Flash Builder 4.6 project, also for testing purposes. You can skip further steps and use xinput.ane in your project
+ __STEP 4:__ Import project in Flash Builder and press debug button.
	
