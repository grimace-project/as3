package org.grimace.display {
	import flash.geom.Point;
	import flash.display.Sprite;
	import org.grimace.display.AbstractSpline;
	import org.grimace.display.QuadraticBezier;
	
	public class CubicBezier extends AbstractSpline {
		
		private static const DT:Number = 0.01;
		
		public var c0:Point;
		public var c1:Point;
		public var c2:Point;
		public var c3:Point;
		
		private var quadratics:Array;
		
		public function CubicBezier(c0:Point, c1:Point, c2:Point, c3:Point):void {
			this.c0 = c0;
			this.c1 = c1;
			this.c2 = c2;
			this.c3 = c3;
			
			quadratics = new Array();
			for (var i:Number = 0; i < 4; i++) {
				quadratics[i] = new QuadraticBezier(
					new Point(0,0), new Point(0,0), new Point(0,0)
				);
			}
			
			evaluate();
		}
		
		protected function evaluate():void {
			// fixed midpoint cubic bezier approximation from
			// http://timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm
			
			var c0c1:Point = Point.interpolate(c0, c1, 0.5);
			var c1c2:Point = Point.interpolate(c1, c2, 0.5);
			var c2c3:Point = Point.interpolate(c2, c3, 0.5);
			
			var c0c1c1c2:Point = Point.interpolate(c0c1, c1c2, 0.5);
			var c1c2c2c3:Point = Point.interpolate(c1c2, c2c3, 0.5);
			
			var s0_0:Point = c0.clone();
			var s3_2:Point = c3.clone();
			
			var s0_1:Point = Point.interpolate(c0, c0c1, 0.25);
			
			var s3_1:Point = Point.interpolate(c2c3, c3, 0.75);
			
			var s1_2:Point = Point.interpolate(c0c1c1c2, c1c2c2c3, 0.5);
			var s2_0:Point = s1_2;
			
			var s1_1:Point = Point.interpolate(c0c1c1c2, s1_2, 0.75);
			
			var s2_1:Point = Point.interpolate(s1_2, c1c2c2c3, 0.25);
			
			var s0_2:Point = Point.interpolate(s0_1, s1_1, 0.5);
			var s1_0:Point = s0_2;
			
			var s2_2:Point = Point.interpolate(s2_1, s3_1, 0.5);
			var s3_0:Point = s2_2;
			
			
			quadratics[0].aPt1 = s0_0;
			quadratics[0].cPt  = s0_1;
			quadratics[0].aPt2 = s0_2;
			quadratics[1].aPt1 = s1_0;
			quadratics[1].cPt  = s1_1;
			quadratics[1].aPt2 = s1_2;
			quadratics[2].aPt1 = s2_0;
			quadratics[2].cPt  = s2_1;
			quadratics[2].aPt2 = s2_2;
			quadratics[3].aPt1 = s3_0;
			quadratics[3].cPt  = s3_1;
			quadratics[3].aPt2 = s3_2;
		}
		
		private function init():void {
			for each (var q:QuadraticBezier in quadratics) {
				q.mirrored = mirrored;
				q.fillAlpha = fillAlpha;
				q.fillColor = fillColor;
				q.lineAlpha = lineAlpha;
				q.lineColor = lineColor;
				q.lineWidth = lineWidth;
			}
		}
	
		override public function drawStroke(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void {
			if (strokeCanvas == null)
				return;
			
			evaluate();
			
			var startQuad:Boolean, endQuad:Boolean;
			
			for (var i:int = 0; i < quadratics.length; i++) {
				startQuad = start && (i == 0);
				endQuad = end && (i == (quadratics.length - 1));
				
				quadratics[i].drawStroke(startQuad, endQuad, mirror);
			}
		}
		
		override public function drawFill(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void {
			if (fillCanvas == null)
				return;
			
			evaluate();
			
			var startQuad:Boolean, endQuad:Boolean;
			var lastQuad:int = quadratics.length - 1;
			
			for (var i:int = 0; i < quadratics.length; i++) {
				startQuad = start && (i == 0);
				endQuad = end && (i == lastQuad);
				
				quadratics[i].drawFill(startQuad, endQuad, mirror);
			}
		}
		
		override public function traceSpline(canvas:Sprite, nonstop:Boolean = false, mirror:Boolean = false, reverse:Boolean = false):void {
			evaluate();
			
			var i:int;
			
			if (reverse) {
				for (i = quadratics.length - 1; i >= 0; i--) {
					quadratics[i].traceSpline(canvas, nonstop, mirror, reverse);
				}
			}
			else {
				for (i = 0; i < quadratics.length; i++) {
					quadratics[i].traceSpline(canvas, nonstop, mirror, reverse);
				}
			}
		}
		
		override public function getPoint(t:Number, mirror:Boolean = false):Point {
			// TODO: improve getPoint method
/*			var quad:int = t * 4.0;*/
/*			trace(quad + ' ' + t * 4.0 % 1);*/
			
			if (t < 0 || t > 1) {
				trace('out of bounds');
				return null;
			}
			
/*			else if (t == 0.0)
				return c0;
			else if (t == 1.0)
				return c3;
*/			else if (t < 0.25)
				return quadratics[0].getPoint(t * 4.0, mirror);
			else if (t < 0.5)
				return quadratics[1].getPoint((t - 0.25) * 4.0, mirror);
			else if (t < 0.75)
				return quadratics[2].getPoint((t - 0.5) * 4.0, mirror);
			else
				return quadratics[3].getPoint((t - 0.75) * 4.0, mirror);
		}

		override public function getSlopeAngle(t:Number):Number {
			var pLeft:Point = getPoint(Math.max(t - DT, 0));
			var pRight:Point = getPoint(Math.min(t + DT, 1));
			
			var dx:Number = pRight.x - pLeft.x
			var dy:Number = pRight.y - pLeft.y;
			
			var angle:Number = Math.atan(dy / dx);
			
			// arctan problem:
			// http://hyperphysics.phy-astr.gsu.edu/hbase/ttrig.html#c3
			if (dx < 0) {   // quadrants II & III
				angle += Math.PI;
			}
			else if (dx >= 0 && dy < 0) {   // quadrant IV
				angle += 2.0 * Math.PI;
			}
			
			return angle;
		}

		
		override public function getPointsAsArray(visibleOnly:Boolean = false):Array {
			var points:Array = new Array();
			points.push(c0);
			points.push(c1);
			points.push(c2);
			points.push(c3);
			return points;
		}
		
		override public function getStart():Point {
			return c0;
		}
		
		override public function getEnd():Point {
			return c3;
		}
		
		public function setDebugColors():void {
			lineColor = 0x90003A;
			lineColor = 0x00FB50;
			lineColor = 0xFF0010;
			lineColor = 0x1050AB;
		}
		
		override public function clone():ISpline {
			var cubic:CubicBezier = new CubicBezier(
				c0.clone(), c1.clone(), c2.clone(), c3.clone()
			);
			cubic.strokeCanvas = this.strokeCanvas;
			cubic.fillCanvas   = this.fillCanvas;
			cubic.lineColor    = this.lineColor;
			cubic.lineWidth    = this.lineWidth; 
			cubic.lineAlpha    = this.lineAlpha;
			cubic.fillColor    = this.fillColor;
			cubic.fillAlpha    = this.fillAlpha;
			return cubic;
		}
		
		override public function reverse():void {
			var c0Old:Point = c0;
			var c1Old:Point = c1;
			var c2Old:Point = c2;
			var c3Old:Point = c3;
			c0 = c3Old;
			c1 = c2Old;
			c2 = c1Old;
			c3 = c0Old;
			
			for (var i:Number = 0; i < 4; i++) {
				quadratics[i].reverse();
			}
		}
		
		override public function set strokeCanvas(s:Sprite):void {
			_strokeCanvas = s;
			
			for (var i:Number = 0; i < 4; i++) {
				quadratics[i].strokeCanvas = s;
			}
			
			init();
		}
		
		override public function set fillCanvas(s:Sprite):void {
			_fillCanvas = s;
			
			for (var i:Number = 0; i < 4; i++) {
				quadratics[i].fillCanvas = s;
			}
			
			init();
		}
		
		override public function set fillColor(color:uint):void {
			_fillColor = color;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.fillColor = color;
			}
		}

		override public function set fillAlpha(alpha:Number):void {
			_fillAlpha = alpha;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.fillAlpha = alpha;
			}
		}
		
		override public function set lineColor(color:uint):void {
			_lineColor = color;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.lineColor = color;
			}
		}

		override public function set lineWidth(width:Number):void {
			_lineWidth = width;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.lineWidth = width;
			}
		}

		override public function set lineAlpha(alpha:Number):void {
			_lineAlpha = alpha;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.lineAlpha = alpha;
			}
		}
		
		override public function set mirrored(isMirrored:Boolean):void {
			_mirrored = isMirrored;
			
			for each (var q:QuadraticBezier in quadratics) {
				q.mirrored = isMirrored;
			}
		}
	}
}