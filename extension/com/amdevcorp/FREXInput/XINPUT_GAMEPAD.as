package com.amdevcorp.FREXInput
{
	import flash.geom.Point;
    
    public class XINPUT_GAMEPAD
    {
        public var Buttons  : uint;
		public var LTrigger : uint;
		public var RTrigger : uint;
		public var ThumbLX  : uint;
		public var ThumbLY  : uint;
		public var ThumbRX  : uint;
		public var ThumbRY  : uint;
		
		public function get DPAD_UP_PRESSED 	 ():Boolean{return (Buttons & 0x0001)!=0 };
		public function get DPAD_DOWN_PRESSED	 ():Boolean{return (Buttons & 0x0002)!=0 };
		public function get DPAD_LEFT_PRESSED	 ():Boolean{return (Buttons & 0x0004)!=0 };
		public function get DPAD_RIGHT_PRESSED	 ():Boolean{return (Buttons & 0x0008)!=0 };
		public function get START_PRESSED		 ():Boolean{return (Buttons & 0x0010)!=0 };
		public function get BACK_PRESSED		 ():Boolean{return (Buttons & 0x0020)!=0 };
		public function get LSTICK_PRESSED		 ():Boolean{return (Buttons & 0x0040)!=0 };
		public function get RSTICK_PRESSED		 ():Boolean{return (Buttons & 0x0080)!=0 };
		public function get LB_PRESSED			 ():Boolean{return (Buttons & 0x0100)!=0 };
		public function get RB_PRESSED			 ():Boolean{return (Buttons & 0x0200)!=0 };
        public function get GUIDE_BTN_PRESSED    ():Boolean{return (Buttons & 0x0400)!=0 };
		// ???              UNALLOCATED                                       0x0800
		public function get A_PRESSED			 ():Boolean{return (Buttons & 0x1000)!=0 };
		public function get B_PRESSED			 ():Boolean{return (Buttons & 0x2000)!=0 };
		public function get X_PRESSED			 ():Boolean{return (Buttons & 0x4000)!=0 };
		public function get Y_PRESSED			 ():Boolean{return (Buttons & 0x8000)!=0 };
		
		public function get LStick():Point {
			return new Point(ThumbLX, ThumbLY);
		}
		public function get RStick():Point {
			return new Point(ThumbRX, ThumbRY);
		}
		
		public function initWithJSON(src:String):void {
			var o:Object = JSON.parse(src);
			Buttons = o.gamepad.buttons;
			LTrigger = o.gamepad.triggers[0];
			RTrigger = o.gamepad.triggers[1];
			ThumbLX = o.gamepad.sticks[0].x;
			ThumbLY = o.gamepad.sticks[0].y;
			ThumbRX = o.gamepad.sticks[1].x;
			ThumbRY = o.gamepad.sticks[1].y;
		}
		
        public function XINPUT_GAMEPAD() {} 
    }
}