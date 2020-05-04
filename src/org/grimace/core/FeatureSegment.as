package org.grimace.core { 
	import flash.display.Sprite; 
	import flash.geom.Point;
	import org.grimace.display.CubicBezier;
	import org.grimace.display.QuadraticBezier;
	import org.grimace.display.ISpline;
	import org.grimace.display.IMapping;
	import org.grimace.display.IStrokeStyle;
	import org.grimace.core.Muscle;
	import org.grimace.core.FeatureNode;

	public class FeatureSegment { 
		public var spline:ISpline;
		public var label:String;
		
		private var alphaMapping:IMapping;
		private var sourceMuscle:Muscle;
		
		private var strokeStyle:IStrokeStyle;
		
		protected var nodes:Array;
		
		public function FeatureSegment(label:String, spline:ISpline):void {
			this.label = label;
			this.spline = spline;
			
			nodes = new Array();
			
			var splinePoints:Array = spline.getPointsAsArray();
			var node:FeatureNode;
			
			for (var i:Number = 0; i < splinePoints.length; i++) {
				node = new FeatureNode(splinePoints[i]);
				nodes.push(node);
			}
		} 
		
		public function addMuscle(nodeNum:Number, muscle:Muscle, weight:Number):void {
			if (nodeNum >= nodes.length)
				return;
			
			nodes[nodeNum].addMuscle(muscle, weight);
		}
		
		public function evaluate():void {
			for (var i:Number = 0; i < nodes.length; i++) {
				nodes[i].evaluate();
			}
		}
		
		public function draw(
			stroke:Boolean = true,
			fill:Boolean = false,
			mirror:Boolean = false,
			start:Boolean = true,
			end:Boolean = true
			):void {
				
			evaluate();
			
			if (alphaMapping) {
				var y:Number = alphaMapping.y(sourceMuscle.tension);
				
				if (strokeStyle) {
					strokeStyle.strokeAlpha = y;
				}
				else {
					spline.lineAlpha = y;
				}
			}
			
			if (stroke) {
				if (strokeStyle) {
					strokeStyle.draw(start, end, spline, mirror);
				}
				else {
					spline.drawStroke(start, end, mirror);
				}
			}
			if (fill) {
				spline.drawFill(start, end, mirror);
			}
		}
		
		public function addAlphaMapping(alphaMapping:IMapping, sourceMuscle:Muscle):void {
			this.alphaMapping = alphaMapping;
			this.sourceMuscle = sourceMuscle;
		}
		
		public function addStrokeStyle(strokeStyle:IStrokeStyle):void {
			this.strokeStyle = strokeStyle;
		}
	}
	
}
