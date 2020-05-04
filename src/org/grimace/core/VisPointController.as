package org.grimace.core {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.grimace.display.VisPoint;
	import org.grimace.display.StickyLabel;

	public class VisPointController {
		private var canvas:Sprite;
		private var vispoints:Array;
		private var stickies:Array;
		private var visible:Boolean = false;
		
		public function VisPointController(canvas:Sprite, points:Object):void {
			this.canvas = canvas;
			
			vispoints = new Array();
			stickies = new Array();
			for (var id:String in points){
				vispoints.push(new VisPoint(points[id], 2, 0.5));
//				stickies.push(new StickyLabel(id, points[id]));
			}
		}
		
		public function toggleVisPoints():void {
			var vispoint:VisPoint;
			var sticky:StickyLabel;
			if (visible) {
				// hide points
				for each (vispoint in vispoints) {
					canvas.removeChild(vispoint);
				}
/*				for each (sticky in stickies) {
					canvas.removeChild(sticky);
				}
*/				visible = false;
			}
			else {
				// show points
				for each (vispoint in vispoints) {
					canvas.addChild(vispoint);
				}
/*				for each (sticky in stickies) {
					canvas.addChild(sticky);
				}
*/				visible = true;
			}
		}
		
		public function update():void {
			for each (var vispoint:VisPoint in vispoints) {
				vispoint.update();
			}			
		}
		
	}
}
