package org.grimace.core {
	import flash.events.Event;
	import flash.display.Sprite;
	import org.grimace.core.Grimace;
	import org.grimace.core.Emotion;
	import org.grimace.display.IMapping;
	import org.grimace.display.PolynomialMapping;
	
	import org.osflash.thunderbolt.Logger;
	
	
	public class EmotionCore extends Sprite {
		public static const EMOTION_SET:String = 'emotionSet';
		
		public var emotions:Array;
		private var muscleController:MuscleController;
		private var valueSum:Number = 0;
		
		public function EmotionCore(muscleController:MuscleController):void {
			emotions = new Array();
			this.muscleController = muscleController;
			muscleController.addEventListener(
				MuscleController.FADE_COMPLETE, function():void {
					dispatchEvent(new Event(EMOTION_SET));
				}
			);
		}
		
		public function addEmotion(emotion:Emotion):void {
			emotions.push(emotion);
			emotion.addEventListener(Emotion.VALUECHANGED, valueChanged);
			
			evaluate();
		}
		
		private function valueChanged(evt:Event):void {
			// TODO: evaluate should be triggered manually once after all
			// emotions have been set. requires changes where values are set
			evaluate();
		}
		
		public function evaluate():void {
			muscleController.clearAllTensions();
			
			// determine share of each emotion
			valueSum = 0.0;
			
			for each (var emotion:Emotion in emotions) {
				valueSum += emotion.value;
			}
			
			for each (emotion in emotions) {
				if (valueSum == 0.0)
					emotion.weight = 0.0;
				else
					emotion.weight = emotion.value;
				emotion.evaluate();
			}
			
			muscleController.evaluateTensions();
		}
		
		public function setEmotionSet(emotionSet:Object, fadeTime:Number = 0):void {
			muscleController.saveTensions();
			
			var value:Number;
			var label:String;
			
			for (var i:int = 0; i < emotions.length; i++) {
				label = this.emotions[i].label;
				if (emotionSet[label] != null) {
					value = parseFloat(emotionSet[label]);
					value = Math.min(Math.max(value, 0), 1);
				}
				else {
					value = 0;
				}
				this.emotions[i].value = value;
			}
			
			evaluate();
			
			if (fadeTime > 0) {
				var mapping:IMapping = new PolynomialMapping(1, {0:1, 2:-1});
				muscleController.fadeMuscles(fadeTime, mapping);
			}
			else {
				dispatchEvent(new Event(EMOTION_SET));
			}
		}
		
		public function getEmotionSet():Object {
			var value:Number;
			var label:String;
			var emotionSet:Object = new Object();
			
			for (var i:int = 0; i < this.emotions.length; i++) {
				label = this.emotions[i].label;
				value = this.emotions[i].value;
				if (value != 0) {
					emotionSet[label] = value;
				}
			}
			return emotionSet;
		}
	}
}