package org.grimace.controls {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;	
	import flash.geom.Point;
	import org.grimace.events.SliderEvent;
	import org.grimace.display.ISpline;


	public class SplineSlider extends Sprite {
		private static const NUM_RECURSIONS:Number = 15;
		
		public var knob:Sprite;
		public var spline:ISpline;
		private var radius:Number = 5;
		private var _value:Number = 0.0;
		
		public function SplineSlider(spline:ISpline):void {
			this.spline = spline;
			
			knob = new Sprite();
			knob.graphics.beginFill(0x909090);
			knob.graphics.lineStyle(1, 0x909090, 1);
			knob.graphics.drawCircle(0, 0, radius);
			addChild(knob);
			knob.addEventListener(MouseEvent.MOUSE_DOWN, knobClick);
			
			value = 0;
		}
		
		private function knobClick(evt:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, knobDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, knobDragStop);
		}
		
		private function knobDrag(args:MouseEvent):void {
			value = nearestPoint(new Point(mouseX, mouseY));
			announceDrag();
		}
		
		private function knobDragStop(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, knobDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, knobDragStop);
		}
		
		public function set value(v:Number):void {
			_value = v;
			moveKnob(v);
		}
		
		public function get value():Number {
			return _value;
		}
		
		private function moveKnob(v:Number):void {
			var point:Point = spline.getPoint(v);
			knob.x = point.x;
			knob.y = point.y;
		}
		
		public function dragSlider(v:Number):void {
			value = v;
			announceDrag();
		}
		
		private function announceDrag():void {
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, value));
		}
		
		// no easy analytical solution for nearest point to arbitrary point
		// see also http://www.tinaja.com/glib/bezdist.pdf
		public function nearestPoint(goal:Point):Number {
			return divide(goal, Infinity, 0.0, 1.0, NUM_RECURSIONS);
		}
		
		private function divide(goal:Point, distMin:Number, start:Number, end:Number, recursions:Number):Number {
			var distStart:Number = Point.distance(goal, spline.getPoint(start));
			var distEnd:Number   = Point.distance(goal, spline.getPoint(end));
			
			if (recursions < 0)
				return start;
			
			var mid:Number = 0;
			
			if (distMin > distStart || distMin > distEnd) {
				if (distStart < distEnd)
					mid = divide(goal, distMin, start, (start + end) / 2, recursions - 1);
				else
					mid = divide(goal, distMin, (start + end) / 2, end, recursions - 1);
			}
			
			return mid;
		}
	}
}