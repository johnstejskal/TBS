package com.thirdsense.starfx 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import com.thirdsense.starfx.DisplacementMapFilter;
	import starling.textures.RenderTexture;
	
	/**
	 * Creates a shockwave warp displacement effect to a target Starling display object.
	 * @author Ben Leffler
	 */
	
	public class DisplaceWave extends Object
	{
		private var dfilter:DisplacementMapFilter;
		private var target:DisplayObject;
		private var rt:RenderTexture;
		private var dmap:Image;
		private var dquad:Quad;
		private var frames:int;
		private var tween1:BTween;
		private var tween2:BTween;
		private var _wavesize:Number;
		private var _reverse:Boolean;
		private var _scale_tween_type:String;
		
		/**
		 * A function that will be called upon the completion of the effect. If dispose() is called before the effect has completed, this function
		 * will not be longer called.
		 */
		public var onComplete:Function;
		
		/**
		 * Constructor
		 */
		
		public function DisplaceWave() 
		{
			this._reverse = false;
			this._wavesize = 15;
			this._scale_tween_type = BTween.EASE_IN_OUT;
		}
		
		/**
		 * Creates a shockwave effect using a displacement filter
		 * @param	target	The Starling display object to apply the filter to
		 * @param	origin	The point within the target co-ordinate space where the shockwave effect will origin from
		 * @param	frames	The number of frames to apply the effect over
		 * @param	amount	The intensity of the warping effect to apply
		 */
		
		public function create( target:DisplayObject, origin:Point, frames:int = 40, amount:Number = 0.02 ):void
		{
			if ( target.filter is DisplacementMapFilter ) return void;
			
			this.target = target;
			this.frames = frames;
			
			this.createDMap( origin );
			this.createFilter( amount );
			this.startFilter();
			
		}
		
		/**
		 * @private
		 */
		
		private function createDMap( origin:Point ):void
		{
			if ( !TexturePack.getTexturePack("StarFX", "DisplaceWave") )
			{
				var spr:MovieClip = new MovieClip();
				
				var mat:Matrix = new Matrix();
				mat.createGradientBox( 100, 100, 0, -50, -50 );
				spr.graphics.beginGradientFill( GradientType.RADIAL, [0x808080, 0x000000, 0x808080, 0x000000, 0x808080], [1, 1, 1, 1, 1], [0, 66, 132, 198, 220], mat );
				spr.graphics.drawCircle( 0, 0, 50 );
				spr.graphics.endFill();
				
				spr.scaleX = target.width / target.height;
				
				TexturePack.createFromMovieClip( spr, "StarFX", "DisplaceWave" );
			}
			
			this.dmap = TexturePack.getTexturePack( "StarFX", "DisplaceWave" ).getImage();
			this.dmap.x = origin.x;
			this.dmap.y = origin.y;
			this.dmap.scaleX = this.dmap.scaleY = 0;
			
			this.dquad = new Quad( this.target.width, this.target.height, 0x808080 );
		}
		
		/**
		 * @private
		 */
		
		private function createFilter( amount:Number ):void
		{
			this.rt = new RenderTexture( this.target.width, this.target.height );
			this.dfilter = new DisplacementMapFilter( this.rt, amount );
			this.redraw();
		}
		
		/**
		 * @private
		 */
		
		private function startFilter():void
		{
			this.target.filter = this.dfilter;
			
			this.alphaPhase();
			this.scalePhase();
			
		}
		
		/**
		 * @private
		 */
		
		private function redraw():void
		{
			this.rt.drawBundled( this.drawBundled );			
			this.dfilter.mapTexture = this.rt;
		}
		
		/**
		 * @private
		 */
		
		private function drawBundled():void
		{
			this.rt.draw( this.dquad );
			this.rt.draw( this.dmap );
		}
		
		/**
		 * @private
		 */
		
		private function alphaPhase():void
		{
			if ( this._reverse )
			{
				this.dmap.alpha = 0;
				this.tween1 = new BTween( this.dmap, Math.round(this.frames * 0.25), BTween.LINEAR );
				this.tween1.fadeFromTo(0, 1)
				this.tween1.start(); 
			}
			else
			{
				this.tween1 = new BTween( this.dmap, Math.round(this.frames * 0.5), BTween.LINEAR, Math.round(this.frames/2) );
				this.tween1.fadeFromTo(1, 0)
				this.tween1.start();
			}
		}
		
		/**
		 * @private
		 */
		
		private function scalePhase():void
		{
			this.tween2 = new BTween( this.dmap, frames, _scale_tween_type );
			this._reverse ? this.tween2.scaleFromTo( this._wavesize, 0 ) : this.tween2.scaleFromTo( 0, this._wavesize )
			this.tween2.onTween = this.redraw;
			this.tween2.onComplete = this.kill;
			this.tween2.start();
		}
		
		/**
		 * Halts any existing animation and disposes of assets used to create the effect
		 */
		
		public function dispose():void
		{
			this.onComplete = null;
			BTween.removeFromCue( this.tween1 );
			BTween.removeFromCue( this.tween2 );
			this.kill();
		}
		
		/**
		 * @private
		 */
		
		private function kill():void
		{
			if ( this.target ) this.target.filter = null;
			if ( this.rt ) this.rt.dispose();
			if ( this.dfilter )
			{
				this.dfilter.mapTexture = null;
				this.dfilter.dispose();
			}
			if ( this.dmap ) this.dmap.dispose();
			if ( this.dquad ) this.dquad.dispose();
			
			this.target = null;
			
			if ( this.onComplete != null )
			{
				var fn:Function = this.onComplete;
				this.onComplete = null;
				fn();
			}
		}
		
		/**
		 * Sets the maximum scale of the shockwave - can be a value between 1 and 100 (default is 15)
		 */
		
		public function get wavesize():Number 
		{
			return _wavesize;
		}
		
		/**
		 * @private
		 */
		
		public function set wavesize(value:Number):void 
		{
			value = Math.max( 1, value );
			value = Math.min( 100, value );
			
			_wavesize = value;
		}
		
		/**
		 * Reverses the animation so the shockwave travels inward towards the origin point.
		 */
		
		public function get reverse():Boolean 
		{
			return _reverse;
		}
		
		/**
		 * @private
		 */
		
		public function set reverse(value:Boolean):void 
		{
			_reverse = value;
		}
		
		public function get scale_tween_type():String 
		{
			return _scale_tween_type;
		}
		
		public function set scale_tween_type(value:String):void 
		{
			_scale_tween_type = value;
		}
	}

}