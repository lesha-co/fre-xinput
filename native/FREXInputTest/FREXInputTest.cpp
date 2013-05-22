// FREXInputTest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "FREXInput.h"
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	int index = 3;
	const double Multiplier = 65536/256;
	BOOL flag = false;
	if (PL_activate())
	{
		
		cout << "  Packet  btns     LX     LY     RX     RY" << endl;
		while(1){
			XINPUT_STATE state;
			ZeroMemory(&state,sizeof(state));
			PL_XInputGetState(index,&state);
			
			PL_XInputSetState(index,
							 (WORD)(Multiplier*state.Gamepad.bRightTrigger),
							 (WORD)(Multiplier*state.Gamepad.bLeftTrigger));
			
			//printf("%*d: %*x %*d %*d %*d %*d \r",8,state.dwPacketNumber,
			//								4,state.Gamepad.wButtons,
			//								6,state.Gamepad.sThumbLX,
			//								6,state.Gamepad.sThumbLY,
			//								6,state.Gamepad.sThumbRX,
			//								6,state.Gamepad.sThumbRY);	
			uint8_t* resp;
			XINPUT_STATE_to_JSON(state,index,&resp);
			cout << resp << "\r";
		}
		
	}
	else
	{
		cout << "Linkage failed" << endl;
		_gettchar();
	}
	return 0;
}

