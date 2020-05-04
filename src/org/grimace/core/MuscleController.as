package org.grimace.core {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.grimace.display.StickyLabel;
	import org.grimace.display.ISpline;
	import org.grimace.core.FeatureController;
	import org.grimace.core.Muscle;
	import org.grimace.display.IMapping;
	
	public class MuscleController extends EventDispatcher {
		public static const FPS:int = 30;
		public static const FADE_COMPLETE:String = 'fadecomplete';
		
		private var canvas:Sprite;
		public var groups:Object;
		public var visible:Boolean = false;
		private var timer:Timer;
		private var featureController:FeatureController;
		
		
		public function MuscleController(canvas:Sprite, fc:FeatureController):void {
			this.canvas = canvas;
			this.featureController = fc;
			this.groups = new Object();
		}

		public function setAllMuscles(value:Number):void {
			for each (var group:MuscleGroup in groups) {
				for each (var muscle:Muscle in group.muscles) {
					muscle.tension = value;
				}
			}
			
			announceChange();
		}
		
		private function announceChange():void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function draw():void {
			for each (var group:MuscleGroup in groups) {
				group.draw();
			} 
		}
		
		public function toggleMuscles(groupId:String):void {
			var groupCanvas:Sprite = groups[groupId].canvas;
			
			if (isVisible(groupId)) {
				try {
					canvas.removeChild(groupCanvas);
				}
				catch (e:Error) {
					trace(e);
				}
			}
			else {
				canvas.addChild(groupCanvas);
			}
		}
		
		public function isVisible(groupId:String):Boolean {
			return canvas.contains(groups[groupId].canvas);
		}
		
		public function createMuscleGroup(id:String, zIndex:Number = 0, isVisible:Boolean = false):MuscleGroup {
			var groupCanvas:Sprite = new Sprite();
			if (isVisible) {
				canvas.addChildAt(groupCanvas, zIndex);
			}
			var group:MuscleGroup = new MuscleGroup(id, groupCanvas);
			groups[id] = group;
			return group;
		}
		
		public function getMuscle(groupId:String, id:String):Muscle {
			if (!groups[groupId]) {
				trace(groupId + ' group not found')
			}
			return groups[groupId].muscles[id];
		}
		
		public function clearAllTensions():void {
			for each (var group:Object in groups) {
				group.clearAllTensions();
			}
		}
		
		public function evaluateTensions():void {
			for each (var group:Object in groups) {
				group.evaluateTensions();
			}
		}
		
		public function saveTensions():void {
			for each (var group:Object in groups) {
				group.saveTensions();
			}
		}
		
		public function fadeMuscles(fadeTime:Number, mapping:IMapping):void {

			if (timer && timer.running) {
				timer.stop();
			}

			var delay:Number = 1000 / FPS;
			var repeatCount:int = int(fadeTime * 1000 / delay);

			timer = new Timer(delay, repeatCount);
			timer.addEventListener('timer', function(e:TimerEvent):void {
				
				var pos:Number = e.target.currentCount / e.target.repeatCount;
				/*var weight:Number = Math.sin(pos * Math.PI / 2);*/
				var weight:Number = mapping.y(pos);
				
				for each (var group:MuscleGroup in groups) {
					group.interpolate(weight);
				}
				
				featureController.draw();
			});

			timer.addEventListener('timerComplete', function(e:TimerEvent):void {
				dispatchEvent(new Event(FADE_COMPLETE));
				timer.stop();
			});

			timer.start();
		}
	}
}