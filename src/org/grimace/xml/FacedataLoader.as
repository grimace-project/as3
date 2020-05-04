package org.grimace.xml {
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.*;
	import flash.errors.*;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Graphics;
/*	import org.grimace.display.**/
	import org.grimace.core.Grimace;
	import org.grimace.xml.*;
	
	import org.osflash.thunderbolt.Logger;
	
	public class FacedataLoader extends EventDispatcher {
		public static const LOADCOMPLETE:String = "loadcomplete";
		
		private var loader:URLLoader;
		
		private var g:Grimace;
		private var factory:XMLFactory;
		
		private var _urlPrefix:String = '';
		
		private var urls:Array;
		private var loading:Boolean;
		
		public function FacedataLoader(g:Grimace):void {
			
			this.g = g;
			this.factory = new XMLFactory(g);
			factory.addEventListener(
				XMLFactory.DEPENDENCIES_COMPLETE, onComplete
			);
			
			urls = new Array();
			loading = false;
		}
		
		public function load(url:String):void {
			urls.push(url);
			
			if (loading == false) {
				processQueue();
			}
		}
		
		public function loadFromArray(urlsToLoad:Array, urlPrefix:String = ''):void {
			this.urlPrefix = urlPrefix;
			
			urls = urls.concat(urlsToLoad);
			
			if (loading == false) {
				processQueue();
			}
		}
		
		public function loadFromXML(xmls:Array, dependencyUrlPrefix:String = ''):void {
			this.urlPrefix = dependencyUrlPrefix;
			for each (var facedata:XML in xmls) {
				parseFacedata(facedata);
			};
			if (factory.depsLoading.length == 0) {
				onComplete(new Event(Event.COMPLETE));
			}
		}
		
		private function processQueue():void {
			if (urls.length > 0) {
				loading = true;
				
				var url:String = urls.shift();
				
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onFileComplete);

				try {
					loader.load(new URLRequest(urlPrefix + url));
				}
				catch(e:Error) {
					throw new Error("Error: " + e.message);
					return;
				}
				
				loader.addEventListener('ioError', function(e:IOErrorEvent):void {
					throw new IOError('Could not load facedata from '+urlPrefix+url+'\n'+e.toString());
				});

			}
			else if (factory.depsLoading.length == 0) {
				onComplete(new Event(Event.COMPLETE));
			}
		}
		
		private function onFileComplete(evt:Event):void {
			loader.removeEventListener(Event.COMPLETE, onFileComplete);
			
			var facedata:XML;
			try {
				facedata = new XML(loader.data)
			}
			catch(e:Error) {
				trace("Error: " + e.message)
				return;
			}
			
			parseFacedata(facedata);
			
			processQueue();
		}
		
		private function parseFacedata(facedata:XML):void {
			
			for each (var n:XML in facedata.children()) {
				var name:String = n.name();
				
				switch (name) { 
					case "musclegroup":
						factory.createMuscleGroup(n, g.muscleController);
						break;
						
					case "feature":
						factory.createFeature(n, g.featureController);
						break;
						
					case "emotion":
						factory.createEmotion(n);
						break;
					
					case "underlays":
						factory.createUnderlay(n);
						break;
					
					case "overlay":
						factory.createOverlay(n);
						break;
						
					case "function":
						trace(n.toString());
						break;
						
					default: 
						trace ("Unknown node type " + name) ;
				} 
			}
		}
		
		private function onComplete(evt:Event):void {
			factory.removeEventListener(
				XMLFactory.DEPENDENCIES_COMPLETE, onComplete
			);
			loading = false;
			dispatchEvent(new Event(FacedataLoader.LOADCOMPLETE));
		}
		
		public function set urlPrefix(prefix:String):void {
			_urlPrefix = prefix;
			factory.urlPrefix = prefix;
		}
		public function get urlPrefix():String {
			return _urlPrefix;
		}
	}
}