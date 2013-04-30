//Apparently, the main class of the extension!

package com.amdevcorp.FREXInput {
    
	import adobe.utils.CustomActions;
    import flash.geom.Point;
    import flash.events.EventDispatcher;
    import com.amdevcorp.FREXInput.XINPUT_GAMEPAD;
    import flash.external.ExtensionContext;
    
    public class Gamepad extends EventDispatcher {
        private static var XService:ExtensionContext;
        public static const XUSER_MAX_COUNT:uint = 4;
        
        public static const ERROR_EXTENSION_FAILED_TO_START:uint = 1;
        public static const ERROR_WRONG_ID:uint = 2;
        //TODO: this error
		public static const ERROR_CONTROLLER_NOT_CONNECTED:uint = 3;
        public static const RUMBLE_MAX_VALUE:uint = 65535;
		public static const TRIGGER_MAX_VALUE:uint = 255;
		
        // values from MSDN
        public static const DPAD_UP    :uint = 0x0001;
        public static const DPAD_DOWN  :uint = 0x0002;
        public static const DPAD_LEFT  :uint = 0x0004;
        public static const DPAD_RIGHT :uint = 0x0008;
        public static const START      :uint = 0x0010;
        public static const BACK       :uint = 0x0020;
        public static const LSTICK     :uint = 0x0040;
        public static const RSTICK     :uint = 0x0080;
        public static const LB         :uint = 0x0100;
        public static const RB         :uint = 0x0200;
        public static const GUIDE      :uint = 0x0400;
        public static const A          :uint = 0x1000;
        public static const B          :uint = 0x2000;
        public static const X          :uint = 0x4000;
        public static const Y          :uint = 0x8000;
        
        internal static var extensionIsActive:Boolean // == false by default
        private var _USER_ID:uint
		private var lastState:XINPUT_GAMEPAD; // only used for discovering changes
		private var lastRumble:Array;
        
        public function Gamepad(id:uint) {
            if (!extensionIsActive) {
				XService = ExtensionContext.createExtensionContext("com.amdevcorp.ane.FREXInput", null);
				var success:Boolean = XService.call("activate") as Boolean;
				if (success) {
					extensionIsActive = true
				} else {
					throw new Error("General failure", ERROR_EXTENSION_FAILED_TO_START)
				}				
			}
			_USER_ID = id;
			lastRumble = [0, 0];
			if (id >= XUSER_MAX_COUNT) {
                throw new ArgumentError("Wrong id:" + String(id), ERROR_WRONG_ID);
            }
        
        }
        public function isPressed(buttonCode:uint):Boolean {
			return ((XInputGetState(_USER_ID).Buttons & buttonCode) != 0)
		}
		
		public function get state():XINPUT_GAMEPAD{
			return XInputGetState(_USER_ID)
		}
		
		/**
		 * usage:
		 * gp.state = [null,65535] <-- null for no change
		 */
		public function set rumble(values:Array):void {
			if (values.length!=2) {
				throw new ArgumentError("Invalid number of parameters. Expected: 2; got: "+String(values.length))
			} else if ( values[0]<0 ||values[0] > RUMBLE_MAX_VALUE){
				throw new ArgumentError("Invalid parameter 1 value: "+String(values[0]))
			} else if ( values[1]<0 ||values[1] > RUMBLE_MAX_VALUE){
				throw new ArgumentError("Invalid parameter 2 value: "+String(values[1]))
			} else {
				var lRumble:uint = uint(lastRumble[0])
				var rRumble:uint = uint(lastRumble[1])
				if (values[0]) {
					lRumble = values[0];
					lastRumble[0] = values[0];
				}
				if (values[1]) {
					rRumble = values[1];
					lastRumble[1] = values[1];
				}
				
				XInputSetState(_USER_ID,lRumble,rRumble)
			}
		}
		
		
        internal function isSupported():Boolean {
            return (XService.call("isSupported") as Boolean)
        }
        
        internal function XInputSetState(userIndex:uint, lRumble:uint, rRumble:uint):uint {
            return XService.call("XInputSetState", userIndex, lRumble, rRumble) as uint;
        }
        
        internal function XInputGetState(userIndex:uint):XINPUT_GAMEPAD {
            var state:String = XService.call("XInputGetState", userIndex) as String
            var gp:XINPUT_GAMEPAD = new XINPUT_GAMEPAD()
            gp.initWithJSON(state)
            return gp;
        }
        
        internal function XInputEnable(enable:Boolean):void {
            trace(XService.call("XInputEnable", enable) as Boolean);
            return;
        }
        
		
        /**
         * Yes, this IS a destroyer method in ActionScript ;P
         */
        public function _Gamepad():void {
            XService.dispose();
            extensionIsActive = false;
			//this = null;
			
        
        }
		
		public function get USER_ID():uint {
			return _USER_ID;
		}
    }
}