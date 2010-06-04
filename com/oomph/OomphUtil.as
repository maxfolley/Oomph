//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 Maxsquatch
// 
////////////////////////////////////////////////////////////////////////////////
package com.oomph
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	internal class OomphUtil
	{
		
		private var _callDict:Dictionary;
		private var _funcDict:Dictionary;
		
		private static var _instance:OomphUtil;
		
		public static function getInstance():OomphUtil 
		{
			if(_instance == null) {
				_instance = new OomphUtil(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function OomphUtil(enforcer:SingletonEnforcer)
		{
			_callDict = new Dictionary(true);
			_funcDict = new Dictionary(true);
		}
		
		/**
		 * Calls functions stored using the commitLater function
		 */		
		public function call():void
		{	
			for(var func:Object in _callDict) {
				func.apply(this, _callDict[func]);
			}
			delete _callDict[func];
		}
		
		/**
		 * Stores functions to be called until the commit function is called 
		 * @param func
		 * @param paramsArr
		 */		
		public function callLater(func:Function, ...args):void
		{
			_callDict[func] = args;
		}
		
		/**
		 * Cancels a delayed function from being called 
		 * @param func
		 */		
		public function cancelCall(func:Function):void
		{
			var tmr:Timer;
			var funcObj:Object;
			for(var key:Object in _funcDict)
			{
				tmr = key as Timer;
				funcObj = _funcDict[tmr];
				if(funcObj.func == func)
				{
					delete _funcDict[key];
					
					tmr.stop();
					tmr.removeEventListener(TimerEvent.TIMER, tmrHandler);
					tmr = null;
						
				}
			}
		}
		
		/**
		 * Loops through all props of an object setting new object propsto those values 
		 * @param obj
		 * @return 
		 * 
		 */		
		public function clone(obj:Object):Object
		{
			var newObj:Object = {};
			for(var key:Object in obj) {
				newObj[key] = obj[key];
			}
			return newObj;
		}
		
		/**
		 * Loops one object setting the properties of the other  
		 * @param oldObj
		 * @param newObj
		 * @param ignoreDuplicates
		 * @return Object new object with modified values
		 */				
		public function copyTo(oldObj:Object, newObj:Object, ignoreDuplicates:Boolean = false):Object
		{
			var obj:Object = newObj;
			for(var key:Object in oldObj) {
				if(!ignoreDuplicates || newObj[key] == null) {
					obj[key] = oldObj[key];
				}
			}
			return obj;
		}
		
		/**
		 * Converts degress to radians
		 * @param number degrees	// Degress to convert
		 * @return Number
		 */
		public function degs2Rads(degrees:Number):Number {
			return degrees * Math.PI/180;
		}
		
		public function delayCall(func:Function, delay:Number, args:Array):void {
			var funcObj:Object = {func: func, args: args};
			var tmr:Timer = new Timer(delay, 1);
			
			// Store the func object in the dictionary so it can be referenced 
			_funcDict[tmr] = funcObj;
			
			tmr.addEventListener(TimerEvent.TIMER, tmrHandler, false, 0, true);
			tmr.start();
		}
		
		/**
		 * Takes two points and returns the angle of the second point according to the first
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param useRadians
		 * @return Number
		 */
		public function getAngle(x1:Number, y1:Number, x2:Number, y2:Number, useRadians:Boolean = false):Number {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			var radians:Number = Math.atan2(dy, dx);
			var angle:Number = radians;
			if(!useRadians) angle = rads2Degs(angle);
			return angle;
		}
		
		/**
		 * Returns new value with beziez points applied
		 * @param b - beginning value
		 * @param e - end value
		 * @param t - modified time, 0 - 1, with easing function applied
		 * @param p - point object or array of point object
		 * 
		 */		
		public function getBezierPosition(b:Number, e:Number, t:Number, p:Object):Number
		{
			var numPoints:int = p.length;;
			if(numPoints == 1) {
				return b + t*(2*(1-t)*(p[0]-b) + t*(e - b));
			} else {
				// Array of bezier control points, must find the point between each pair of bezier points
				var ip:int = Math.floor(t * numPoints); // Position on the bezier list
				// min for ip is 0 and max is numPoints - 1
				if(ip < 0) ip = 0;
				if(ip >= numPoints) ip = numPoints - 1;
				
				var it:Number = (t - (ip * (1 / numPoints))) * numPoints; // t inside this ip
				var p1:Number, p2:Number;
				if (ip <= 0) {
					// First part: belongs to the first control point, find second midpoint
					p1 = b;
					p2 = (p[0]+p[1])/2;
				} else if (ip == numPoints - 1) {
					// Last part: belongs to the last control point, find first midpoint
					p1 = (p[ip-1]+p[ip])/2;
					p2 = e;
				} else {
					// Any middle part: find both midpoints
					p1 = (p[ip-1]+p[ip])/2;
					p2 = (p[ip]+p[ip+1])/2;
				}
				return p1+it*(2*(1-it)*(p[ip]-p1) + it*(p2 - p1));
			}
		}
		
		/**
		 * Converts a hexadecimal color value into RGB values
		 * Returns an Object containing the properties red, blue an green
		 * @param value		// The hexadecimal value
		 * @return Object   // RGB values accessed via Object.red, Object.blue...
		 */
		public function hexToRGB(value:uint):Object {
			var colorObj:Object = new Object();
			colorObj.red = value >> 16;
			colorObj.green = value >> 8 & 0xFF;
			colorObj.blue = value & 0xFF;
			return colorObj;
		}
		
		/**
		 * run the Pythagorean theorem to get the hypotenuse of a triangle
		 *
		 * @param number $a			//one side of triangle, like x
		 * @param number $b			//other side of triangle, like y
		 * @return Number
		 */
		public function pythag(a:Number, b:Number):Number {
			return Math.sqrt(Math.pow(a,2) + Math.pow(b,2));
		}
		
		
		/**
		 * Converts degress to radians
		 * @param number degrees	// Degress to convert
		 * @return Number
		 */
		public function rads2Degs(radians:Number):Number {
			return radians * 180/Math.PI;
		}
		
		////////////////////
		// Event Handlers //
		////////////////////
		private function tmrHandler(event:TimerEvent):void
		{
			var tmr:Timer = event.target as Timer;
			tmr.removeEventListener(TimerEvent.TIMER, tmrHandler);
			var funcObj:Object = _funcDict[tmr];
			
			funcObj.func.apply(null, funcObj.args);
			delete _funcDict[tmr];
			tmr = null;
		}
		
	}
}

class SingletonEnforcer {}