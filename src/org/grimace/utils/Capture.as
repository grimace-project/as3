package org.grimace.utils {
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.grimace.events.UploadEvent;
	
	import com.adobe.images.*;
	import org.osflash.thunderbolt.Logger;
	
	public class Capture extends EventDispatcher {
		
		public static const CAPTURE_COMPLETE:String = "captureComplete";
		public static const CAPTURE_ERROR:String = "captureError";
		
		public static const JPG:String = 'jpeg';
		public static const PNG:String = 'png';
		
		public var uploadUrl:String;
		
		public function Capture() {
		}
		
		public function setUrl(url:String):void {
			uploadUrl = url;
		}
		
		public function capture(displayObject:DisplayObject,
			format:String = PNG, bounds:Rectangle = null):ByteArray {
				
			if (!bounds) {
				bounds = displayObject.getBounds(displayObject);
			}
				
			var bd:BitmapData = displayObjectToBitmapData(
				displayObject, -bounds.x, -bounds.y, bounds.width, bounds.height
			);
			
			var ba:ByteArray;
			
			switch (format) {
				case PNG:
					ba = PNGEncoder.encode(bd);
					break;
				case JPG:
					ba =  (new JPGEncoder).encode(bd);
					break;
				default:
					throw new Error("Invalid or unsupported image format"); 
					return;
			}
			
			return ba;
		}
		
		// courtesy of
		// http://blog.728media.com/2008/06/17/how-to-get-a-displayobjects-bitmapdata/
		public function displayObjectToBitmapData(
			d:DisplayObject, tx:Number = 0, ty:Number = 0,
			width:Number = 0, height:Number = 0):BitmapData {

			var matrix:Matrix = new Matrix(1, 0, 0, 1, tx, ty);

			if (!width) width = d.width;
			if (!height) height = d.height;
			
			var bd:BitmapData = new BitmapData(
				width, height, true, 0x00FFFFFF
			);

			bd.draw(d, matrix, null, null, null, true);

			return bd;
		}
		
		// courtesy of
		// http://blog.joa-ebert.com/2006/05/01/save-bytearray-to-file-with-php/
		public function upload(bytes:ByteArray, format:String):Boolean {
			/*Logger.info('uploading...');*/
			if (!uploadUrl) {
				throw new ArgumentError('No URL for upload defined');
				return false;
			}
			
			var request:URLRequest = new URLRequest(uploadUrl);
			request.contentType = 'image/' + format;
			request.method = URLRequestMethod.POST;
			request.data = bytes;
			
			var loader:URLLoader = new URLLoader();
			
			try {
				loader.load(request);
			}
			catch (e:Error) {
				throw new Error('Error while uploading:\n'+e);
				return false;
			}
			
			loader.addEventListener('complete', function(e:Event):void {
				/*Logger.info(e.target.data);*/
				dispatchEvent(
					new UploadEvent(CAPTURE_COMPLETE, e.target.data)
				);
			});
			loader.addEventListener('ioError', function(e:IOErrorEvent):void {
				throw new Error('Encountered IOError while uploading.\n'+e);
			});
			
			return true;
		}
	}
}