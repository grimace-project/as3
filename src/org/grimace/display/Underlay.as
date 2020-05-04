package org.grimace.display {
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class Underlay extends Sprite {
		
		public var id:String;
		private var baseUrl:String;
		private var canvas:Sprite;
		private var zIndex:int;
		private var _visibility:Boolean;
		public var steps:Array;
		public var current:int = 0;

		public function Underlay(id:String, baseUrl:String,
			canvas:Sprite, zIndex:int = 0):void {
			
			this.id = id;
			this.baseUrl = baseUrl
			this.canvas = canvas;
			this.zIndex = zIndex;
			this.steps = new Array();
		}
		
		public function addStep(id:String, url:String,
			dx:Number, dy:Number, scale:Number, alpha:Number):void {
			
			var loader:Loader = new Loader();
			loader.x = dx;
			loader.y = dy;
			loader.scaleX = scale;
			loader.scaleY = scale;
			loader.alpha = alpha;
			loader.load(new URLRequest(baseUrl + url));
			
			var step:Object = new Object();
			step.image = loader;
			step.id = id;
			steps.push(step);
		}
		
		public function next():void {
			if (current + 1 == steps.length) {
				return;
			}
			
			current = (current + 1) % steps.length;
		}
		
		public function prev():void {
			if (current == 0) {
				return;
			}
			
			current = (current - 1 + steps.length) % steps.length;
		}
		
		public function set visibility(isVisible:Boolean):void {
			var image:Loader = steps[current].image;
			
			if (isVisible) {
				canvas.addChildAt(image, zIndex);
				_visibility = true;
			}
			else {
				if (canvas.contains(image)) {
					canvas.removeChild(image);
				}
				_visibility = false;
			}
		}
		public function get visibility():Boolean { return _visibility; }

	}
}
