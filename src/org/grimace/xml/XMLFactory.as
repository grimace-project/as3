package org.grimace.xml {
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.events.*;
	import org.grimace.core.*;
	import org.grimace.display.*;
	
	import org.osflash.thunderbolt.Logger;
	
		
	public class XMLFactory extends EventDispatcher {
		
		public static var DEPENDENCIES_COMPLETE:String = 'depscomplete';
		
		private var g:Grimace;
		public var urlPrefix:String = '';
		public var depsLoading:Array = new Array();
		
		public function XMLFactory(g:Grimace):void {
			this.g = g;
		}
		
				
		public function createPoint(n:XML):Point {
			var point:Point;
			
			// get previously saved point
			if (new String(n.@ref) != '') {
				try {
					point = g.points[new String(n.@ref)];
				}
				catch (e:Error) {
					throw new Error('referenced point not found.');
					return null;
				}
			}
			else {
				point = new Point(
					new Number(n.@x),
					new Number(n.@y)
				);
				
				// supplying id saves point reference for later use
				if (new String(n.@id) != '') {
					g.points[new String(n.@id)] = point;
				}
			}
			
			return point;
		}
		
		private var splineTypes:Object = {
			line: {
				numPoints: 2,
				create: function(p:Array):ISpline {
					return new Line(p[0], p[1]);
				}
			},
			quadraticbezier: {
				numPoints: 3,
				create: function(p:Array):ISpline {
					return new QuadraticBezier(p[0], p[1], p[2]);
				}
			},
			cubicbezier: {
				numPoints: 4,
				create: function(p:Array):ISpline {
					return new CubicBezier(p[0], p[1], p[2], p[3]);
				}
			},
			joiner: {
				numPoints: 4,
				create: function(p:Array):ISpline {
					return new Joiner(p[0], p[1], p[2], p[3]);
				}
			}
		}
		public function createSpline(n:XMLList):ISpline {
			var points:Array = new Array();
			var entry:XML;
			for each (entry in n.point) {
				points.push(createPoint(entry));
			}
			
			var type:String = new String(n.@type);
			
			if (!splineTypes[type]) {
				throw new Error("unknown spline type");
				return null;
			}
			
			if (points.length < splineTypes[type].numPoints) {
				throw new Error("insufficient number of points for spline\n"+n.toXMLString);
				return null;
			}
			
			return splineTypes[type].create(points);
		}
		
		/*public function createLine(n:XML):ISpline {
			var p0:Point = g.points[new String(n.@p0)];
			var p1:Point = g.points[new String(n.@p1)];
			return new Line(p0, p1);
		}
		
		
		public function createQuadraticBezier(n:XML):void {
			var p0:Point = g.points[new String(n.@p0)];
			var p1:Point = g.points[new String(n.@p1)];
			var p2:Point = g.points[new String(n.@p2)];
			g.splines[n.@id] = new QuadraticBezier(p0, p1, p2);
		}
		
		public function createCubicBezier(n:XML):void {
			var p0:Point = g.points[new String(n.@p0)];
			var p1:Point = g.points[new String(n.@p1)];
			var p2:Point = g.points[new String(n.@p2)];
			var p3:Point = g.points[new String(n.@p3)];
			g.splines[n.@id] = new CubicBezier(p0, p1, p2, p3);
		}
		
		public function createJoiner(n:XML):void {
			var p0:Point = g.points[new String(n.@p0)];
			var p1:Point = g.points[new String(n.@p1)];
			var p2:Point = g.points[new String(n.@p2)];
			var p3:Point = g.points[new String(n.@p3)];
			g.splines[n.@id] = new Joiner(p0, p1, p2, p3);
		}*/
		
		public function createMuscleGroup(n:XML, mc:MuscleController):void {
			var isVisible:Boolean = (n.@visible == 'true')
			var group:MuscleGroup = mc.createMuscleGroup(
				n.@id,
				parseInt(n.@zindex, 10),
				isVisible
			);
			
			var spline:ISpline;
			var initTension:Number;
			for each (var entry:XML in n.muscle) {
				if (entry.spline.length() < 1) {
					throw new Error("no spline for muscle defined.");
					continue;
				}
				spline = createSpline(entry.spline);
				setColorAlphaWidth(spline, n);
				
				initTension = parseFloat(entry.@inittension);
				if (isNaN(initTension)) {
					initTension = 0.0;
				}
				
				group.createMuscle(entry.@id, spline, initTension);
			}
		}
		
		public function createFeature(n:XML, fc:FeatureController):void {
			
			var stroked:Boolean  = (n.@stroked  == true);
			var filled:Boolean   = (n.@filled   == true);
			var mirrored:Boolean = (n.@mirrored == true);
			
			var feature:Feature = new Feature(stroked, filled, mirrored);
			var segment:FeatureSegment;
			var fill:FeatureFill;
			
			var entry:XML;
			
			for each (entry in n.segment) {
				segment = createFeatureSegment(entry);
				feature.addSegment(segment);
			}
			
			for each (entry in n.fill) {
				fill = createFeatureFill(entry);
				feature.addFill(fill);
			}
			
			fc.addFeature(feature, parseInt(n.@zindex, 10));
		}
		
		public function createFeatureSegment(n:XML):FeatureSegment {
			if (n.spline.length() < 1) {
				throw new Error("no spline for segment defined.");
				return false;
			}
			var spline:ISpline = createSpline(n.spline);
			spline.mirrored = true;
			
			var segment:FeatureSegment = new FeatureSegment(n.@label, spline);
			
			if (n.alphamapping.length() == 1) {
				segment.addAlphaMapping(
					createMapping(n.alphamapping.mapping),
					g.muscleController.getMuscle(
						n.alphamapping.@group,
						n.alphamapping.@sourcemuscle
					)
				);
			}
			
			if (n.strokestyle.length() == 1) {
				segment.addStrokeStyle(createStrokeStyle(n.strokestyle));
			}
			
			var muscle:Muscle
			for each (var entry:XML in n.addmuscle) {
				muscle = g.muscleController.getMuscle(
					entry.@group, entry.@muscle
				);
				
				if (!muscle) {
					trace("couldn't find muscle "+entry.@muscle);
					continue;
				}
				
				segment.addMuscle(
					new Number(entry.@nodenum),
					muscle,
					new Number(entry.@weight)
				);
			}
			
			setColorAlphaWidth(segment.spline, n);
			
			return segment;
		}
		
		public function createFeatureFill(n:XML):FeatureFill {
			
			var fill:FeatureFill = new FeatureFill();
			
			var entry:XML;
			
			for each (entry in n.draw) {
				new XMLDraw(n.draw, fill);
			}
			
			var muscle:Muscle
			for each (entry in n.addmuscle) {
				muscle = g.muscleController.getMuscle(
					entry.@group, entry.@muscle
				);
				
				if (!muscle) {
					trace("couldn't find muscle "+entry.@muscle);
					continue;
				}
				
				fill.addMuscle(muscle, new Number(entry.@weight));
			}
			
			return fill;
		}
		
		public function createEmotion(n:XML):void {
			var emotion:Emotion = new Emotion(n.@label);
			var priority:Number;
			
			for each (var entry:XML in n.addinfluence) {
				
				priority = parseFloat(entry.@priority);
				if (isNaN(priority)) {
					priority = 1.0;
				}
				
				emotion.addInfluence(
					g.muscleController.getMuscle(
						entry.@group, entry.@muscle
					),
					createMapping(entry.mapping),
					priority
				);
			}
			
			g.emotionCore.addEmotion(emotion);
		}
		
		public function createUnderlay(n:XML):void {
			for each (var entry:XML in n.underlaygroup) {
				g.underlayController.addUnderlayGroup(
					entry.@id, entry.@base_url
				);
				for each (var image:XML in entry.image) {
					g.underlayController.addUnderlayStep(
						entry.@id, image.@id, image.@url, 
						image.@dx, image.@dy,
						image.@scale, image.@alpha
					);
				}
			}
		}
		
		//private static const includeSWF:Boolean = CONFIG::includeSWF;
		
		public function createOverlay(n:XML):void {
			var url:String;
			for each (var entry:XML in n) {
				
				url = entry.@url;
				
				/* workaround for iOS export limitation/bug */
				//if (!includeSWF && url.toLowerCase().indexOf('.swf') != -1) {
				//	continue;
				//}
				
				var loader:Loader = new Loader();
				loader.x = entry.@x;
				loader.y = entry.@y;
				loader.scaleX = entry.@scale;
				loader.scaleY = entry.@scale;
				loader.alpha = entry.@alpha;
				
				var depsLoading:Array = this.depsLoading;
				depsLoading.push(loader);

				loader.load(new URLRequest(urlPrefix + entry.@url + '.swf'));
				
				loader.contentLoaderInfo.addEventListener('complete', onDependencyComplete);
				/*loader.contentLoaderInfo.addEventListener('httpStatus', function(e:HTTPStatusEvent):void {
					Logger.info(e.toString());
				});*/
				loader.contentLoaderInfo.addEventListener('ioError', function(e:IOErrorEvent):void {
					Logger.error('ioerror while loading from url '+urlPrefix + entry.@url+'\n'+e.toString());
				});

				g.overlayController.addOverlay(entry.@id, loader);
			}
		}
		
		private function onDependencyComplete(e:Event):void {
			depsLoading.splice(depsLoading.indexOf(e.target), 1);
			if (depsLoading.length == 0) {
				dispatchEvent(new Event(DEPENDENCIES_COMPLETE));
			}
		}
		
		public function createMapping(n:XMLList):IMapping {
			var mapping:IMapping;
			var params:Object;
			
			if (n.@type == "sine") {
				mapping = new SineMapping(
					n.values.@x0, n.values.@x1, n.values.@y0, n.values.@y1
				);
			}
			
			else if (n.@type == "gauss") {
				mapping = new GaussMapping(
					n.values.@mean, n.values.@variance, n.values.@value
				);
			}
			
			else if (n.@type == "polynomial") {
				params = new Object();
				for each (var param:XML in n.param) {
					params[param.@exponent] = param.@value;
				}
				mapping = new PolynomialMapping(
					n.values.@x0, params
				);
			}
			else {
				trace("no or unknown mapping");
				return null;
			}
			
			return mapping;
		}
		
		private function setColorAlphaWidth(spline:ISpline, n:XML):void {
			if (!spline) {
				trace('no spline found');
				return;
			}
			if (n.@color) spline.lineColor = n.@color;
			if (n.@alpha) spline.lineAlpha = n.@alpha;
			if (n.@width) spline.lineWidth = n.@width;
		}
		
		public function createStrokeStyle(n:XMLList):IStrokeStyle {
			var style:IStrokeStyle;
			var val:XML;
			
			if (n.@type == "brush") {
				style = new BrushStyle(
					n.values.@startwidth,
					n.values.@maxwidth,
					n.values.@endwidth,
					n.values.@color,
					n.values.@alpha
				);
			}
			
			else {
				trace("no or unknown IStrokeStyle");
				return null;
			}
			
			return style;
		}
		
	}
}