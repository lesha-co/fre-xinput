package com.amdevcorp.FREXInput {
	import flash.events.Event;
	/**
	 * ...
	 * @author am_devcorp
	 */
	public class GamepadEvent extends Event{
		public static const RELEASE:String = "release";
		public static const PRESS:String = "press";
		public static const STICK_MOVED:String = "stick";
		public static const TRIGGER_MOVED:String = "trigger";
		public var key:uint;
		public var state:XINPUT_GAMEPAD;
		/**
		 * 
		 * @param	type what happened?
		 * @param	key which button has been changed? (values from Gamepad.as, provide 0x1000 for A button, 0 for sticks/triggers)
		 * @param	state new state of the gamepad
		 */
		public function GamepadEvent (type:String, state:XINPUT_GAMEPAD,key:uint = 0) {
			super(type);
			this.key = key;
			this.state = state;
		}
		
	}

}