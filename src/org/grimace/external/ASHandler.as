// courtesy of http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/external/ExternalInterface.html

package org.grimace.external {
	import flash.events.*;
	import flash.net.LocalConnection;
	import org.grimace.core.Grimace;
	import org.grimace.core.EmotionCore;
	import org.grimace.utils.Capture;
	import org.grimace.events.UploadEvent;
	import org.grimace.external.ExternalCommands;
	import org.osflash.thunderbolt.Logger;	
	
	public class ASHandler extends EventDispatcher {
		public static const EMOTION_SET:String = EmotionCore.EMOTION_SET;
		public static const LOAD_COMPLETE:String = Grimace.LOAD_COMPLETE;
		public static const CAPTURE_COMPLETE:String = Capture.CAPTURE_COMPLETE;
		
		private static var _isReady:Boolean = false;
		private var commands:ExternalCommands;
		public var listeners:Object;
		private var grimace:Grimace;
		private var connection:LocalConnection;
		
		public function ASHandler(grimace:Grimace, commands:ExternalCommands) {
			this.grimace = grimace;
			
			initListeners();
		}
		
		private function initListeners():void {
			listeners = new Object();
			listeners[EMOTION_SET] = new Object();
			grimace.emotionCore.addEventListener(
				EMOTION_SET, function():void {
					dispatchEvent(new Event(EMOTION_SET));
				}
			);
			listeners[LOAD_COMPLETE] = new Object();
			grimace.addEventListener(
				LOAD_COMPLETE, function():void {
					dispatchEvent(new Event(LOAD_COMPLETE));
				}
			);
			listeners[CAPTURE_COMPLETE] = new Object();
			grimace.capture.addEventListener(
				CAPTURE_COMPLETE, function(e:UploadEvent):void {
					dispatchEvent(new UploadEvent(CAPTURE_COMPLETE, e.url));
				}
			);
		}
	}
}