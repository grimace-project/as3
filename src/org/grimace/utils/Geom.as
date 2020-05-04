package org.grimace.utils {
	import flash.display.DisplayObject;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import org.grimace.core.Grimace;
	
	import org.osflash.thunderbolt.Logger;
	
	public class Geom {
		
		private var g:Grimace;
		
		public function Geom (g:Grimace):void {
			this.g = g;
		}
		
		public function setScale(scale:Number):void {
			if (!scale || scale == Infinity) {
				scale = 1;
			}
			
			g.scaleX = scale;
			g.scaleY = scale;
		}
		
		public function setScaleMode(mode:String):void {
			if (mode == StageScaleMode.NO_SCALE || mode == StageScaleMode.SHOW_ALL) {
				g.stage.scaleMode = mode;
			}
			else {
				Logger.warn('unsupported scalemode');
			} 
		}
		
		public function setMaxBounds(maxWidth:Number, maxHeight:Number):void {
			var bounds:Rectangle = getMaxBounds(false);
			
			var scaleX:Number = (maxWidth > 0) ? maxWidth / bounds.width : Infinity;
			var scaleY:Number = (maxHeight > 0) ? maxHeight/ bounds.height : Infinity;
			var scale:Number = Math.min(scaleX, scaleY);
			if (scale == Infinity) {
				scale = 1;
			}
			g.scaleX = scale;
			g.scaleY = scale;
		}
		
		public function getMaxBounds(scaled:Boolean = true):Rectangle {
			var bounds:Rectangle = Geom.getDisplayObjectArrayBounds(
				g, new Array(g.featureCanvas, g.overlayCanvas)
			);
			
			if (scaled) {
				bounds.y *= g.scaleX;
				bounds.x *= g.scaleX;
				bounds.width *= g.scaleX;
				bounds.height *= g.scaleX;
			}
			
			return bounds;
		}
		
		public function setPosition(x:Number, y:Number):void {
			var bounds:Rectangle = getMaxBounds(true);
			
			var local:Point = new Point(bounds.left, bounds.top);
			
			g.x = x - bounds.left;
			g.y = y - bounds.top;
		}
		
		public function getPosition():Point {
			var bounds:Rectangle = this.getMaxBounds();
			return g.localToGlobal(new Point(bounds.left, bounds.top));
		}
		
		public static function getDisplayObjectArrayBounds(
			targetCoordinateSpace:DisplayObject, boundsObjects:Array):Rectangle {

			var bounds:Rectangle = null;

			if (boundsObjects) {
				for each (var bo:DisplayObject in boundsObjects) {
					if (!bounds) {
						bounds = bo.getBounds(targetCoordinateSpace);
					}
					else {
						bounds = bounds.union(
							bo.getBounds(targetCoordinateSpace)
						);
					}
				}
			}

			if (!bounds) {
				bounds = new Rectangle();
			}

			return bounds;
		}
	}
}
