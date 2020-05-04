package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Joiner extends CubicBezier {
		// cubic bezier which achieves c1 continuity with its neighbours
		// http://en.wikipedia.org/wiki/Parametric_continuity
		
		public var a:Point = new Point(0, 0);
		public var b:Point = new Point(0, 0);
		
		public var a_factor:Number = 1/3;
		public var b_factor:Number = 1/3 ;
		
		public function Joiner(a:Point, c0:Point, c3:Point, b:Point):void {
			this.a = a;
			this.b = b;
			super(c0, new Point(0,0), new Point(0,0), c3);
			evaluate();
		}
		
		override protected function evaluate():void {
			var dist_c0c3:Number = Point.distance(c0, c3);
			var dist_c0a:Number = Point.distance(c0, a);
			var dist_c3b:Number = Point.distance(c3, b);
			
			var f_a:Number = dist_c0c3 * a_factor / dist_c0a;
			var f_b:Number = dist_c0c3 * b_factor / dist_c3b;
			
			c1.x = c0.x + (c0.x - a.x) * f_a;
			c1.y = c0.y + (c0.y - a.y) * f_a;
			c2.x = c3.x + (c3.x - b.x) * f_b;
			c2.y = c3.y + (c3.y - b.y) * f_b;
			
			super.evaluate();
		}
		
		override public function getPointsAsArray(visibleOnly:Boolean = false):Array {
			var points:Array = new Array();
			if (!visibleOnly) {
				points.push(a);
			}
			
			points.push(c0);
			points.push(c1);
			points.push(c2);
			points.push(c3);
			
			if (!visibleOnly) {
				points.push(b);
			}
			return points;
		}
		
		override public function clone():ISpline {
			var joiner:Joiner = new Joiner(
				a.clone(), c0.clone(), c3.clone(), b.clone()
			);
			joiner.strokeCanvas = this.strokeCanvas;
			joiner.fillCanvas   = this.fillCanvas;
			joiner.lineColor    = this.lineColor;
			joiner.lineWidth    = this.lineWidth; 
			joiner.lineAlpha    = this.lineAlpha;
			joiner.fillColor    = this.fillColor;
			joiner.fillAlpha    = this.fillAlpha;
			return joiner;
		}
		
		override public function reverse():void {
			var aOld:Point = a;
			var bOld:Point = b;
			a = bOld;
			b = aOld;
			super.reverse();
		}
	}
}