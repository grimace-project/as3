package org.grimace.display { 
	import flash.geom.Point;
	import flash.display.Sprite;
	
	public interface ISpline {
/*		function evaluate():void;*/
		function drawStroke(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void;
		function drawFill(start:Boolean = true, end:Boolean = true, mirror:Boolean = false):void;
		function getPoint(t:Number, mirror:Boolean = false):Point;
		function getPointsAsArray(visibleOnly:Boolean = false):Array;
		function getStart():Point;
		function getEnd():Point;
		function getSlopeAngle(t:Number):Number;
		function getNormalAngle(t:Number):Number;
		function clone():ISpline;
		function reverse():void;
		function traceSpline(canvas:Sprite, nonstop:Boolean = false, mirror:Boolean = false, reverse:Boolean = false):void;
		
		function set strokeCanvas(s:Sprite):void;
		function get strokeCanvas():Sprite;
		function set fillCanvas(s:Sprite):void;
		function get fillCanvas():Sprite;
		function set fillColor(color:uint):void;
		function get fillColor():uint;
		function set fillAlpha(alpha:Number):void;
		function get fillAlpha():Number;
		function set lineColor(color:uint):void;
		function get lineColor():uint;
		function set lineWidth(width:Number):void;
		function get lineWidth():Number;
		function set lineMinWidth(width:Number):void;
		function get lineMinWidth():Number;
		function set lineMaxWidth(width:Number):void;
		function get lineMaxWidth():Number;
		function set lineAlpha(alpha:Number):void;
		function get lineAlpha():Number;
		function set mirrored(isMirrored:Boolean):void;
		function get mirrored():Boolean;
	}
}