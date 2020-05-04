package org.grimace.core {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	public class OverlayController {
		private var canvas:Sprite;
		private var zIndex:int;
		
		private var overlays:Object;
		
		public function OverlayController(canvas:Sprite, zIndex:int = 0):void {
			this.canvas = canvas;
			this.zIndex = zIndex;
						
			this.overlays = new Object();
		}
		
		public function addOverlay(id:String, overlay:DisplayObject):void {
				
				overlays[id] = overlay;
				canvas.addChild(overlay);
		}
		
		public function toggle():void {
			canvas.visible = !canvas.visible;
		}
	}
}
