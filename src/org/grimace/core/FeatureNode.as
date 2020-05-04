package org.grimace.core {
	import flash.display.Sprite; 
	import flash.geom.Point;
	import org.grimace.core.Muscle;
	
	public class FeatureNode {
		private var point0:Point;
		public var point:Point;
		private var influences:Object;
		private var weightSum:Number;
		
		public function FeatureNode(point:Point):void {
			this.point = point;
			this.point0 = point.clone();
			influences = new Object();
			weightSum = 0;
		}
		
		public function addMuscle(muscle:Muscle, weight:Number):void {
			var id:String = muscle.id;
			
			var entry:Object = new Object();
			entry.muscle = muscle;
			entry.weight = weight;
			
			weightSum += weight;
			
			influences[id] = entry;
		}
		
		public function evaluate():void {
			if (weightSum == 0)
				return;
			
			var muscleWeight:Number;
			var musclePoint:Point;
			var xAverage:Number = 0.0;
			var yAverage:Number = 0.0;
			
			var newPoint:Point = point0.clone();
			
			for each (var entry:Object in influences) {
				musclePoint = entry.muscle.getInitPoint().subtract(entry.muscle.getPoint());
				
				newPoint.offset(
					-entry.weight * musclePoint.x,
					-entry.weight * musclePoint.y
				);
			}
			
			point.x = newPoint.x;
			point.y = newPoint.y;
		}
	}
}			
