package org.grimace.controls {
	import flash.events.IEventDispatcher;
	import org.grimace.events.SliderEvent;
	import org.grimace.core.Muscle;
	
	/**
	 * Class to Listen for sliderchanges and perform a user-defined function
	 * on a target object on changes.
	 */
	public class SliderListener {
		public var label:String;
		public var target:Object;
		public var onChange:Function;
		
		/**
		 * Constructor
		 * @param label
		 * @param target the object to be influenced
		 * @param onChange function to be performed on slider change.
		 */
		public function SliderListener(label:String, target:Object, onChange:Function) {
			this.label = label;
			this.target = target;
			this.onChange = onChange;
		}
		
		/**
		 * Adds a listener for the specified dispatcher
		 * @param dispatcher the EventDispatcher to listen to
		 */
		public function addDispatcher(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(SliderEvent.VALUECHANGED, sliderChanged);
		}
		
		/**
		 * Calls the user defined function on slider change
		 * @param evt
		 */
		private function sliderChanged(evt:SliderEvent):void {
			onChange.call(this, evt);
		}
	}
}