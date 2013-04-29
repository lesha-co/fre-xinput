package com.amdevcorp.FREXInput
{
    import com.amdevcorp.FREXInput.XINPUT_GAMEPAD;
    import flash.external.ExtensionContext;
    
    public class FREXInputLib
    {
        private var _ctx:ExtensionContext;
        
        public function FREXInputLib() 
        {
            _ctx = ExtensionContext.createExtensionContext("com.amdevcorp.ane.FREXInput", null);
        } 
        
        public function isSupported():Boolean
        {
            return (_ctx.call("isSupported") as Boolean)
        };
        public function activate():Boolean
        {
            var success:Boolean = _ctx.call("activate") as Boolean;
            if(!success) trace("Attention, extension failed to start normally");
            return (success)
        };
        
        
        public function XInputSetState(userIndex:uint, lRumble:uint, rRumble:uint):uint
        {
            return _ctx.call("XInputSetState",userIndex,lRumble,rRumble) as uint;
        }
        
        public function XInputGetState(userIndex:uint):XINPUT_GAMEPAD
        {
            var state:String = _ctx.call("XInputGetState",userIndex) as String
            var gp:XINPUT_GAMEPAD = new XINPUT_GAMEPAD()
            gp.initWithJSON(state)
            return gp;
        };
        
        public function XInputEnable(enable:Boolean):void
        {
            trace( _ctx.call("XInputEnable",enable) as Boolean);
            return;
        }
        
        
        public function dispose():void
        {
            _ctx.dispose();
        }	
    }
}