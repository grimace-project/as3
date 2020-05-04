package org.grimace.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class StickyLabel extends Sprite {
		public var label:String;
		public var target:Point;
		private var _format:TextFormat;
		
		private var text:TextField;
		
		public function StickyLabel(label:String, target:Point):void {
			this.label = label;
			this.target = target;
			init();
		}
		
		private function init():void {
			x = target.x;
			y = target.y;
			
			text = new TextField();
			text.text = label;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.selectable = false;
			configureDefaultFormat();
			text.setTextFormat(format);			
			
			addChild(text);
			visible = true;
		}
		
		private function configureDefaultFormat():void {
			format = new TextFormat();
			format.font = "Helvetica Neue";
			format.size = 10;
			format.color = 0x53565a;
		}
		
		public function showLabel(bool:Boolean):void {
			if (bool) {
				addChild(text);
				visible = true;
			} else if (!bool){
				removeChild(text);
				visible = false;
			}
		}
		
		public function set format(format:TextFormat):void {
			_format = format;
		}
		
		public function get format():TextFormat {
			return _format
		}
	}
}