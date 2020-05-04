package org.grimace.utils {
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.MouseEvent;

	public class Imageloader extends Sprite {
		private	var loader:Loader = new Loader();
		private var _emotion:String = new String();
		public var dragable:Boolean = false;
		
		public function Imageloader():void {
			init();
		}
		
		private function init():void {
			addChild(loader);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			if (dragable) {
				startDrag();
			}
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			if (dragable) {
				stopDrag();
			}
				
		}
		
		public function load(image:String):void {
			loader.load(new URLRequest(image));
		}
		
		private var currimage:int = 1;
		public function next():void {
			if (currimage < 4) {
				trace("loading: " + emotion + currimage + ".png");
				loader.load(new URLRequest("mccloud_intensities/" + emotion + currimage +".png"));
				currimage++;
			} else {
				trace("loading: " + emotion + currimage + ".png");
				loader.load(new URLRequest("mccloud_intensities/" + emotion + currimage +".png"));
				currimage = 1;
			}
		}
		
		public function set emotion(string:String):void {
			_emotion = string;
			next();
		}
		
		public function get emotion():String {
			return _emotion;
		}
		
	}
}