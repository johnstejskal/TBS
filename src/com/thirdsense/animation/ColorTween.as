package com.thirdsense.animation 
{
	import starling.utils.Color;
	/**
	 * ...
	 * @author Ben Leffler
	 */
	public class ColorTween
	{
		private var tRed:int;
		private var tGreen:int;
		private var tBlue:int;
		private var _target:Object;
		private var _frames:int;
		private var _transition:String;
		private var pause:int;
		private var _oRed:int;
		private var _oGreen:int;
		private var _oBlue:int;
		
		private var _tween:BTween;
		private var _worker:Function;
		
		public function ColorTween(target:Object, frames:int, transition:String="linear", pause:int=0) 
		{
			this.pause = pause;
			this._transition = transition;
			this._frames = frames;
			this._target = target;
		}
		
		public function toColor( color:uint ):void
		{
			this.init( target.color, color );
		}
		
		public function fromColor( color:uint, applyNow:Boolean = true ):void
		{
			this.fromToColor( color, target.color, applyNow );
		}
		
		public function fromToColor( startColor:uint, endColor:uint, applyNow:Boolean = true ):void
		{
			this.init( startColor, endColor );
			
			if ( applyNow )
			{
				this.target.color = startColor;
			}
		}
		
		public function useCustomWorker( worker:Function ):void
		{
			_worker = worker;
		}
		
		public function start():BTween
		{
			this._tween = new BTween( this, this.frames, this.transition, this.pause );
			this._tween.animate( "oRed", this.tRed );
			this._tween.animate( "oGreen", this.tGreen );
			this._tween.animate( "oBlue", this.tBlue );
			
			if ( this._worker != null && this._transition == BTween.CUSTOM_TWEEN )
			{
				this._tween.useCustomWorker( this._worker );
			}
			
			this._tween.start();
			
			return this._tween;
		}
		
		private function applyColor():void 
		{
			this.target.color = Color.rgb( this.oRed, this.oGreen, this.oBlue );
		}
		
		private function init( fromColor:uint, toColor:uint ):void
		{
			var fArr:Array = splitColor(fromColor);
			var tArr:Array = splitColor(toColor);
			
			this.oRed = fArr[0];
			this.oGreen = fArr[1];
			this.oBlue = fArr[2];
			
			this.tRed = tArr[0];
			this.tGreen = tArr[1];
			this.tBlue = tArr[2];
		}
		
		private function splitColor( color:uint ):Array
		{
			var r:int = Color.getRed(color);
			var g:int = Color.getGreen(color);
			var b:int = Color.getBlue(color);
			
			return [ r, g, b ];
		}
		
		public function get oRed():int 
		{
			return _oRed;
		}
		
		public function set oRed(value:int):void 
		{
			_oRed = value;
		}
		
		public function get oGreen():int 
		{
			return _oGreen;
		}
		
		public function set oGreen(value:int):void 
		{
			_oGreen = value;
		}
		
		public function get oBlue():int 
		{
			return _oBlue;
		}
		
		public function set oBlue(value:int):void 
		{
			_oBlue = value;
			
			this.applyColor();
		}
		
		public function get target():Object 
		{
			return _target;
		}
		
		public function get frames():int 
		{
			return _frames;
		}
		
		public function get transition():String 
		{
			return _transition;
		}
		
		public function get tween():BTween 
		{
			return _tween;
		}
		
	}

}