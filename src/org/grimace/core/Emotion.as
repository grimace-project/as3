package org.grimace.core {
	import flash.events.EventDispatcher;	
	import flash.events.Event;
	import flash.display.Sprite; 
	import org.grimace.core.Muscle;
	import org.grimace.display.IMapping;
	import org.grimace.events.SliderEvent;
	
	public class Emotion extends Sprite {
		public static const VALUECHANGED:String = "valuechanged";
		
		public var influences:Object;
		private var _value:Number = 0.0;

		public var weight:Number = 1.0;
		public var label:String;
		
		public function Emotion(label:String):void {
			this.label = label;
			influences = new Object();
		}
		
		public function addInfluence(muscle:Muscle, mapping:IMapping, priority:Number = 1.0):void {
			var id:String = muscle.id;
			
			var entry:Object = new Object();
			entry.muscle = muscle;
			entry.mapping = mapping;
			entry.priority = priority;
			entry.emotion = this;
			entry.muscle.prioritySum += priority;
			
			influences[id] = entry;
		}
		
		public function evaluate():void {
			var y:Number, t:Number, priority:Number, prioritySum:Number;
			for each (var i:Object in influences) {
				
				// tensions are saved from each emotion
				// evaluated later for each muscle
				if (value == 0.0) {
					return;
				}
				
				var entry:Object = new Object();
				entry.tension = i.mapping.y(value);
				entry.priority = i.priority;
				entry.emotion = this;
				i.muscle.rawTensions.push(entry);
			}
		}
		
		
		
		public function set value(v:Number):void {
			_value = Math.min(Math.max(v, 0.0), 1.0);
			
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, v));
		}
		
		public function get value():Number {
			return _value;
		}
	}
}
