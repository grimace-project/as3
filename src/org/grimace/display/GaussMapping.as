package org.grimace.display {
	
	public class GaussMapping implements IMapping {
		private var a:Number, b:Number, c:Number;
		
		public function GaussMapping(
			mean:Number, variance:Number, value:Number = 1.0
			) {
			
			this.c = Math.sqrt(variance);
			this.b = mean;
			this.a = value / (this.c * Math.sqrt(2 * Math.PI));
		}
				
		public function y(x:Number):Number {
			return a * Math.exp( -(x - b) * (x - b) / 2 / c / c );
		}
	}
}