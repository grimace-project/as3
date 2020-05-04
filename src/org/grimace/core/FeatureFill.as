package org.grimace.core { 
	import flash.display.Sprite; 
	import flash.geom.Point;
	import org.grimace.core.Muscle;
	import org.grimace.core.FeatureNode;

	public class FeatureFill extends Sprite { 
		
		private var pivot:FeatureNode;
		
		public function FeatureFill():void {
			pivot = new FeatureNode(new Point(x, y));
		} 
		
		public function addMuscle(muscle:Muscle, weight:Number):void {
			pivot.addMuscle(muscle, weight);
		}
		
		public function evaluate():void {
			pivot.evaluate();
			this.x = pivot.point.x;
			this.y = pivot.point.y;
		}
	}
	
}
