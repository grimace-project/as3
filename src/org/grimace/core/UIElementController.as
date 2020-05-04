package org.grimace.core {
	import flash.text.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	
	public class UIElementController {
		private var canvas:Sprite;

		public function UIElementController(canvas:Sprite):void {
			this.canvas = canvas;
			init();
		}
		
		private function init():void {
			var format:TextFormat = new TextFormat();
			format.font = "Helvetica Neue";
			format.size = 10;
			format.color = 0x53565a;
			
			var keyinfo:TextField = new TextField();
			keyinfo.defaultTextFormat = format;
			var text:Array = new Array(
				"keymap:",
				"ESC : reload facedata",
				"t : save muscle tensions to clipboard",
//				"x : toggle underlay",
//				"k : previous underlay group",
//				"l : next underlay group",
//				", : decrease underlay intensity",
//				". : increase underlay intensity",
				"o : toggle overlay",
				"f : toggle features",
				"m : toggle feature muscles",
				"shift + m: toggle wrinkle muscles",
				"s : toggle feature muscle sliders",
				"shift + s : toggle wrinkle muscle sliders",
				"p : toggle points"
			);
			keyinfo.text = text.join('\n');
			keyinfo.autoSize = TextFieldAutoSize.LEFT;
			keyinfo.x = 0;
			keyinfo.y = 200;
			canvas.addChild(keyinfo);
		}

	}
}
