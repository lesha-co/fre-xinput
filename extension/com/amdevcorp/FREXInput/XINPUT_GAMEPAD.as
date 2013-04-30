package com.amdevcorp.FREXInput
{
	import flash.geom.Point;
    
    internal class XINPUT_GAMEPAD
    {
        public var Buttons  : uint;
		public var LTrigger : uint;
		public var RTrigger : uint;
		public var ThumbLX  : uint;
		public var ThumbLY  : uint;
		public var ThumbRX  : uint;
		public var ThumbRY  : uint;
		
		
		public function get LStick():Point {
			return new Point(ThumbLX, ThumbLY);
		}
		public function get RStick():Point {
			return new Point(ThumbRX, ThumbRY);
		}
		
		internal function initWithJSON(src:String):void {
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