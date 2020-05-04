package {
	import flash.display.Sprite;
	import org.grimace.core.Facemap;
	
	[SWF( width="700", height="600", backgroundColor="#FFFEFD")]
	public class Main extends Sprite {
		
		public function Main():void {
			init();
		}
		
		public function init():void {
			try {
				removeChild(getChildAt(0));
			}
			catch (e:Error) {
				
			}
			
			addChildAt(new Facemap(this), 0);
		}
	}
}