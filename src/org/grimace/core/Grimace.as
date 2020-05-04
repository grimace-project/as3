package org.grimace.core {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.grimace.display.*;
	import org.grimace.core.*;
	import org.grimace.controls.*;
	import org.grimace.events.*;
	import org.grimace.xml.FacedataLoader;
	import org.grimace.utils.*;
	import org.grimace.external.*;
	
	import org.osflash.thunderbolt.Logger;
	
	public class Grimace extends Sprite {
		
		public static const INIT:String = "init";
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public var muscleCanvas:Sprite;
		public var featureCanvas:Sprite;
		public var underlayCanvas:Sprite;
		public var overlayCanvas:Sprite;
		
		protected var facedataLoader:FacedataLoader;
		private var jsHandler:JSHandler;
		public var asHandler:ASHandler;
		public var api:ExternalCommands;
		public var capture:Capture;
		public var geom:Geom;
		
		// face definition
		public var points:Object;
		public var splines:Object;
		public var emotionCore:EmotionCore;
		
		// face controllers
		public var muscleController:MuscleController;
		public var featureController:FeatureController;
		public var underlayController:UnderlayController;
		public var overlayController:OverlayController;
		
		
		public function Grimace() {
			init();
		}
		
		public function init():void {
			
			muscleCanvas = new Sprite();
			featureCanvas = new Sprite();
			underlayCanvas = new Sprite();
			underlayCanvas.x = -225;
			underlayCanvas.y = 0;
			overlayCanvas = new Sprite();
			
			addChild(underlayCanvas);
			addChild(featureCanvas);
			addChild(muscleCanvas);
			addChild(overlayCanvas);
			
			
			// init face definition
			points = new Object();
			splines = new Object();
			
			underlayController = new UnderlayController(underlayCanvas);
			
			featureController = new FeatureController(featureCanvas);
			
			muscleController = new MuscleController(
				muscleCanvas, featureController
			);
			muscleController.addEventListener(Event.CHANGE, onChange);
			
			emotionCore = new EmotionCore(muscleController);
			emotionCore.addEventListener(
			    EmotionCore.EMOTION_SET, onChange
			);
			
			overlayController = new OverlayController(overlayCanvas);
			
			
			facedataLoader = new FacedataLoader(this);
			capture = new Capture();
			geom = new Geom(this);
			
			// external communication
			api = new ExternalCommands(this);
			jsHandler = new JSHandler(this, api);
			asHandler = new ASHandler(this, api);
			
			dispatchEvent(new Event(Grimace.INIT));
		}
		
		public function loadFacedata(urls:Array, urlPrefix:String = ''):void {
			facedataLoader.addEventListener(
			    FacedataLoader.LOADCOMPLETE, facedataLoadComplete
			);
			facedataLoader.loadFromArray(urls, urlPrefix);
		}
		
		public function loadFacedataFromXML(xmls:Array, dependencyUrlPrefix:String = ''):void {
			facedataLoader.addEventListener(
			    FacedataLoader.LOADCOMPLETE, facedataLoadComplete
			);
			facedataLoader.loadFromXML(xmls, dependencyUrlPrefix);
		}
		
		private function facedataLoadComplete(evt:Event):void {
			facedataLoader.removeEventListener(
			    FacedataLoader.LOADCOMPLETE, facedataLoadComplete
			);
			
			emotionCore.evaluate();
			
			dispatchEvent(new Event(Grimace.LOAD_COMPLETE));
		}
		
		public function uploadCapture(format:String = 'png'):void {
			var bounds:Rectangle = Geom.getDisplayObjectArrayBounds(
				this, new Array(featureCanvas, overlayCanvas)
			);
			
			capture.upload(capture.capture(this, format, bounds), format);
		}
		
		protected function onChange(evt:Event):void {
			draw();
		}
		
		public function draw():void {
			muscleController.draw();
			featureController.draw();
			
		}
		
		public function restart():void {
			muscleController.removeEventListener(Event.CHANGE, onChange);
			emotionCore.removeEventListener(
			    EmotionCore.EMOTION_SET, onChange
			);
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			
			init();
		}
	}
}