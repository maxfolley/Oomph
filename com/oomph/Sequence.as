//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 Maxsquatch
// 
////////////////////////////////////////////////////////////////////////////////
package com.oomph
{
	
	import flash.events.EventDispatcher;
		
	public class Sequence extends EventDispatcher
	{
		
		private var _paramArr:Array;
		private var _targArr:Array;
		private var _valueArr:Array;
		private var _numTweens:int;
		private var _tweenIndex:int;
		
		public function get paramArr():Array
		{
			return _paramArr;
		}
		
		public function get targArr():Array
		{
			return _targArr;
		}
		
		public function get valueArr():Array
		{
			return _valueArr;
		}
		
		public function Sequence():void
		{
			_paramArr = [];
			_targArr = [];
			_valueArr = [];
		}
		
		public function addTween(targ:Object, values:Object, params:Object = null):void
		{
			_paramArr.push(params);
			_targArr.push(targ);
			_valueArr.push(values);
			_numTweens = _targArr.length;
		}
		
		private function runTween(index:int):void
		{
			Oomph.tweenTo(_targArr[index], _valueArr[index], _paramArr[index]);
		}
		
		/**
		 * Starts the sequence from the very first tween 
		 */		
		public function start():void
		{
			Oomph.addEventListener(OomphEvent.TWEEN_COMPELTE, tweenCompleteHandler);
			_tweenIndex = 0;
			runTween(_tweenIndex);
		}
		
		///////////////////
		// Event Handler //
		///////////////////
		private function tweenCompleteHandler(event:OomphEvent):void
		{
			_tweenIndex++;
			if(_tweenIndex < _numTweens) {
				runTween(_tweenIndex);
			} else {
				Oomph.removeEventListener(OomphEvent.TWEEN_COMPELTE, tweenCompleteHandler);
				dispatchEvent(new OomphEvent(OomphEvent.SEQUENCE_COMPLETE));
			}
		}
		
	}
}