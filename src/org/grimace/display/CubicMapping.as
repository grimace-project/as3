package org.grimace.display {
	
	public class CubicMapping implements IMapping {
		private var p0:Number, p1:Number, p2:Number, p3:Number;
		private var x0:Number;
		
		public function CubicMapping(x0:Number = 0.0, p3:Number = 0.0, p2:Number = 0.0, p1:Number = 0.0, p0:Number = 0.0) {
			this.p3 = p3;
			this.p2 = p2;
			this.p1 = p1;
			this.p0 = p0;
			this.x0 = x0;
		}
		
		public function y(x:Number):Number {
			if (x <= x0)
				return 0;
			
			x -= x0;
			
			return p3 * x*x*x + p2 * x*x + p1 * x + p0;
		}
	}
}