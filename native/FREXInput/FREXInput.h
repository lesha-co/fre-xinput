#include "FlashRuntimeExtensions.h"
#include <windows.h>
#include <XInput.h>


extern "C" __declspec(dllexport) void FREXInputInitializer(void** extData, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);  
extern "C" __declspec(dllexport) void FREXInputFinalizer(void* extData);

__declspec(dllexport) void PL_XInputGetState(DWORD dwUserIndex, XINPUT_STATE* state);
__declspec(dllexport) DWORD PL_XInputSetState(DWORD dwUserIndex, WORD left, WORD right);
__declspec(dllexport) BOOL PL_activate();
__declspec(dllexport) void PL_XInputEnable(BOOL enable);

