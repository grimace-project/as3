package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.*;
	import org.grimace.core.Feature;
	
	public class FeatureController extends Sprite {
		public var canvas:Sprite;
		public var features:Array;
		
		public function FeatureController(canvas:Sprite):void {
			this.canvas = canvas;
			this.features = new Array();
			
			toggleFeatures();
		}

		public function draw():void {
			for each (var feature:Feature in features) {
				feature.draw();
			}
		}
		
		public function addFeature(feature:Feature, zIndex:Number = -1):void {
			if (isNaN(zIndex)) {
				zIndex = this.numChildren;
			}
			this.addChildAt(feature, zIndex);
			features.push(feature);
		}
		
		public function toggleFeatures():void {
			if (canvas.contains(this)) {
				canvas.removeChild(this);
			}
			else {
				canvas.addChild(this);
			}
		}
	}
}