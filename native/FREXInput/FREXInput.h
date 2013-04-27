#include "FlashRuntimeExtensions.h"
#include <windows.h>

extern "C" __declspec(dllexport) void FREXInputInitializer(void** extData, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);  
extern "C" __declspec(dllexport) void FREXInputFinalizer(void* extData);

__declspec(dllexport) void PL_XInputGetState(DWORD dwUserIndex, uint8_t** response);
__declspec(dllexport) BOOL PL_activate();