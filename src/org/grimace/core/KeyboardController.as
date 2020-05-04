package org.grimace.core {
	import flash.events.KeyboardEvent;
	import org.grimace.core.Facemap;

	public class KeyboardController {
		
		private var fm:Facemap;
		
		public function KeyboardController(fm:Facemap):void {
			this.fm = fm;
		}
		
		public function onKeyPressed(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 77: // 'm'
					if (evt.shiftKey) {
						fm.muscleController.toggleMuscles('wrinkle');
					}
					else {
						fm.muscleController.toggleMuscles('feature');
					}
					break;
					
				case 83: // 's'
					if (evt.shiftKey) {
						fm.wrinkleMuscleSliderController.toggleMuscleSliders();
					}
					else {
						fm.featureMuscleSliderController.toggleMuscleSliders();
					}
					break;
								
				case 88: // 'x'
					fm.underlayController.toggleUnderlay();
					break;
					
				case 80: // 'p'
					fm.visPointController.toggleVisPoints();
					break;
					
				case 78: // 'n'
					break;
					
				case 79: // 'o'
					fm.overlayController.toggle();
					break;

				case 81: // 'q'
					fm.uploadCapture();
					break;

				case 167: // '§'
					break;
				
				case 49: // '1'
					break;
				
				case 50: // '2'
					break;
				
				case 51: // '3'
					break;
				
				case 52: // '4'
					break;
				
				case 53: // '5'
					break;
				
				case 54: // '6'
					break;
				
				case 55: // '7'
					break;
				
				case 56: // '8'
					break;
				
				case 57: // '9'
					break;
				
				case 48: // '0'
					break;
					
				case 75: // 'k'
					fm.underlayController.prevUnderlay();
					break;

				case 76: // 'l'
					fm.underlayController.nextUnderlay();
					break;

				case 188: // ','
					fm.underlayController.prevStep();
					break;

				case 190: // '.'
					fm.underlayController.nextStep();
					break;
					
				case 27: // escape
					fm.restart();
					break;
					
				case 84: // 't'
					if (evt.shiftKey) {
						fm.traceMuscles('wrinkle');
					} else {
						fm.traceMuscles('feature');
					}
					break;
				
				case 70: // 'f'
					fm.featureController.toggleFeatures();
					break;
				
				default:
					/* DEBUG OUTPUT*/
					trace("Key pressed (Keycode): " + evt.keyCode);
			}
		}
	}
}