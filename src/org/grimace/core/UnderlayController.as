package org.grimace.core {
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	import org.grimace.display.Underlay;
	
	public class UnderlayController {
		private var canvas:Sprite;
		private var zIndex:int;
		private var outline:Sprite;
		
		private var underlays:Array;
		private var underlayIndex:Object;
		
		private var underlayInfo:TextField;
		
		private var currentUnderlay:int = 0;
		
		public function UnderlayController(canvas:Sprite, zIndex:int = 0):void {
			this.canvas = canvas;
			this.zIndex = zIndex;
						
			this.underlays = new Array();
			this.underlayIndex = new Object();
			
			var format:TextFormat = new TextFormat();
			format.font = "Helvetica Neue";
			format.size = 14;
			format.color = 0x53565a;
			
			var underlayInfo:TextField = new TextField();
			underlayInfo.defaultTextFormat = format;
			underlayInfo.autoSize = TextFieldAutoSize.LEFT;
			underlayInfo.x = 400;
			underlayInfo.y = 400;
			this.underlayInfo = underlayInfo;
			canvas.addChild(underlayInfo);
		}
		
		public function toggleOutline():void {
			if (canvas.contains(outline)) {
				canvas.removeChild(outline);
			} else {
				canvas.addChild(outline);
			}
		}
		
		public function toggleUnderlay(visibility:int = -1):void {
			var underlay:Underlay = underlays[currentUnderlay];
			
			if (visibility == 0){
				underlay.visibility = false;
			}
			else if (visibility == 1){
				underlay.visibility = true;
			}
			else {
				underlay.visibility = !underlay.visibility;
			}
			
			if (underlay.visibility) {
				underlayInfo.text = underlay.id
				                  + "\n"
				                  + underlay.steps[underlay.current].id
				                  ;
			}
			else {
				underlayInfo.text = '';
			}
		}
		
		public function nextUnderlay():void {
			toggleUnderlay(0);
			
			currentUnderlay = (currentUnderlay + 1) % underlays.length;
			
			toggleUnderlay(1);
		}
		
		public function prevUnderlay():void {
			toggleUnderlay(0);
			
			currentUnderlay = (currentUnderlay - 1 + underlays.length) % underlays.length;
			
			toggleUnderlay(1);
		}
		
		public function nextStep():void {
			toggleUnderlay(0);
			underlays[currentUnderlay].next();
			toggleUnderlay(1);
		}
		
		public function prevStep():void {
			toggleUnderlay(0);
			underlays[currentUnderlay].prev();
			toggleUnderlay(1);
		}
		
		public function addUnderlayGroup(id:String, baseUrl:String):void {
			var index:uint =underlays.push(new Underlay(id, baseUrl, canvas));
			underlayIndex[id] = index - 1;
		}
		
		public function addUnderlayStep(groupId:String, id:String, url:String, 
			dx:Number, dy:Number, scale:Number, alpha:Number):void {
			
			var underlay:Underlay = underlays[underlayIndex[groupId]];
			underlay.addStep(id, url, dx, dy, scale, alpha);
		}
		
	}
}
