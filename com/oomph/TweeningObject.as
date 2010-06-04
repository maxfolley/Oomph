//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 Maxsquatch
// 
////////////////////////////////////////////////////////////////////////////////
package com.oomph
{
	
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	internal class TweeningObject
	{	
		
		private var _filters:Array = new Array();						// Stores any previous filters on the target object and the blur filter
		private var _bFilter:BlurFilter;								// Filter used for motion blur
		private var _oomphEngine:OomphEngine = OomphEngine.getInstance();
		private var _blue:int;
		private var _green:int;
		private var _red:int;
		private var _blurX:Number = 0;
		private var _blurY:Number = 0;
		private var _frame:Number = 0;
		private var _prevX:Number = new Number();
		private var _prevY:Number = new Number();
		private var _targObj:Object;
		private var _oomphUtil:OomphUtil = OomphUtil.getInstance();
		private var _tint:Number = 1;
		private var _timer:Timer;
		private var _tweenVO:TweenVO;
		private var _beginColor:uint;
		private var _initColor:uint;
		
		public function get filters():Array { return _filters; }
		
		public function set filters(value:Array):void
		{
			_filters = value;
			_targObj.filters = _filters;
		}
		
		public function get bFilter():BlurFilter { return _bFilter; }
		
		public function set bFilter(value:BlurFilter):void { _bFilter = value; }
		
		public function get blue():int { return _blue; }

		public function set blue(value:int):void
		{
			_blue = value;
			_oomphUtil.callLater(applyColors);
		}
		
		public function get green():int { return _green; }

		public function set green(value:int):void
		{
			_green = value;
			_oomphUtil.callLater(applyColors);
		}
		
		public function get red():int { return _red; }

		public function set red(value:int):void
		{
			_red = value;
			_oomphUtil.callLater(applyColors);
		}
		
		public function get blurX():Number { return _blurX; }
		
		public function set blurX(value:Number):void
		{ 
			_blurX = value;
			_oomphUtil.callLater(blur);
		}
		
		public function get blurY():Number { return _blurY; }
		
		public function set blurY(value:Number):void {
			_blurY = value;
			_oomphUtil.callLater(blur);
		}
		
		public function get frame():Number { return _frame; }
		
		/**
		* Sets the current fram to the rounded value of _frame;	
		*/
		public function set frame(value:Number):void
		{
			_frame = Math.round(value);
			_targObj.gotoAndStop(_frame);
		}
		
		public function get prevX():Number { return _prevX };
		
		public function set prevX(value:Number):void { _prevX = value };
		
		public function get prevY():Number { return _prevY };
		
		public function set prevY(value:Number):void { _prevY = value };
		
		public function get tint():Number { return _tint };
		
		public function set tint(value:Number):void
		{
			_tint = value;
			_oomphUtil.callLater(applyColors);
		}

		public function get targObj():Object { return _targObj };
		
		public function get timer():Timer { return _timer };
		
		public function set timer(value:Timer):void { _timer = value };
		
		public function get tweenVO():TweenVO { return _tweenVO };
		
		public function get beginColor():uint { return _beginColor };

		public function set beginColor(value:uint):void { _beginColor = value };
		
		/**
		 * @param targObj:Object - object that is to be tweened	
		 * @param tweenVO:TweenVO - sores all data for the tween
		 */		
		public function TweeningObject(targObj:Object, tweenVO:TweenVO = null):void
		{
			_targObj = targObj;
			_tweenVO = tweenVO;
		}
		
		/**
		 * Apply any color transformations
		 */		
		private function applyColors():void
		{
			var cTrans:ColorTransform = new ColorTransform();
			var tValue:Number = 1 - _tint;
			_targObj.transform.colorTransform = new ColorTransform(tValue, tValue, tValue, 1, _red * _tint, _green * _tint, _blue * _tint, _targObj.alpha);
		}
		
		/**
		 * Apply motion blur 
		 */		
		public function blur():void
		{
			_blurX = Math.abs(_targObj.x - _prevX) * _tweenVO.blurStrength;
			_blurY = Math.abs(_targObj.y - _prevY) * _tweenVO.blurStrength;
			_prevX = _targObj.x;
			_prevY = _targObj.y;
			
			if(_bFilter == null) {
				_bFilter = new BlurFilter(_blurX, _blurY, _tweenVO.blurQuality);
				_filters.push(_bFilter);
			} else {
				_bFilter.blurX = _blurX;
				_bFilter.blurY = _blurY;
			}
			_targObj.filters = _filters;
		}
		
		/**
		 * Removes blur filter
		 */
		public function clearBlur():void
		{
			_blurX = 0;
			_blurY = 0;
			_targObj.filters = removeFilters(BlurFilter);
		}
		
		public function destroy():void
		{
			if(_tweenVO.useSeconds) {
				_oomphEngine.stopTween(_tweenVO);
				_timer = null;
			} else {
				_oomphEngine.stopTween(_tweenVO);
			}
			if(_tweenVO.motionBlur) clearBlur();
		}
		
		/**
		 * Draws bezier curves for easy motion choreographing
		 * Only works if object has a parent
		 */		
		public function drawBezier(targX:Number, targY:Number):void
		{
			if(targObj.parent != null) {
				var anchorX:Number;
				var anchorY:Number;
				var controlX:Number;
				var controlY:Number;
				
				targObj.parent.graphics.lineStyle(1, 0xcccccc);
				targObj.parent.graphics.moveTo(_targObj.x, _targObj.y);
				
				if(_tweenVO.bezier is Array) {
					var numLines:int = _tweenVO.bezier.length;
					var i:int;
					while(i < numLines) {
						// Last bezier, anchors are target coordinates
						if(i == numLines - 1) {
							anchorX = targX;
							anchorY = targY;
						} else {
							anchorX = (_tweenVO.bezier[i].x + _tweenVO.bezier[i + 1].x)/2;
							anchorY = (_tweenVO.bezier[i].y + _tweenVO.bezier[i + 1].y)/2;
						}
						controlX = _tweenVO.bezier[i].x;
						controlY = _tweenVO.bezier[i].y;
						
						targObj.parent.graphics.curveTo(controlX, controlY, anchorX, anchorY);
						i++;
					}
				} else {
					anchorX = targX;
					anchorY = targY;
					controlX = _tweenVO.bezier.x;
					controlY = _tweenVO.bezier.y;
					targObj.parent.graphics.curveTo(controlX, controlY, anchorX, anchorY);
				}
						
			} else {
				Warnings.BEZIER_PARENT;
			}
		}
		
		/**
		 * Removes all filters on an object of a specified class	
		 */
		public function removeFilters(filterType:Class):Array
		{
			var targFilts:Array = this.filters;
			var numFilts:int = targFilts.length;
			var i:int = 0;
			while(i < numFilts) {
				if(targFilts[i] is filterType) {
					targFilts.splice(i, 1);
					numFilts = targFilts.length;
				}
				i++;
			}
			return targFilts;
		}
		
		/**
		 * Checks if the targObj has the property, if not it attempts to set it in this instace
		 */
		public function setProp(propName:String, propValue:Object):void
		{
			// If the target object has the property, set its value
			if(_targObj.hasOwnProperty(propName)) {	
				_targObj[propName] = propValue;
			// If the object doesn't have the property and it exists as a register property, set this isntances property value
			} else {
				this[propName] = propValue;
			}
		}
	}
}