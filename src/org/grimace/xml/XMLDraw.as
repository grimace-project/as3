package org.grimace.xml {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class XMLDraw {
		
		public function XMLDraw(commands:XMLList, canvas:Sprite) {
			draw(commands, canvas);
		}
		
		private function draw(commands:XMLList, canvas:Sprite):void {
			var gr:Graphics = canvas.graphics;
			
			for each (var n:XML in commands.children()) {
				var command:String = n.name();
				switch (command) {
					case 'lineStyle':
						gr.lineStyle(n.@thickness, n.@color, n.@alpha);
						break;
					
					case 'beginFill':
						gr.beginFill(n.@color, n.@alpha);
						break;
					
					case 'endFill':
						gr.endFill();
					
					case 'drawCircle':
						gr.drawCircle(n.@x, n.@y, n.@radius);
						break;
					
					case 'drawRect':
						gr.drawRect(n.@x, n.@y, n.@width, n.@height);
						break;
					
					case 'drawEllipse':
						gr.drawEllipse(n.@x, n.@y, n.@width, n.@height);
						break;
					
					case 'moveTo':
						gr.moveTo(n.@x, n.@y);
						break;
					
					case 'lineTo':
						gr.lineTo(n.@x, n.@y);
						break;
					
					case 'curveTo':
						gr.curveTo(n.@controlX, n.@controlY, n.@anchorX, n.@anchorY);
						break;
						
					default:
						trace('unknown drawing command '+command);
				}
			}
		}
	}
}