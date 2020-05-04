package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.*;
	import org.grimace.core.FeatureSegment;
	
	public class Feature extends Sprite{
		
		public var filled:Boolean;
		public var stroked:Boolean;
		public var mirrored:Boolean;
		
		public var fillCanvas:Sprite;
		public var maskCanvas:Sprite;
		public var strokeCanvas:Sprite;
		
		public var segments:Array;
		private var fills:Array;
		
		public function Feature(stroked:Boolean = true,
			                    filled:Boolean = false,
			                    mirrored:Boolean = false) {
			
			this.stroked = stroked;
			this.filled = filled;
			this.mirrored = mirrored;
			
			strokeCanvas = new Sprite();
			fillCanvas = new Sprite();
			maskCanvas = new Sprite();
			
			fillCanvas.mask = maskCanvas;
			
			addChild(maskCanvas);
			addChild(fillCanvas);
			addChild(strokeCanvas);
			
			this.segments = new Array();
			this.fills = new Array();
		}
		
		public function draw():void {
			maskCanvas.graphics.clear();
			strokeCanvas.graphics.clear();
			
			var i:int;
			var lastSegment:int = segments.length - 1;
			
			for (i = 0; i <= lastSegment; i++) {
				segments[i].draw(
					stroked, filled, false, (i == 0), (i == lastSegment)
				);
			}
			
			if (!mirrored) {
				return;
			}
			
			// draw mirror
			for (i = 0; i <= lastSegment; i++) {
				segments[i].draw(
					stroked, filled, true, (i == 0), (i == lastSegment)
				);
			}
			
			// featurefill
			for each (var fill:FeatureFill in fills) {
				fill.evaluate();
			}
		}
		
		public function addSegment(segment:FeatureSegment):void {
			segment.spline.strokeCanvas = strokeCanvas;
			segment.spline.fillCanvas = maskCanvas;
			segments.push(segment);
		}
		
		public function addFill(fill:FeatureFill):void {
			fills.push(fill);
			fillCanvas.addChild(fill);
		}
		
	}
}
