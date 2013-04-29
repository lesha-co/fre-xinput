/* notation
 * FRE***  - functions : bridge to AIR — must be filed in context initializer with name "***"
 * DLL_*** - functions : alias for corresponring *** functions in XInput1_3.dll
 * PL_***  - functions : «payload» functions. They do all dirty work with corresponding DLL_*** functions and used by corresponding FRE*** functions
 *
 * THE MAP:
 * XInput1_3.dll <-> DLL_*** <-> PL_*** <--> FRE*** <-> AIR runtime
 *                                        `-> FREXInputTest project 
 *                                
 *
 */

#include "FREXinput.h"
#include <windows.h>
#include <XInput.h>
#include <string>       
#include <iostream>     
#include <sstream>

//library 
HMODULE hinstLib; 

// Let me explain some things. XInputGetState function provides all information except «guide» button status 
// Function I will call additionally provides all information about gamepad, except mysterious dwPacketNumber.
// Even if I really don't know its usecase, I want to provide ALL info, dwPacketNumber included. Therefore, I
// need both functions

typedef void (WINAPI *XInputEnable_t)(BOOL); 
typedef void (WINAPI *XInputGetState_t)(DWORD,XINPUT_STATE*); 
typedef int(__stdcall * XInputGetState2_t)(DWORD, XINPUT_STATE &); // <<<
typedef DWORD (WINAPI *XInputSetState_t)(uint32_t,XINPUT_VIBRATION*); 

XInputEnable_t DLL_XInputEnable;
XInputSetState_t DLL_XInputSetState;
XInputGetState_t DLL_XInputGetState;    // standard XInputGetState
XInputGetState2_t DLL_XInputGetState2;  // kind of private function, i'm not reaaly good in terms

// linkage status
BOOL fRunTimeLinkSuccess = FALSE; 

void XINPUT_STATE_to_JSON(XINPUT_STATE state, uint8_t** response){
	std::stringstream jsonState;
	jsonState << "{\"packetNumber\": "<< (uint32_t)state.dwPacketNumber << ",\"gamepad\":{\"sticks\":[{\"x\":\"" << state.Gamepad.sThumbLX << "\",\"y\":\"" << state.Gamepad.sThumbLY <<
		    "\"},{\"x\":\"" << state.Gamepad.sThumbRX << "\",\"y\":\"" << state.Gamepad.sThumbRY <<"\"}],\"buttons\":\"" <<
			state.Gamepad.wButtons << "\",\"triggers\":[\"" << (int)state.Gamepad.bLeftTrigger << "\",\"" << (int)state.Gamepad.bRightTrigger << "\"]}}";
	std::string s = jsonState.str();
	*response = (uint8_t*)strcpy((char*)malloc(s.length() + 1), s.c_str());
	return;
}

///////////////////////////////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///
/// FUNCTIONS WE EXPORT IN DLL FOR TESTING ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///
/////////////////////////////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   /// 

// (MSDN) Sets the reporting state of XInput.
// This affects all gamepads connected.
void PL_XInputEnable(BOOL enable){
	DLL_XInputEnable(enable);
}

// (MSDN) Sends data to a connected controller. 
// (MSDN) This function is used to activate the vibration function of a controller.
DWORD PL_XInputSetState(DWORD dwUserIndex, WORD left, WORD right){
	XINPUT_VIBRATION rumble;
	rumble.wLeftMotorSpeed = left;
	rumble.wRightMotorSpeed = right;
	return (DWORD) DLL_XInputSetState (dwUserIndex,&rumble);

}

// (MSDN) Retrieves the current state of the specified controller.
void PL_XInputGetState(DWORD dwUserIndex, XINPUT_STATE* state){

	XINPUT_STATE add_state;
	DLL_XInputGetState (dwUserIndex,&add_state);
	DLL_XInputGetState2 (dwUserIndex,*state);
	state->dwPacketNumber = add_state.dwPacketNumber;
	int i = rand();
	return;
	
}

// Loads XInput1_3.dll and gets function addresses.
// If succeeded, returns true, false otherwise.
BOOL PL_activate (){

	if (!fRunTimeLinkSuccess)
	{
		hinstLib = LoadLibrary(TEXT("XInput1_3.dll")); 
		if (hinstLib != NULL) 
		{ 
			DLL_XInputEnable = (XInputEnable_t) GetProcAddress(hinstLib, "XInputEnable");
			DLL_XInputGetState2 = (XInputGetState2_t) GetProcAddress(hinstLib, (LPCSTR)100);// !!! COOL HACKS !!1
			DLL_XInputGetState = (XInputGetState_t) GetProcAddress(hinstLib, "XInputGetState"); 
			DLL_XInputSetState = (XInputSetState_t) GetProcAddress(hinstLib, "XInputSetState"); 
			// List of functions we need to use
		    if (NULL != DLL_XInputGetState &&
				NULL != DLL_XInputSetState &&
				NULL != DLL_XInputGetState2 &&
				NULL != DLL_XInputEnable) 
		    {
		        fRunTimeLinkSuccess = TRUE; 
		    }
		}
	}
	return fRunTimeLinkSuccess;
}

/////////////////////////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///
/// FUNCTIONS WE EXPORT IN EXTENSION ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   /// 
///////////////////////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///  


FREObject FRE_XInputEnable(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	uint32_t enable;
	FREGetObjectAsBool(argv[0],&enable);
	PL_XInputEnable((BOOL)enable);
	FREObject result;
	FRENewObjectFromBool(enable,&result);
	return result;
}


FREObject FRE_XInputGetState(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	uint32_t dwUserIndex = 0;
	FREGetObjectAsUint32(argv[0], &dwUserIndex);
	uint8_t* json= NULL;
	
	XINPUT_STATE state;
	PL_XInputGetState((DWORD) dwUserIndex,&state);
	XINPUT_STATE_to_JSON(state,&json);

	FREObject result;
	FRENewObjectFromUTF8(strlen((const char*)json),(const uint8_t*)json,&result);
	return result;
}

FREObject FRE_XInputSetState(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	uint32_t dwUserIndex = 0;
	uint32_t lRumble = 0;
	uint32_t rRumble = 0;
	uint32_t errorCode = 0;
	FREGetObjectAsUint32(argv[0],&dwUserIndex);
	FREGetObjectAsUint32(argv[1],&lRumble);
	FREGetObjectAsUint32(argv[2],&rRumble);
	errorCode = (uint32_t) PL_XInputSetState(dwUserIndex,(WORD)lRumble,(WORD)rRumble);
	FREObject result;
	FRENewObjectFromUint32(errorCode, &result);
	return result;
}

FREObject FRE_activate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	PL_activate();
	FREObject result;
	FRENewObjectFromBool(fRunTimeLinkSuccess,&result);
	return result;
}

FREObject FRE_isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	FREObject result;
	FRENewObjectFromBool(TRUE,&result);
	return result;
}

////////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   //
/// RESTRICTED AREA ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///
//////////////////////   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   ///   /// 

void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions)
{
	*numFunctions = 5;

	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctions));

	func[0].name = (const uint8_t*) "isSupported";
	func[0].functionData = NULL;
	func[0].function = &FRE_isSupported;

	func[1].name = (const uint8_t*) "activate";
	func[1].functionData = NULL;
	func[1].function = &FRE_activate;

	func[2].name = (const uint8_t*) "XInputGetState";
	func[2].functionData = NULL;
	func[2].function = &FRE_XInputGetState;

	func[3].name = (const uint8_t*) "XInputSetState";
	func[3].functionData = NULL;
	func[3].function = &FRE_XInputSetState;

	func[4].name = (const uint8_t*) "XInputEnable";
	func[4].functionData = NULL;
	func[4].function = &FRE_XInputEnable;

	*functions = func;
}

void contextFinalizer(FREContext ctx)
{
	FreeLibrary(hinstLib); 
	return;
}

void FREXInputInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
{
	*ctxInitializer = &contextInitializer;
	*ctxFinalizer = &contextFinalizer;
}

void FREXInputFinalizer(void* extData)
{
	return;
}