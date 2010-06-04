/**
 * Robert Penner's easing equations
 */
/*
TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.
	
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	* Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
	
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.oomph
{
	
	internal class Easing
	{
		
		public function Easing():void
		{
		}
		
		public static function none(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		public static function inBack(t:Number, b:Number, c:Number, d:Number, s:Number = 0):Number
		{
			if (!s)
				s = 1.70158;
			
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		public static function outBack(t:Number, b:Number, c:Number, d:Number, s:Number = 0):Number
		{
			if (!s)
				s = 1.70158;
			
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		public static function inOutBack(t:Number, b:Number, c:Number, d:Number, s:Number = 0):Number
		{
			if (!s)
				s = 1.70158; 
			
			if ((t /= d / 2) < 1)
				return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
		
		public static function outBounce(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d) < (1 / 2.75))
				return c * (7.5625 * t * t) + b;
				
			else if (t < (2 / 2.75))
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
				
			else if (t < (2.5 / 2.75))
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
				
			else
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
		}
		
		public static function inBounce(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c - outBounce(d - t, 0, c, d) + b;
		}
		
		public static function inOutBounce(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d/2)
				return inBounce(t * 2, 0, c, d) * 0.5 + b;
			else
				return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
		}
		
		public static function inCirc(t:Number, b:Number,
									  c:Number, d:Number):Number
		{
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		public static function outCirc(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sqrt(1 - (t = t/d - 1) * t) + b;
		}
		
		public static function inOutCirc(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1)
				return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
			
			return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
		
		public static function inCubic(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t + b;
		}
		
		public static function outCubic(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		public static function inOutCubic(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1)
				return c / 2 * t * t * t + b;
			
			return c / 2 * ((t -= 2) * t * t + 2) + b;
		}
		
		public static function inElastic(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			if (t == 0)
				return b;
			
			if ((t /= d) == 1)
				return b + c;
			
			if (!p)
				p = d * 0.3;
			
			var s:Number;
			if (!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			
			return -(a * Math.pow(2, 10 * (t -= 1)) *
				Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		}
		 
		public static function outElastic(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			if (t == 0)
				return b;
			
			if ((t /= d) == 1)
				return b + c;
			
			if (!p)
				p = d * 0.3;
			
			var s:Number;
			if (!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			
			return a * Math.pow(2, -10 * t) *
				Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
		}
		
		public static function inOutElastic(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			if (t == 0)
				return b;
			
			if ((t /= d / 2) == 2)
				return b + c;
			
			if (!p)
				p = d * (0.3 * 1.5);
			
			var s:Number;
			if (!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			
			if (t < 1)
			{
				return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) *
					Math.sin((t * d - s) * (2 * Math.PI) /p)) + b;
			}
			
			return a * Math.pow(2, -10 * (t -= 1)) *
				Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
		}
		
		public static function inExpo(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
		}
		
		public static function outExpo(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t == d ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
		}
		 
		public static function inOutExpo(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0)
				return b;
			
			if (t == d)
				return b + c;
			
			if ((t /= d / 2) < 1)
				return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
			
			return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		public static function inQuad(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t + b;
		}
		 
		public static function outQuad(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (t /= d) * (t - 2) + b;
		}
		
		public static function inOutQuad(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1)
				return c / 2 * t * t + b;
			
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}

		public static function inQuart(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t + b;
		}
		
		public static function outQuart(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		 
		public static function inOutQuart(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1)
				return c / 2 * t * t * t * t + b;
			
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
		
		public static function inQuint(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t * t + b;
		}
		
		public static function outQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		public static function inOutQuint(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1)
				return c / 2 * t * t * t * t * t + b;
			
			return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		public static function inSine(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
		}
		
		public static function outSine(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sin(t / d * (Math.PI / 2)) + b;
		}
		
		public static function inOutSine(t:Number, b:Number,
										 c:Number, d:Number):Number
		{
			return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
		
	}
	
}