package org.grimace.core { 
	import flash.display.Sprite; 
	import flash.events.*;
	import flash.geom.Point;
	import org.grimace.display.ISpline;
	import org.grimace.events.SliderEvent

	/*import org.osflash.thunderbolt.Logger;*/
	
	public class Muscle extends EventDispatcher{
		public var spline:ISpline;
		private var lastTension:Number;
		private var goalTension:Number;
		private var _tension:Number = 0.0;
		
		public var prioritySum:Number = 0.0;
		public var rawTensions:Array;
		
		public var initTension:Number;
		public var id:String;
		
		public function Muscle(id:String, spline:ISpline, canvas:Sprite, initTension:Number = 0.0):void { 
			this.spline = spline;
			spline.strokeCanvas = canvas;
			this.id = id;
			
			this.initTension = initTension;
			tension = initTension;
			
			rawTensions = new Array();
		} 
		
		public function draw():void {
			spline.drawStroke();
		}
		
		public function getPoint():Point {
			return spline.getPoint(_tension);
		}
		
		public function getInitPoint():Point {
			return spline.getPoint(initTension);
		}
		
		public function set tension(t:Number):void {
			_tension = t;
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, t));
		}
		
		public function get tension():Number {
			return _tension;
		}
		
		public function saveTension():void {
			lastTension = _tension;
		}
		
		public function evaluate():void {
			
			var t:Number = initTension;
			var valueSum:Number = 0.0;
			for each (var entry:Object in rawTensions) {
				valueSum += entry.emotion.value * entry.priority;
			}
			for each (entry in rawTensions) {
				t += entry.tension * entry.emotion.value * entry.priority / valueSum;
			}
			tension = t;
			goalTension = t;
		}
		
		public function clear():void {
			_tension = initTension;
			rawTensions = new Array();
		}
		
		public function interpolate(t:Number):void {
			_tension = (1 - t) * lastTension + t * goalTension;
		}
		
	}
} 
