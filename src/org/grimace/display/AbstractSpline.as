package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class AbstractSpline implements ISpline {
		protected var _strokeCanvas:Sprite;
		protected var _fillCanvas:Sprite;
		
		protected var _mirrored:Boolean = false;
		protected var _lineColor:uint = 0x000000;
		protected var _lineWidth:Number = 1;
		protected var _lineMinWidth:Number = 1;
		protected var _lineMaxWidth:Number = 1;
		protected var _lineAlpha:Number = 1;
		protected var _fillColor:uint = 0x7f7f7f;
		protected var _fillAlpha:Number = 1;
		
		public function AbstractSpline():void {}
		
		public function drawStroke(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void {
			if (!strokeCanvas) {
				trace('no strokeCanvas defined');
				return;
			}
			
			strokeCanvas.graphics.lineStyle(lineWidth, lineColor, lineAlpha);
			
			traceSpline(strokeCanvas, !start, mirror);
		}
		
		public function drawFill(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void {
			if (!fillCanvas) {
				trace('no fillCanvas defined');
				return;
			}
			
			if (start) {
				fillCanvas.graphics.lineStyle(0, 0xFFFFFF, 0);
				fillCanvas.graphics.beginFill(fillColor, fillAlpha);
			}
			
			traceSpline(fillCanvas, !start, mirror);
			
			if (end) {
				fillCanvas.graphics.endFill();
			}
		}
		
		public function traceSpline(canvas:Sprite, nonstop:Boolean = false, mirror:Boolean = false, reverse:Boolean = false):void {
			new Error('AbstractSpline can not be instantiated.');
		}

		public function getPoint(t:Number, mirror:Boolean = false):Point { return null; }
		
		public function getPointsAsArray(visibleOnly:Boolean = false):Array {
			return null;
		}
		
		public function getStart():Point { return null; }
		
		public function getEnd():Point { return null; }
		
		public function getSlopeAngle(t:Number):Number {
			trace('getSlopeAngle does not work with AbstractSpline');
			return Number.NaN;
		}

		public function getNormalAngle(t:Number):Number {
			var angle:Number = getSlopeAngle(t) + Math.PI / 2;
/*			if (angle >= Math.PI * 2) {*/
/*				angle -= Math.PI * 2;*/
/*			}*/
			return angle;
		}
		
		public function clone():ISpline {
			new Error('AbstractSpline can not be instantiated.');
			return null;
		}
		
		public function reverse():void {
		}
		
		
		public function set strokeCanvas(s:Sprite):void {
			_strokeCanvas = s;
		}
		public function get strokeCanvas():Sprite { return _strokeCanvas; }
		
		public function set fillCanvas(s:Sprite):void {
			_fillCanvas = s;
		}
		public function get fillCanvas():Sprite { return _fillCanvas; }
		
		public function set fillColor(color:uint):void {
			_fillColor = color;
		}
		
		public function get fillColor():uint {
			return _fillColor;
		}

		public function set fillAlpha(alpha:Number):void {
			_fillAlpha = alpha;
		}
		
		public function get fillAlpha():Number {
			return _fillAlpha;
		}
		
		public function set lineColor(color:uint):void {
			_lineColor = color;
		}
		
		public function get lineColor():uint {
			return _lineColor;
		}

		public function set lineWidth(width:Number):void {
			_lineWidth = width;
		}
		
		public function get lineWidth():Number {
			return _lineWidth;
		}

		public function set lineMinWidth(width:Number):void {
			_lineWidth = width;
		}
		
		public function get lineMinWidth():Number {
			return _lineWidth;
		}

		public function set lineMaxWidth(width:Number):void {
			_lineWidth = width;
		}
		
		public function get lineMaxWidth():Number {
			return _lineWidth;
		}

		public function set lineAlpha(alpha:Number):void {
			_lineAlpha = alpha;
		}
		
		public function get lineAlpha():Number {
			return _lineAlpha;
		}
		
		public function set mirrored(isMirrored:Boolean):void {
			_mirrored = isMirrored;
		}
		
		public function get mirrored():Boolean {
			return _mirrored;
		}
	}
}
