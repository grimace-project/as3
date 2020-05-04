package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.grimace.display.AbstractSpline;
	
	public class QuadraticBezier extends AbstractSpline {
		private static const DT:Number = 0.01;
		
		public var aPt1:Point = new Point(0, 0);
		public var aPt2:Point = new Point(0, 0);
		public var cPt:Point = new Point(0, 0);
		
		public function QuadraticBezier(aPt1:Point, cPt:Point, aPt2:Point):void {
			this.aPt1 = aPt1;
			this.cPt = cPt;
			this.aPt2 = aPt2;
		}
		
		override public function traceSpline(canvas:Sprite, nonstop:Boolean = false, mirror:Boolean = false, reverse:Boolean = false):void {
			
			var x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number;
			
			x1 = cPt.x;
			y1 = cPt.y;
			
			if (reverse) {
				x0 = aPt2.x;
				y0 = aPt2.y;
				x2 = aPt1.x;
				y2 = aPt1.y;
			}
			else {
				x0 = aPt1.x;
				y0 = aPt1.y;
				x2 = aPt2.x;
				y2 = aPt2.y;
			}
			
			if (mirror) {
				x0 *= -1;
				x1 *= -1;
				x2 *= -1;
			}
			
			
			if (!nonstop) {
				canvas.graphics.moveTo(x0, y0);
			}
			else {
				canvas.graphics.lineTo(x0, y0);
			}
			canvas.graphics.curveTo(x1, y1, x2, y2);
			
/*			if (!fillCanvas) return;
			
			fillCanvas.graphics.beginFill(0xf77777, 0.3)
			fillCanvas.graphics.drawCircle(x0, y0, 1);
			fillCanvas.graphics.beginFill(0x77f777, 0.3)
			fillCanvas.graphics.drawCircle(x1, y1, 1);
			fillCanvas.graphics.beginFill(0x7777f7, 0.3)
			fillCanvas.graphics.drawCircle(x2, y2, 1);
			fillCanvas.graphics.endFill();
*/		}

		override public function getPoint(t:Number, mirror:Boolean = false):Point {
			var omt:Number = 1 - t;
			
			var x:Number = aPt1.x * omt * omt
			             + cPt.x * 2 * t * omt
			             + aPt2.x * t * t;
			
			var y:Number = aPt1.y * omt * omt
			             + cPt.y * 2 * t * omt
			             + aPt2.y * t * t;
			
			if (mirror) {
				x = -x;
			}
			
			return new Point(x, y);
		}
		
		override public function getPointsAsArray(visibleOnly:Boolean = false):Array {
			var points:Array = new Array();
			points.push(aPt1);
			points.push(cPt);
			points.push(aPt2);
			return points;
		}
		
		override public function getStart():Point {
			return aPt1;
		}
		
		override public function getEnd():Point {
			return aPt2;
		}
		
		override public function getSlopeAngle(t:Number):Number {
			var pLeft:Point = getPoint(t - DT);
			var pRight:Point = getPoint(t + DT);
			return Math.atan( (pRight.y - pLeft.y) / (pRight.x - pLeft.x) );
		}
		
		override public function clone():ISpline {
			var quad:QuadraticBezier = new QuadraticBezier(
				aPt1.clone(), cPt.clone(), aPt2.clone()
			);
			quad.strokeCanvas = this.strokeCanvas;
			quad.fillCanvas   = this.fillCanvas;
			quad.lineColor    = this.lineColor;
			quad.lineWidth    = this.lineWidth; 
			quad.lineAlpha    = this.lineAlpha;
			quad.fillColor    = this.fillColor;
			quad.fillAlpha    = this.fillAlpha;
			return quad;
		}
		
		override public function reverse():void {
			var aPt1Old:Point = aPt1;
			var aPt2Old:Point = aPt2;
			aPt1 = aPt2Old;
			aPt2 = aPt1Old;
		}
	}
}
