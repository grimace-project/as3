package org.grimace.display { 
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import org.grimace.display.ISpline;
	import org.grimace.display.CubicBezier;
	import org.grimace.display.IStrokeStyle;
	
	public class BrushStyle implements IStrokeStyle {
		
		private static const HATCHES:int = 30;
		
		private var startWidth:Number;
		private var maxWidth:Number;
		private var endWidth:Number;
		private var strokeColor:uint;
		private var _strokeAlpha:Number;
		
		public function BrushStyle(
				startWidth:Number = 1.0,
				maxWidth:Number = 2.0,
				endWidth:Number = 1.0,
				strokeColor:uint = 0x000000,
				strokeAlpha:Number = 1.0
			) {
				
			this.startWidth = startWidth;
			this.maxWidth = maxWidth;
			this.endWidth = endWidth;
			this.strokeColor = strokeColor;
			this._strokeAlpha = strokeAlpha;
			
		}
		
		public function draw(start:Boolean, end:Boolean, spline:ISpline, mirror:Boolean = false, ...params):void {
			
			var upper:ISpline, lower:ISpline;
			var pLower:Array, pUpper:Array;
			var width:Number, angle:Number, t:Number;
			var dist:Point;
			var gr:Graphics;
			var i:int, lastPoint:int;
			var tDist:Number;
			
			lower = spline.clone();
			upper = spline.clone();

			pLower = lower.getPointsAsArray(true);
			pUpper = upper.getPointsAsArray(true);
			
			lastPoint = pLower.length - 1;
			tDist = 1 / (lastPoint);
			t = -tDist;


			for (i = 0; i <= lastPoint; i++) {
				if (i == 0) {
					width = startWidth;
				}
				else if (i == lastPoint) {
					width = endWidth;
				}
				else {
					width = maxWidth;
				}

				t += tDist;
				angle = spline.getNormalAngle(t);

				dist = Point.polar(width, angle);

				pLower[i].offset(dist.x, dist.y);
				pUpper[i].offset(-dist.x, -dist.y);
			}
			
			
			// draw
			var sign:Number = (mirror) ? -1 : 1;
			
			var startLowerX:Number = lower.getStart().x * sign;
			var startLowerY:Number = lower.getStart().y;
			var endLowerX:Number = lower.getEnd().x * sign;
			var endLowerY:Number = lower.getEnd().y;
			
			var startUpperX:Number = upper.getStart().x * sign;
			var startUpperY:Number = upper.getStart().y;
			var endUpperX:Number = upper.getEnd().x * sign;
			var endUpperY:Number = upper.getEnd().y;
			
			var startSplineX:Number = spline.getStart().x * sign;
			var startSplineY:Number = spline.getStart().y;
			var endSplineX:Number = spline.getEnd().x * sign;
			var endSplineY:Number = spline.getEnd().y;
			
			gr = spline.strokeCanvas.graphics;
			
			gr.moveTo(startSplineX, startSplineY);
			
			gr.beginFill(strokeColor, _strokeAlpha);
			
			// TODO: how do you solve the sharp edges at the ends?
			gr.lineTo(startLowerX, startLowerY);
			lower.traceSpline(spline.strokeCanvas, true, mirror, false);
			gr.lineTo(endSplineX, endSplineY);
			
			gr.lineTo(endUpperX, endUpperY);
			upper.traceSpline(spline.strokeCanvas, true, mirror, true);
			gr.lineTo(startSplineX, startSplineY);
			
			gr.endFill();

			gr.moveTo(endSplineX, endSplineY);
		}

		
		private function interpolate(one:Number, two:Number, weight:Number):Number {
			return one * (1 - weight) + two * weight;
		}
		
		
		public function set strokeAlpha(a:Number):void {
			_strokeAlpha = a;
		}
		public function get strokeAlpha():Number {
			return strokeAlpha;
		}
	}
}