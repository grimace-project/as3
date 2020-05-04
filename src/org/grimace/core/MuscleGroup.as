package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.*;
	import org.grimace.display.StickyLabel;
	import org.grimace.display.ISpline;
	import org.grimace.core.Muscle;
	
	public class MuscleGroup {
		public var id:String;
		public var muscles:Array;
		public var stickies:Array;
		public var canvas:Sprite;
		
		public function MuscleGroup(id:String, canvas:Sprite) {
			this.muscles = new Array();
			this.stickies = new Array();
			this.canvas = canvas;
		}
		
		public function createMuscle(id:String, spline:ISpline, initTension:Number = 0.0):void {
			
			var muscle:Muscle = new Muscle(id, spline, canvas, initTension);
			muscles[id] = muscle;
			
			/*stickies.push(canvas.addChildAt(
			    new StickyLabel(id, muscle.spline.getEnd()), 0)
			);	*/
		}
		
		public function draw():void {
			canvas.graphics.clear();
			for each (var muscle:Muscle in muscles) {
				muscle.draw();
			} 
		}
		
		public function clearAllTensions():void {
			for each (var muscle:Muscle in muscles) {
				muscle.clear();
			}
		}
		
		public function saveTensions():void {
			for each (var muscle:Muscle in muscles) {
				muscle.saveTension();
			}
		}
		
		public function evaluateTensions():void {
			for each (var muscle:Muscle in muscles) {
				muscle.evaluate();
			}
		}
		
		public function interpolate(t:Number):void {
			for each (var muscle:Muscle in muscles) {
				muscle.interpolate(t);
			}
		}
	}
}