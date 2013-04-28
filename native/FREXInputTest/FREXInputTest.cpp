// FREXInputTest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "FREXInput.h"
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	int index = 0;
	const double Multiplier = 65536/256;
	if (PL_activate())
	{
		cout << "Linked to DLL" << endl;
		while(1){
			XINPUT_STATE state;
			ZeroMemory(&state,sizeof(state));
			PL_XInputGetState(index,&state);
			PL_XInputSetState(index,
							  (WORD)(Multiplier*state.Gamepad.bLeftTrigger),
							  (WORD)(Multiplier*state.Gamepad.bRightTrigger));
			printf("%*x \r",4,state.Gamepad.wButtons);	
		}
	}
	else
	{
		cout << "Linkage failed" << endl;
		_gettchar();
	}
	return 0;
}

