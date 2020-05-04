package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.*;
	import org.grimace.controls.*;
	import org.grimace.events.SliderEvent;

	public class MuscleSliderController extends Sprite {
		private var canvas:Sprite;
		private var sliders:Array;		
		
		public function MuscleSliderController (canvas:Sprite, muscles:Object):void {
			this.canvas = canvas;
			
			init(muscles);
		}
		
		private function init(muscles:Object):void {
			sliders = new Array();
			
			var slider:SplineSlider;
			var sl:SliderListener;
			var ml:SliderListener;
			var slisteners:Array = new Array();
			
			for each (var muscle:Muscle in muscles) {
				slider = new SplineSlider(muscle.spline);
				slider.addEventListener(SliderEvent.VALUECHANGED, onSliderChange);
				sliders.push(slider);
				sl = new SliderListener(muscle.id, muscle,
					function(evt:SliderEvent):void {
						this.target.tension = evt.value;
					});
				sl.addDispatcher(slider);
				slisteners.push(sl);
				
				ml = new SliderListener(muscle.id, slider,
					function(evt:SliderEvent):void {
						this.target.value = evt.value;
					});
				ml.addDispatcher(muscle);
				slisteners.push(ml);
				
				canvas.addChild(slider);
			}
		}
		
		private function onSliderChange(evt:SliderEvent):void {
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, evt.value));
		}
		
		public function toggleMuscleSliders():void {
			for each (var slider:SplineSlider in sliders) {
				if (slider.visible)
					slider.visible = false;
				else
					slider.visible = true;
			}
		}
		
	}
}