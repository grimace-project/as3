package org.grimace.display { 
	import flash.geom.Point;
	import flash.display.Sprite;
	
	public interface IStrokeStyle {
		function draw(start:Boolean, end:Boolean, spline:ISpline, mirror:Boolean = false, ...params):void;
		
		function set strokeAlpha(a:Number):void;
		function get strokeAlpha():Number;
		
/*		function set canvas(c:Sprite):void;
		function get canvas():Sprite;
		function set spline(s:ISpline):void;
		function get spline():ISpline;
*/	}
}