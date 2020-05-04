// courtesy of http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/external/ExternalInterface.html

package org.grimace.external {
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	import flash.system.Capabilities;
	import org.grimace.core.Grimace;
	import org.grimace.core.EmotionCore;
	import org.grimace.utils.Capture;
	import org.grimace.events.UploadEvent;
	import org.grimace.external.ExternalCommands;
	import org.osflash.thunderbolt.Logger;	
	
	public class JSHandler extends EventDispatcher {
		
		private static var _isReady:Boolean = false;
		private var commands:ExternalCommands;
		public var listeners:Object;
		private var grimace:Grimace;
		
		public function JSHandler(grimace:Grimace, commands:ExternalCommands) {
			this.grimace = grimace;
			this.commands = commands;
			
			if (ExternalInterface.available &&
				 ( Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn" )
				) {
				try {
					
					if (isReady) {
						init();
					}
					else {
						Logger.info("JSHandler: JavaScript is not ready, creating timer.");
						var readyTimer:Timer = new Timer(100, 100);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				}
				catch (error:SecurityError) {
					Logger.info("JSHandler: A SecurityError occurred: " + error.message);
				}
				catch (error:Error) {
					Logger.info("JSHandler: An Error occurred: " + error.message);
				}
			}
		}
		
		private function timerHandler(event:TimerEvent):void {
			Logger.info("JSHandler: Checking JavaScript status...");
			
			if (isReady) {
				Logger.info("JSHandler: JavaScript is ready.");
				Timer(event.target).stop();
				init();
			}
		}
		
		private function init():void {
			initListeners();
			initCallbacks(commands);
		}
		
		private static function get isReady():Boolean {
			_isReady = ExternalInterface.call("isReady");
			return _isReady;
		}
		
		private function initCallbacks(c:ExternalCommands):void {
			ExternalInterface.addCallback('log', c.log);
			ExternalInterface.addCallback('isReady', c.isReady);
			ExternalInterface.addCallback('setCaptureUrl', c.setCaptureUrl);
			ExternalInterface.addCallback('setEmotion', c.setEmotion);
			ExternalInterface.addCallback('resetEmotion', c.resetEmotion);
			ExternalInterface.addCallback('getEmotion', c.getEmotion);
			ExternalInterface.addCallback('loadFacedata', c.loadFacedata);
			ExternalInterface.addCallback('capture', c.capture);
			ExternalInterface.addCallback('draw', c.draw);
			ExternalInterface.addCallback('setPosition', c.setPosition);
			ExternalInterface.addCallback('getPosition', c.getPosition);
			ExternalInterface.addCallback('setMaxBounds', c.setMaxBounds);
			ExternalInterface.addCallback('getMaxBounds', c.getMaxBounds);
			ExternalInterface.addCallback('setScaleMode', c.setScaleMode);
			ExternalInterface.addCallback('setScale', c.setScale);
			ExternalInterface.addCallback('restart', c.restart);
			
			ExternalInterface.addCallback('addEventListener', addJSEventListener);
			ExternalInterface.addCallback('removeEventListener', removeJSEventListener);
		}
		
		
		// event handling
		private function initListeners():void {
			listeners = new Object();
			listeners[EmotionCore.EMOTION_SET] = new Object();
			grimace.emotionCore.addEventListener(
				EmotionCore.EMOTION_SET, handleEvent
			);
			listeners[Grimace.LOAD_COMPLETE] = new Object();
			grimace.addEventListener(
				Grimace.LOAD_COMPLETE, handleEvent
			);
			listeners[Capture.CAPTURE_COMPLETE] = new Object();
			grimace.capture.addEventListener(
				Capture.CAPTURE_COMPLETE, handleUploadEvent
			);
		}
		
		private function handleEvent(e:Event):void {
			for (var callback:String in listeners[e.type]) {
				/*Logger.info('calling '+e.type + ' ' + callback);*/
				try {
					var functionName:String = callback;
					ExternalInterface.call(functionName);
				}
				catch (e:Error) {
					Logger.error(e);
				}
			}
		}
		
		private function handleUploadEvent(e:UploadEvent):void {
			for (var callback:String in listeners[e.type]) {
				/*Logger.info('calling '+e.type + ' ' + callback);*/
				try {
					var functionName:String = callback;
					ExternalInterface.call(functionName, e);
				}
				catch (e:Error) {
					Logger.error(e);
				}
			}
		}
		
		/**
		*	Registers an event listener for JavaScript.
		*	
		*	@param eventType Event type to listen to. See event page for available events.
		*	@param callback Function name to be called when the event is triggered.
		*	
		*	@return Returns true if listener was registered successfully.
		*	
		*	@see events.html Events
		*/
		public function addJSEventListener(eventType:String, callback:String):Boolean {
			if (!listeners[eventType]) {
				return false;
			}
			listeners[eventType][callback] = true;
			return true;
		}
		
		/**
		*	Removes a previously registered event listener for JavaScript.
		*	
		*	<p>Multiple listeners can be registered for one event type. Thus,
		*	eventType and callback must be supplied to unregister the
		*	corresponding listener.</p>
		*	
		*	@param eventType Event type for which to unregister a listener.
		*	@param callback Function name for which listener was registered.
		*	
		*	@return Returns true if listener was removed successfully.
		*	
		*	@see events.html Events
		*/
		public function removeJSEventListener(eventType:String, callback:String):Boolean {
			return delete listeners[eventType][callback];
		}
	}
}