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
		
        public var dwPacketNumber :uint;
		
		public function get LStick():Point {
			return new Point(ThumbLX, ThumbLY);
		}
		public function get RStick():Point {
			return new Point(ThumbRX, ThumbRY);
		}
		
		private function initWithJSON(src:String):void {
			var o:Object = JSON.parse(src);
			Buttons = uint(o.gamepad.buttons);
			LTrigger = uint(o.gamepad.triggers[0]);
			RTrigger = uint(o.gamepad.triggers[1]);
			ThumbLX = int(o.gamepad.sticks[0].x);
			ThumbLY = int(o.gamepad.sticks[0].y);
			ThumbRX = int(o.gamepad.sticks[1].x);
			ThumbRY = int(o.gamepad.sticks[1].y);
            dwPacketNumber = uint(o.packetNumber);
		}
		
        public function XINPUT_GAMEPAD(srcJson:String = "") {
			if (srcJson) initWithJSON(srcJson);
		} 
    }
}