package org.grimace.display {
	
	public class SineMapping implements IMapping {
		private var x0:Number, x1:Number, y0:Number, y1:Number;
		
		public function SineMapping(
			x0:Number = 0.0, x1:Number = 1.0, y0:Number = 0.0, y1:Number = 1.0
			) {
			this.x0 = x0;
			this.x1 = x1;
			this.y0 = y0;
			this.y1 = y1;
		}
				
		public function y(x:Number):Number {
			if (x <= x0) {
				return y0;
			}
			else if (x >= x1) {
				return y1;
			}
			
			x -= x0;
			
			var pi:Number = Math.PI;
			var y:Number;
			y = (0.5 * Math.sin(pi * (x / (x1-x0) + 1.5)) + 0.5) * (y1-y0) + y0;
			return y;
		}
	}
}