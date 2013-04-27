// FREXInputTest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "FREXInput.h"
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	uint8_t* resp = NULL;
	PL_activate();
	while(1){
		PL_XInputGetState(0,&resp);
		cout << resp <<endl;
		Sleep(500);

	}
	return 0;
}

