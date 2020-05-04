package org.grimace.events {
	import flash.events.Event;

	public class UploadEvent extends Event {
		
		public var url:String;
		
		public function UploadEvent(type:String, url:String):void {
			super(type);
			this.url = url;
		}
	}
}