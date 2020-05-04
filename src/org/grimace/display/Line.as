package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.grimace.display.AbstractSpline;
	
	public class Line extends AbstractSpline {
		private static const DT:Number = 0.01;
		
		public var p0:Point = new Point(0, 0);
		public var p1:Point = new Point(0, 0);
		
		public function Line(p0:Point, p1:Point):void {
			this.p0 = p0;
			this.p1 = p1;
		}
		
		override public function traceSpline(canvas:Sprite, nonstop:Boolean = false, mirror:Boolean = false, reverse:Boolean = false):void {
			
			var x0:Number, y0:Number, x1:Number, y1:Number;
			
			if (reverse) {
				x0 = p1.x;
				y0 = p1.y;
				x1 = p0.x;
				y1 = p0.y;
			}
			else {
				x0 = p0.x;
				y0 = p0.y;
				x1 = p1.x;
				y1 = p1.y;
			}
			
			if (mirror) {
				x0 *= -1;
				x1 *= -1;
			}
			
			if (!nonstop) {
				canvas.graphics.moveTo(x0, y0);
			}
			else {
				canvas.graphics.lineTo(x0, y0);
			}
			canvas.graphics.lineTo(x1, y1);
		}
		
		override public function getPoint(t:Number, mirror:Boolean = false):Point {
			var x:Number = p0.x + t * (p1.x - p0.x);
			var y:Number = p0.y + t * (p1.y - p0.y);
			
			if (mirror) {
				x = -x;
			}
			
			return new Point(x, y);
		}
		
		override public function getPointsAsArray(visibleOnly:Boolean = false):Array {
			var points:Array = new Array();
			points.push(p0);
			points.push(p1);
			return points;
		}
		
		override public function getStart():Point {
			return p0;
		}
		
		override public function getEnd():Point {
			return p1;
		}
		
		override public function getSlopeAngle(t:Number):Number {
			var pLeft:Point = getPoint(t - DT);
			var pRight:Point = getPoint(t + DT);
			return Math.atan( (pRight.y - pLeft.y) / (pRight.x - pLeft.x) );
		}
		
		override public function clone():ISpline {
			var line:Line = new Line(p0.clone(), p1.clone());
			line.strokeCanvas = this.strokeCanvas;
			line.fillCanvas   = this.fillCanvas;
			line.lineColor    = this.lineColor;
			line.lineWidth    = this.lineWidth; 
			line.lineAlpha    = this.lineAlpha;
			line.fillColor    = this.fillColor;
			line.fillAlpha    = this.fillAlpha;
			return line;
		}
		
		override public function reverse():void {
			var p0Old:Point = p0;
			var p1Old:Point = p1;
			p1 = p0Old;
			p0 = p1Old;
		}
	}
}
