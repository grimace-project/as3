package org.grimace.controls {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.grimace.events.SliderEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Slider extends Sprite {
		
		private static const FADE_FPS:int = 30;
		private static const FADE_DURATION:int = 300;
		
		private var knob:Sprite;
		private var line:Sprite;
		private var slider:Sprite;
		private var text:TextField;
		
		private var radius:Number = 5;
		private var length:Number;
		
		public var label:String;
		private var _value:Number = 0;
		
		private var _disabled:Boolean = false;
		private var enabledAlpha:Number = 1.0;
		private var disabledAlpha:Number = 0.3;
		private var lastAlpha:Number;
		
		private var fadeTimer:Timer;
		
		public function Slider(label:String = "nolabel", length:Number = 50):void {
			this.length = length;
			this.label = label;
			
			init();
			showLabel(true);
		}
			
		private function init():void {
			slider = new Sprite();
			knob = new Sprite();
			line = new Sprite();
			text = new TextField();
			
			var format:TextFormat = new TextFormat();
			format.font = "Helvetica Neue";
			format.size = 10;
			format.color = 0x53565a;
			
			text.defaultTextFormat = format;
			text.text = label;
			text.y = -2;
			text.x = -110;
			
			text.autoSize = TextFieldAutoSize.RIGHT;
			text.selectable = false;
			
			knob.graphics.beginFill(0x909090);
			knob.graphics.lineStyle(1, 0x909090, 1);
			knob.graphics.drawCircle(0, radius, radius);
			
			line.graphics.beginFill(0xFFFFFF, 0);
			line.graphics.drawRect(0, radius-2, length, 5);
			line.graphics.endFill();
			
			line.graphics.lineStyle(1, 0x383838, 1);
			line.graphics.moveTo(0, radius);
			line.graphics.lineTo(length, radius);
			for (var i:Number = 0; i <= length; i += length / 4) {
				line.graphics.moveTo(Math.round(i), radius - 2);
				line.graphics.lineTo(Math.round(i), radius + 3);
			}
			
			slider.addChildAt(line, 0);
			slider.addChildAt(knob, 1);
			slider.addChildAt(text, 0);
			
 			addChild(slider);
			
			knob.addEventListener(MouseEvent.MOUSE_DOWN, knobClick);
			line.addEventListener(MouseEvent.MOUSE_DOWN, lineClick);
		}
		
		public function showLabel(bool:Boolean):void {
			if (bool) {
				slider.addChildAt(text, 0);
			} else {
				slider.removeChild(text);
			}
		}
		
		private function lineClick(evt:MouseEvent):void {
			announceDrag();
		}
		
		private function knobClick(evt:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, knobDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, knobDragStop);
		}
		
		private function knobDrag(args:MouseEvent):void {
			var x:Number;
			if (mouseX < slider.x) {
				x = 0;
			}
			else if ((mouseX - slider.x) < line.width) {
				x = mouseX - slider.x;
			}
			else {
				x = line.width;
			}
			
			value = x / line.width;
			
			announceDrag();
		}
		
		private function knobDragStop(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, knobDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, knobDragStop);
		}
		
		public function set value(v:Number):void {
			_value = v;
			moveKnob(v);
		}
		
		public function get value():Number {
			return _value;
		}
		
		private function moveKnob(v:Number):void {
			knob.x = value * line.width;
		}
		
		public function dragSlider(v:Number):void {
			value = v;
			announceDrag();
		}
		
		private function announceDrag():void {
			dispatchEvent(new SliderEvent(SliderEvent.VALUECHANGED, value));
		}
		
		public function set disabled(value:Boolean):void {
			if ((value && _disabled) || (!value && !_disabled)) {
				// nothing to do
				return;
			} 
			if (fadeTimer && fadeTimer.running) {
				return;
			}
			
			_disabled = value;
			if (_disabled && knob.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				knob.removeEventListener(MouseEvent.MOUSE_DOWN, knobClick);
				line.removeEventListener(MouseEvent.MOUSE_DOWN, lineClick);
			}
			else if (!_disabled && !knob.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				knob.addEventListener(MouseEvent.MOUSE_DOWN, knobClick);
				line.addEventListener(MouseEvent.MOUSE_DOWN, lineClick);
			}
			
			var delay:Number = 1000 / FADE_FPS;
			var repeatCount:int = int(FADE_DURATION / delay);
			
			fadeTimer = new Timer(delay, repeatCount);
			/*trace('new timer ' + ' ' + text.text + ' ' + repeatCount)*/
			var scope:Object = this;
			lastAlpha = alpha;
			
			fadeTimer.addEventListener('timer', function(e:TimerEvent):void {
				var pos:Number = fadeTimer.currentCount / fadeTimer.repeatCount;
				var weight:Number = Math.sin(pos * Math.PI / 2);
				
				var targetAlpha:Number = (scope._disabled) ? scope.disabledAlpha : scope.enabledAlpha;
				
				scope.alpha = scope.lastAlpha * (1-weight) + targetAlpha * weight;
			});

			fadeTimer.addEventListener('timerComplete', function(e:TimerEvent):void {
				scope.alpha = (scope._disabled) ? scope.disabledAlpha : scope.enabledAlpha;
				/*trace('finished: ' + scope.text.text + ' ' + scope.alpha);*/
				fadeTimer.stop();
				fadeTimer = null;
			});
			
			fadeTimer.start();
			
		}
		
		public function get disabled():Boolean {
			return _disabled;
		}
	}
}