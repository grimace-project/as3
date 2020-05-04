package org.grimace.external {
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.grimace.core.Grimace;
	import org.grimace.external.JSHandler;
	import org.osflash.thunderbolt.Logger;
	
	/**
	 *  This API exposes methods which allow control of the Grimace component
	 *	from various programming environments.
	 *	
	 *	Currently supported environments are JavaScript, ActionScript 3.0 and
	 *	Flex 3.0.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author ole
	 *  @since  08.01.2009
	 *	@see embedding.html How to embed Grimace
	 */
	public class ExternalCommands {
		
		/**
		*	@private
		*/
		public var g:Grimace;
		
		/**
		*	@private
		*/
		public var listeners:Object = new Object();
		
		
		/**
		*	@private
		*/
		public function ExternalCommands(g:Grimace) {
			this.g = g;
		}
		
		/**
		*	Returns true if Grimace is ready for commands.
		*	
		*	<p>This method can be used to determine if other commands can
		*	be yet issued, e.g. registering of event listeners.</p>
		*	
		*	@return Always true.
		*/
		public function isReady():Boolean {
			return true;
		}
		
		/**
		*	@private
		*/
		public function log(message:String):void {
			Logger.info(message);
		}
		
		/**
		*	Defines the URL of the server-side script which handles uploads of
		*	captured images.
		*	
		*	@param url The URL of the upload script, absolute or relative to grimace.swf
		*	
		*	@see #capture()
		*/
		public function setCaptureUrl(url:String):void {
			g.capture.setUrl(url);
		}
		
		/**
		*	Captures the currently displayed image and uploads it to a server.
		*	
		*	<p>When the upload is finished, the script returns the URL of the
		*	uploaded image, which is then dispatched as Event.</p>
		*	
		*	@param format Defines the image format. Valid options are PNG and JPG.
		*	
		*	@see #setCaptureUrl()
		*	@see events.html Events
		*/
		public function capture(format:String = 'png'):void {
			g.uploadCapture(format);
		}
		
		/**
		*	Defines a new set of emotions to be displayed by grimace.
		*	
		*	<p>A set of emotions consists of one or more emotions with
		*	arbitrary values. If more than one emotion is supplied, Grimace
		*	attempts to mix them. While no theoretical limit, mixtures of
		*	more than two emotions usually produce unintelligible results.</p>
		*	
		*	@param emotionSet An Object which defines the emotion(s) to be displayed.
		*	@param fadeTime The time in seconds to morph the face to the new emotion. 0 displays instantly.
		*	
		*	@see emotions.html Emotion model
		*/
		public function setEmotion(
			emotionSet:Object, fadeTime:Number = 0):void {
			g.emotionCore.setEmotionSet(emotionSet, fadeTime);
		}
		
		/**
		*	Resets the face to a neutral expression.
		*	
		*	<p>Convenience method for supplying setEmotion with an empty
		*	object.</p>
		*	
		*	@param fadeTime The time in seconds to morph the face to the neutral state. 0 displays instantly.
		*	
		*	@see #setEmotion()
		*	@see emotions.html Emotion model
		*/
		public function resetEmotion(fadeTime:Number = 0):void {
			g.emotionCore.setEmotionSet({}, fadeTime);
		}
		
		/**
		*	Gets the currently displayed emotion state.
		*	
		*	<p>Only active emotions, i.e. emotions with value > 0 are included in the result.</p>
		*	
		*	@return An object containing currently active emotions and their values.
		*	
		*	@see emotions.html Emotion model
		*/
		public function getEmotion():Object {
			return g.emotionCore.getEmotionSet();
		}
		
		/**
		*	Attempts to load a face description from facedata XML.
		*	
		*	@param urls An array containing absolute or relative paths to the facedata XML files to be loaded.
		*	@param urlPrefix A relative path from the embedding script to the Facedata files
		*	
		*	@see facedataxml.html Facedata file format
		*/
		public function loadFacedata(urls:Array, urlPrefix:String = ''):void {
			g.loadFacedata(urls, urlPrefix);
		}
		
		/**
		*	Attempts to load a face description from facedata XML.
		*	
		*	@param xml An XML object containing facedata
		* @param dependencyUrlPrefix A relative path from the embedding script to external files, e.g. overlays
		*	
		*	@see facedataxml.html Facedata file format
		*/
		public function loadFacedataFromXML(xmls:Array, dependencyUrlPrefix:String = ''):void {
			g.loadFacedataFromXML(xmls, dependencyUrlPrefix);
		}
		
		/**
		*	Forces a redraw.
		*	
		*	<p>When a muscle or emotion has changed, the face is re-drawn
		*	automatically. An initial manual call of draw is necessary after
		*	loading new facedata description.</p>
		*	
		*	@see #loadFacedata()
		*/
		public function draw():void {
			g.draw();
		}
		
		/**
		*	Moves the face to the position supplied.
		*	
		*	<p>The reference point is the upper-left corner of the face's bounding rectangle.</p>
		*	
		*	@param x The horizontal distance in pixels from the left edge of the container.
		*	@param y The vertical distance in pixels from the top edge of the container.
		*/
		public function setPosition(x:Number, y:Number):void {
			g.geom.setPosition(x, y);
		}
		
		/**
		*	Returns the current position of the face.
		*	
		*	<p>The reference point is the upper-left corner of the face's bounding rectangle.</p>
		*	
		*	@return An Object containing the horizontal position "x" and the vertical position "y" in pixels.
		*/
		public function getPosition():Object {
			var pos:Point = g.geom.getPosition();
			return {
				x: pos.x,
				y: pos.y
			}
		}
		
		/**
		*	Defines a rectangle to fit the face in.
		*	
		*	<p>The face will be scaled proportionally to fit into the supplied
		*	dimensions.</p>
		*	
		*	<p>This setting overwrites a manual scale factor set by
		*	setScale(). It can work in addition to resizing due to scale
		*	mode "showAll". If "showAll" is active, the supplied dimensions
		*	will be resized by the same factor as the face.</p>
		*	
		*	@param maxWidth The maximum width of the face in pixels.
		*	@param maxHeight The maximum height of the face in pixels.
		*/
		public function setMaxBounds(
			maxWidth:Number = 0, maxHeight:Number = 0):void {
			
			g.geom.setMaxBounds(maxWidth, maxHeight);
		}
		
		/**
		*	Returns the horizontal and vertical size of the face.
		*	
		*	@param scaled If a scale factor by setScale() or setMaxBounds() should be taken into account.
		*	
		*	@return An Object containing "width" and "height" in pixels.
		*/
		public function getMaxBounds(scaled:Boolean = true):Object {
			var boundsRect:Rectangle =  g.geom.getMaxBounds(scaled);
			
			var bounds:Object = {
				width: boundsRect.width,
				height: boundsRect.height
			}
			return bounds;
		}
		
		/**
		*	Sets if the face should be scaled to fit the container.
		*	
		*	<p><strong>noScale:</strong> The face will not be scaled to fit the
		*	container. Trimming might occur unless the face is manually
		*	resized by setScale() or setMaxBounds().</p>
		*	
		*	<p><strong>showAll:</strong> The face will be scaled proportionally
		*	to fit the container. Additional resizing through setScale() or
		*	setMaxBounds() is not advised.</p>
		*	
		*	@param mode The desired scale mode. Valid options: "noScale" and "showAll"
		*	
		*	@see #setMaxBounds()
		*	@see #setScale()
		*/
		public function setScaleMode(mode:String = "noScale"):void {
			g.geom.setScaleMode(mode);
		}
		
		/**
		*	Manually sets a factor to proportionally scale the face.
		*	
		*	<p>This setting overwrites a scale factor determined by
		*	setMaxBounds(). It can work in addition to resizing due to scale
		*	mode "showAll".</p>
		*	
		*	@see #setMaxBounds()
		*	@see #setScaleMode()
		*/
		public function setScale(scale:Number):void {
			g.geom.setScale(scale);
		}
		
		/**
		*	Clears active face description and hides the face in preparation
		*	for new facedata.
		*/
		public function restart():void {
			g.restart();
		}
		
		/**
		*	Registers an event listener.
		*	
		*	@param eventType Event type to listen to. See event page for available events.
		*	@param callback Function name to be called when the event is triggered.
		*	
		*	@return Returns true if listener was registered successfully.
		*	
		*	@see events.html Events
		*/
		public function addEventListener(eventType:String, callback:String):Boolean {
			if (!listeners[eventType]) {
				return false;
			}
			listeners[eventType][callback] = true;
			return true;
		}
		
		/**
		*	Removes a previously registered event listener.
		*	
		*	<p>Multiple listeners can be registered for one event type. Thus,
		*	eventType and callback must be supplied to unregister the
		*	corresponding listener.</p>
		*	
		*	@param eventType Event type for which to unregister a listener.
		*	@param callback Function name for which listener was registered.
		*	
		*	@return Returns true if listener was removed successfully.
		*	
		*	@see events.html Events
		*/
		public function removeEventListener(eventType:String, callback:String):Boolean {
			return delete listeners[eventType][callback];
		}
		
	}
}