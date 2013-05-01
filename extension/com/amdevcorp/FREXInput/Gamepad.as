//Apparently, the main class of the extension!

package com.amdevcorp.FREXInput {
    
	import adobe.utils.CustomActions;
	import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.events.EventDispatcher;
    import com.amdevcorp.FREXInput.XINPUT_GAMEPAD;
    import flash.external.ExtensionContext;
    import flash.utils.Timer;
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
		// UNALLICATED                           0x0800;
        public static const A          :uint = 0x1000;
        public static const B          :uint = 0x2000;
        public static const X          :uint = 0x4000;
        public static const Y          :uint = 0x8000;
        private static const buttonBitmasksArray:Array = [DPAD_UP, DPAD_DOWN, DPAD_LEFT, DPAD_RIGHT,
												  START, BACK, LSTICK, RSTICK,
												  LB, RB, GUIDE, A, B, X, Y];
        internal static var extensionIsActive:Boolean // == false by default
        private var _USER_ID:uint
		private var lastState:XINPUT_GAMEPAD = new XINPUT_GAMEPAD()// only used for discovering changes
		private var lastRumble:Array;
        private var updateTimer:Timer;
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
			if (id >= XUSER_MAX_COUNT) {
                throw new ArgumentError("Wrong id:" + String(id), ERROR_WRONG_ID);
            }
			// all green
			_USER_ID = id;
			lastRumble = [0, 0];
			
			updateTimer = new Timer(30); // nearly 30 times/sec
			updateTimer.addEventListener(TimerEvent.TIMER, onUpdate);
			updateTimer.start();
        
        }
		
		private function onUpdate(e:TimerEvent):void {
			var newState:XINPUT_GAMEPAD = XInputGetState(_USER_ID);
			//calculating differences in button states
			var differences:uint = newState.Buttons ^ lastState.Buttons;
			for each (var i:uint in buttonBitmasksArray) {
				// bithacks!
				if (differences & i) { //if this button has been changed
					var EventType:String;
					if (newState.Buttons &i) { // if button has been pressed
						EventType = GamepadEvent.PRESS;
					} else { // or released
						EventType = GamepadEvent.RELEASE;
					}
					dispatchEvent(new GamepadEvent(EventType, newState, i));
				}
			}
			//if sticks have been moved (99% they have)
			if ((newState.LStick.x != lastState.LStick.x) ||
				(newState.LStick.y != lastState.LStick.y) ||
				(newState.RStick.x != lastState.RStick.x) ||
				(newState.RStick.y != lastState.RStick.y)) {
				dispatchEvent(new GamepadEvent(GamepadEvent.STICK_MOVED, newState));
			}
			//if triggers have been moved
			if ((newState.LTrigger != lastState.LTrigger) ||
				(newState.RTrigger != lastState.RTrigger)) {
				dispatchEvent(new GamepadEvent(GamepadEvent.TRIGGER_MOVED, newState));
			}
			lastState = newState;
		}
		
        public function isPressed(buttonCode:uint):Boolean {
			return ((XInputGetState(_USER_ID).Buttons & buttonCode) != 0)
		}
		
		public function get state():XINPUT_GAMEPAD{
			return XInputGetState(_USER_ID)
		}
		
		/**
		 * usage:
		 * gp.rumble = [null,65535] <-- null for no change
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
				if (values[0] != null) {
					lRumble = values[0];
					lastRumble[0] = values[0];
				}
				if (values[1] != null) {
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
            var state:String = XService.call("XInputGetState", userIndex) as String;
            var gp:XINPUT_GAMEPAD = new XINPUT_GAMEPAD(state);
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
			//TODO: this
            //this = null;
			
        
        }
		
		public function get USER_ID():uint {
			return _USER_ID;
		}
    }
}