package com.amdevcorp.FREXInput
{
	import flash.geom.Point;
    
    internal class XINPUT_GAMEPAD
    {
        public var Buttons  : uint;
		public var LTrigger : uint;
		public var RTrigger : uint;
		public var ThumbLX  : int;
		public var ThumbLY  : int;
		public var ThumbRX  : int;
		public var ThumbRY  : int;
		
		
		public function get LStick():Point {
			return new Point(ThumbLX, ThumbLY);
		}
		public function get RStick():Point {
			return new Point(ThumbRX, ThumbRY);
		}
		
		private function initWithJSON(src:String):void {
			var o:Object = JSON.parse(src);
			Buttons = o.gamepad.buttons;
			LTrigger = o.gamepad.triggers[0];
			RTrigger = o.gamepad.triggers[1];
			ThumbLX = o.gamepad.sticks[0].x;
			ThumbLY = o.gamepad.sticks[0].y;
			ThumbRX = o.gamepad.sticks[1].x;
			ThumbRY = o.gamepad.sticks[1].y;
		}
		
        public function XINPUT_GAMEPAD(srcJson:String = "") {
			if (srcJson) initWithJSON(srcJson);
		} 
    }
}