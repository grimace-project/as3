package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	/*import flash.net.registerClassAlias;*/
	import org.grimace.core.Grimace;
	import org.grimace.external.ExternalCommands;
	import org.grimace.external.ASHandler;
	
	[SWF( width="600", height="600", backgroundColor="#FFFEFD")]
	
	public class MainGrimace extends Sprite {
		
		private var grimace:Grimace;
		public var api:ExternalCommands;
		public var events:ASHandler;
		
		public function MainGrimace():void {
			
			trace("\n\n----\ngrimace " + (new Date()).toString() + "\n----");
			
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			/*registerClassAlias("org.grimace", Grimace);*/
			grimace = new Grimace();
			addChild(grimace);
			this.api = grimace.api;
			this.events = grimace.asHandler;
		}
	}
}