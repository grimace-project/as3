package org.grimace.events {
	import flash.events.Event;

	public class SliderEvent extends Event {
		public static const VALUECHANGED:String = "valuechanged"
		
		public var value:Number;
		
		public function SliderEvent(type:String, value:Number):void {
			super(type);
			this.value = value;
		}
	}
}