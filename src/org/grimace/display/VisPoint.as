package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 *	Klasse um einen Punkt zu visualisieren.
	 */
	public class VisPoint extends Sprite {
		private var point:Point;
		private var radius:Number;
		private var opacity:Number;
		private var color:uint;
		
		/**
		 * Legt eine neue Instanz der Klasse VisPoint an
		 * @param point 	Punkt der gezeichnet werden soll
		 * @param radius	Radius des gezeichneten Punktes
		 * @param alpha		Opazität des gezeichneten Punktes
		 * @param color		Farbe des gezeichneten Punktes
		 */
		public function VisPoint(point:Point, radius:Number, alpha:Number = 1, color:uint = 0x3d4f68):void {
			this.point = point;
			this.radius = radius;
			this.color = color;
			opacity = alpha;
			init();			
		}
		
		/**
		 * Zeichnet den grafischen Punkt
		 */
		private function init():void {
			graphics.beginFill(color, opacity);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			
			update();
		}
		
		/**
		 * Aktualisiert die Position
		 */
		public function update():void {
			x = point.x;
			y = point.y;
		}
	}
}