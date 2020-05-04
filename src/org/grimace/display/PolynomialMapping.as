package org.grimace.display {
	
	public class PolynomialMapping implements IMapping {
		private var params:Object;
		private var x0:Number;
		
		public function PolynomialMapping(x0:Number, params:Object) {
			this.x0 = x0;
			this.params = params;
		}
		
		public function y(x:Number):Number {
			x -= x0;
			
			var y:Number = 0;
			var value:Number, exponent:int;
			
			for (var i:String in params) {
				exponent = int(i);
				value = params[i];
				
				y += value * Math.pow(x, exponent);
			}
			
			return y;
		}
	}
}