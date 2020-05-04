package org.grimace.core {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	
	import org.grimace.display.*;
	import org.grimace.core.*;
	import org.grimace.controls.*;
	import org.grimace.events.*;
	import org.grimace.utils.*;
	
	import flash.utils.describeType;
	import flash.utils.ByteArray;
	
	public class Facemap extends Grimace {
		
		public var uiCanvas:Sprite;
		public var featureMuscleSliderCanvas:Sprite;
		public var wrinkleMuscleSliderCanvas:Sprite;
		public var main:Main;
		
		// face controllers
		public var visPointController:VisPointController;
		
		// ui controllers
		public var featureMuscleSliderController:MuscleSliderController;
		public var wrinkleMuscleSliderController:MuscleSliderController;
		public var emotionSliderController:EmotionSliderController;
		public var uiElementController:UIElementController;
		private var keyboardController:KeyboardController;
		
		private var grimacePos:Point = new Point(250, 100);
		
		private static const metaUrlPrefix:String = NAMES::metaUrlPrefix;
		
		public function Facemap(main:Main):void {
			
		}
		
		override public function init():void {
			
			trace("\n\n----\ngrimace " + (new Date()).toString() + "\n----");
			
			this.main = main;
			
			uiCanvas = new Sprite();
			featureMuscleSliderCanvas = new Sprite();
			wrinkleMuscleSliderCanvas = new Sprite();

			this.x = 250;
			this.y = 100;
			
			// init ui controllers
			uiElementController = new UIElementController(uiCanvas);
			
			/*stage.addEventListener(MouseEvent.CLICK, stageClicked);*/
			
			uiCanvas.x = 270;
			addChild(uiCanvas);
			
			super.init();
			addChild(featureMuscleSliderCanvas);
			addChild(wrinkleMuscleSliderCanvas);
			
			addEventListener(Grimace.LOAD_COMPLETE, isReady);
			
			capture.setUrl('http://localhost:8888/grimacecapture/SaveFile.php');
			
			loadFacedata(new Array(
				'head.xml',
				'features.xml',
				'wrinkles.xml',
				'emotions.xml',
				/*'underlays.xml',*/
				'overlays.xml'
			), metaUrlPrefix);
		}
		
		private function isReady(e:Event):void {
			keyboardController = new KeyboardController(this);
			stage.addEventListener(
				KeyboardEvent.KEY_DOWN, keyboardController.onKeyPressed
			);
			
			visPointController = new VisPointController(featureCanvas, points);
			
			featureMuscleSliderController = new MuscleSliderController(
				featureMuscleSliderCanvas,
				muscleController.groups['feature'].muscles
			);
			featureMuscleSliderController.addEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			if (!muscleController.isVisible('feature')) {
				featureMuscleSliderController.toggleMuscleSliders();
			}
			
			wrinkleMuscleSliderController = new MuscleSliderController(
				wrinkleMuscleSliderCanvas,
				muscleController.groups['wrinkle'].muscles
			);
			wrinkleMuscleSliderController.addEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			if (!muscleController.isVisible('wrinkle')) {
				wrinkleMuscleSliderController.toggleMuscleSliders();
			}
			
			
			emotionSliderController = new EmotionSliderController(
				uiCanvas, emotionCore.emotions
			);
			emotionSliderController.addEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			
			draw();
			
		}
		
		override public function restart():void {
			stage.removeEventListener(
				KeyboardEvent.KEY_DOWN, keyboardController.onKeyPressed
			);
			featureMuscleSliderController.removeEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			wrinkleMuscleSliderController.removeEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			emotionSliderController.removeEventListener(
			    SliderEvent.VALUECHANGED, onChange
			);
			
			super.restart();
		}
		
		// trace mouseclicks
		private var counter:Number = 0;
		
		private function stageClicked(evt:MouseEvent):void {
			counter += 1;
			trace("x shift: " + (234 - mouseX) + " y: " + mouseY);
		}
		
/*		private function onMouseMove(evt:MouseEvent):void {
			uiElementController.mousePos.text = mouseX + ", " + mouseY;
		}*/
		
		public function traceMuscles(groupId:String):void {
			var lines:Array = [];
			for each (var muscle:Muscle in muscleController.groups[groupId].muscles) {
				if (muscle.tension != muscle.initTension) {
					lines.push(muscle.id + ": " + (muscle.tension - muscle.initTension).toFixed(2))
				}
			}
			lines.push('');
			var result:String = lines.join('\n');
			System.setClipboard(result);
			trace(result);
		}
		
		override public function draw():void {
			super.draw();
			visPointController.update();
		}
		
	}
}