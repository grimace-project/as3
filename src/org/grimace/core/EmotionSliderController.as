package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.*;
	import org.grimace.controls.*;
	import org.grimace.events.SliderEvent;
	
	public class EmotionSliderController extends EventDispatcher {
		private var canvas:Sprite;
		private var sliders:Array;
		private var sliderX:Number = 60;
		private var sliderY:Number = 45;
		private var sliderDist:Number = 20;
		
		public function EmotionSliderController(canvas:Sprite, emotions:Object):void {
			this.canvas = canvas;
			
			init(emotions);
		}
		
		private function init(emotions:Object):void {
			sliders = new Array();
			var emotionSlider:Slider;
			var sl:SliderListener;
			var el:SliderListener;
			var slisteners:Array = new Array();
			
			for each (var emotion:Emotion in emotions) {
				emotionSlider = new Slider(emotion.label, 100);
				emotionSlider.addEventListener(SliderEvent.VALUECHANGED, onSliderChange);
				sliders.push(emotionSlider);
				sl = new SliderListener(emotion.label, emotion,
					function(evt:SliderEvent):void {
						this.target.value = evt.value;
					});
				sl.addDispatcher(emotionSlider);
				slisteners.push(sl);
				
				el = new SliderListener(emotion.label, emotionSlider,
					function(evt:SliderEvent):void {
						this.target.value = evt.value;
					});
				el.addDispatcher(emotion);
				slisteners.push(el);
				
				emotionSlider.x = sliderX;
				emotionSlider.y = sliderY;
				sliderY += sliderDist;
				canvas.addChild(emotionSlider);
			}
		}
		
		private function onSliderChange(evt:SliderEvent):void {
			evaluate();
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, evt.value));
		}
		
		private function evaluate():void {
			var activeCount:int = 0;
			for (var i:String in sliders) {
				if (sliders[i].value != 0) {
					activeCount++;
				}
			}
			if (activeCount < 2) {
				for (i in sliders) {
					sliders[i].disabled = false;
				}
				return;
			}
			
			for (i in sliders) {
				if (sliders[i].value == 0) {
					sliders[i].disabled = true;
				}
			}
		}
	}
}