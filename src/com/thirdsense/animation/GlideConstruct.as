package com.thirdsense.animation 
{
	import com.thirdsense.animation.GlideExaminer;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.utils.Trig;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	
	/**
	 * The Glide construct that can be used as a display object in Starling. Allows runtime examined classic MovieClip objects to be used with a Starling project
	 * translating motion, transformation and alpha/color tweens. [ALPHA]
	 * @author Ben Leffler
	 */
	
	public dynamic class GlideConstruct extends Sprite implements IAnimatable
	{
		private var _currentFrame:int
		private var _direction:int
		private var _looping:Boolean;
		private var _fps:int;
		private var _repeatCount:int;
		private var _ignoreColorTransforms:Boolean;
		private var _disposeExaminerOnRemove:Boolean;
		private var _autoPlayMovieClipChildren:Boolean;
		
		private var examiner:GlideExaminer;
		private var loop:String;
		private var override_params:Array;
		private var repeat_counter:int;
		private var elapsed_time:Number;
		
		public var texture_pack:TexturePack;
		
		/**
		 * Constructor function for the animation construct
		 * @param	examiner	The GlideExaminer object that will serve as the source for this instance
		 */
		
		public function GlideConstruct( examiner:GlideExaminer, texture_pack:TexturePack = null ) 
		{
			this.texture_pack = texture_pack;
			this.examiner = examiner
			this._currentFrame = 0;
			this._direction = 1;
			this._fps = (Starling.current.nativeStage as Stage).frameRate;
			this._looping = true;
			this._repeatCount = -1;
			this._ignoreColorTransforms = false;
			this._disposeExaminerOnRemove = false;
			this.elapsed_time = 0;
			this.repeat_counter = -1;
			
			this.reconstruct();
			this.nextFrame();
			
		}
		
		/**
		 * @private
		 */
		
		 private function reconstruct():void
		{
			for ( var i:uint = 0; i < examiner.totalElements; i++ )
			{
				var obj:Object = this.examiner.getElementAt(i);
				if ( !this.texture_pack )
				{
					var mc:starling.display.MovieClip = obj.asset as starling.display.MovieClip;
				}
				else
				{
					mc = this.texture_pack.getMovieClip(60, obj.name);
				}
				mc.name = obj.name;
				this[mc.name] = mc;
				this.addChild( mc );
			}
		}
		
		public function rebuild( tp:TexturePack ):void
		{
			this.texture_pack = tp;
			this.removeChildren();
			this.reconstruct();
			this.nextFrame();
		}
		
		/**
		 * Plays the reconstructed animation from either the current frame or a designated frame
		 * @param	frame	The frame to start the animation from. If this is left as null, the animation plays from the currentFrame. If this is passed as a numerical value,
		 * the animation plays from the desired frame number and runs the entire length of the timeline. If a frame label (string) is passed, the animation plays from the
		 * associated frame and will only play the number of frames associated with the frame label in the original timeline.
		 */
		
		public function play( frame:* = null ):void
		{
			this.repeat_counter = this._repeatCount;
			
			if ( frame != null )
			{
				if ( isNaN(frame) )
				{
					if ( this.examiner.getAllFrameLabels().indexOf(frame as String) >= 0 )
					{
						this.loop = frame as String;
						if ( this.direction > 0 )
						{
							this._currentFrame = this.examiner.getFrameLabelStart(frame as String) - 1;
						}
						else
						{
							this._currentFrame = this.examiner.getFrameLabelEnd(frame as String) + 1;
						}
					}
					else
					{
						trace( "Error calling play() as '" + String(frame) + "' is not an associated frame label from the original timeline" );
						this.loop = null;
						return void;
					}
				}
				else if ( !isNaN(frame) )
				{
					this._currentFrame = Trig.lim( int(frame) - 1, 0, this.examiner.totalFrames - 1 );
					this.loop = null;
				}
				else
				{
					this.loop = null;
				}
			}
			else
			{
				this.loop = null;
			}
			
			Starling.juggler.add(this);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
		}
		
		/**
		 * Stops an animation or stops after navigating to a specific frame
		 * @param	frame	Leaving as null will stop the animation at the currentFrame. Passing as a number will snap the animation to the desired frame and stop.
		 * Passing as a frame label (string) will snap the animation to the associated frame from the original timeline and stop.
		 */
		
		public function stop( frame:* = null ):void
		{
			if ( frame != null )
			{
				if ( isNaN(frame) )
				{
					if ( this.examiner.getAllFrameLabels().indexOf(frame as String) >= 0 )
					{
						if ( this.direction > 0 )
						{
							this._currentFrame = this.examiner.getFrameLabelStart(frame as String);
							
						}
						else
						{
							this._currentFrame = this.examiner.getFrameLabelEnd(frame as String);
						}
					}
					else
					{
						trace( "Error calling stop() as '" + String(frame) + "' is not an associated frame label from the original timeline. Stopping at currentFrame instead." );
					}
				}
				else if ( !isNaN(frame) )
				{
					this._currentFrame = Trig.lim( int(frame) - 1, 1, this.examiner.totalFrames );
				}
			}
			
			this.applyTransformToAll();			
			this.removeHandler(null);
		}
		
		/**
		 * @private
		 */
		
		private function removeHandler(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
			Starling.juggler.remove(this);
			this.dispatchEvent( new Event(Event.REMOVE_FROM_JUGGLER) );
			this.elapsed_time = 0;
		}
		
		/**
		 * Navigates the animation to the next frame in the sequence. If looping is enabled and the animation is the final frame of the sequence,
		 * it will wrap around to the opposite end of the desired loop.
		 */
		
		public function nextFrame():void
		{
			this._currentFrame++;
			
			if ( this.loop != null )
			{
				if ( this.currentFrame > this.examiner.getFrameLabelEnd(this.loop) )
				{
					if ( this._looping && this.repeat_counter != 0 )
					{
						this._currentFrame = this.examiner.getFrameLabelStart(this.loop);
						if ( this.repeat_counter > 0 ) this.repeat_counter--;
					}
					else
					{
						this._currentFrame = this.examiner.getFrameLabelEnd(this.loop);
						this.stop();
					}
				}
			}
			else if ( this._currentFrame > this.examiner.totalFrames )
			{
				if ( this._looping && this.repeat_counter != 0)
				{
					this._currentFrame = 1;
					if ( this.repeat_counter > 0 ) this.repeat_counter--;
				}
				else
				{
					this._currentFrame = this.examiner.totalFrames;
					this.stop();
				}
			}
			this.applyTransformToAll();
			
		}
		
		/**
		 * The total number of frames available in this GlideConstruct instance
		 */
		
		public function get totalFrames():int
		{
			return this.examiner.totalFrames;
		}
		
		/**
		 * Navigates the animation to the previous frame in the sequence. If looping is enabled and the animation is the first frame of the sequence,
		 * it will wrap around to the opposite end of the desired loop.
		 */
		
		public function prevFrame():void
		{
			this._currentFrame--;
			
			if ( this.loop != null )
			{
				if ( this.currentFrame < this.examiner.getFrameLabelStart(this.loop) )
				{
					if ( this._looping && this.repeat_counter != 0 )
					{
						this._currentFrame = this.examiner.getFrameLabelEnd(this.loop);
						if ( this.repeat_counter > 0 ) this.repeat_counter--;
					}
					else
					{
						this._currentFrame = this.examiner.getFrameLabelStart(this.loop);
						this.stop();
					}
				}
			}
			else if ( this._currentFrame == 0 ) 
			{
				if ( this._looping && this.repeat_counter != 0 )
				{
					this._currentFrame = this.examiner.totalFrames;
					if ( this.repeat_counter > 0 ) this.repeat_counter--;
				}
				else
				{
					this._currentFrame = 1;
					this.stop();
				}
			}
			this.applyTransformToAll();
		}
		
		/**
		 * @private	Applies the transformation for the current frame to all children
		 */
		
		private function applyTransformToAll():void
		{
			var children:int = this.numChildren;
			
			for ( var i:uint = 0; i < children; i++ )
			{
				this.applyRender( this.getChildAt(i) );
				
				if ( this.getChildAt(i) is starling.display.MovieClip && this.autoPlayMovieClipChildren )
				{
					var mc:starling.display.MovieClip = this.getChildAt(i) as starling.display.MovieClip;
					if ( mc.visible )
					{
						var fr:int = mc.currentFrame;
						fr + 1 == mc.numFrames ? fr = 0 : fr++;
						mc.currentFrame = fr;
					}
					else
					{
						mc.currentFrame = 0;
					}
				}
			}
		}
		
		/**
		 * @private	Applies the render transformation to the desired display object
		 */
		
		private function applyRender( img:DisplayObject ):void
		{
			var frame:int = this._currentFrame;
			var trans:Matrix = examiner.getMatrix( img.name, frame );
			var ctrans:ColorTransform = examiner.getColorTransform( img.name, frame );
			var index:int = examiner.getIndex( img.name, frame );
			var pt:Point;
			var red:int;
			var green:int;
			var blue:int;
			var _alpha:int;
			
			if ( trans )
			{
				if ( this.overrideExists(img.name) < 0 )
				{
					pt = new Point( img.pivotX, img.pivotY );
					img.pivotX = img.pivotY = 0;
					img.transformationMatrix = trans;
					img.pivotX = pt.x;
					img.pivotY = pt.y;
				}
				img.alpha = ctrans.alphaMultiplier;
				img.alpha > 0 ? img.visible = true : img.visible = false;
				
				if ( !this._ignoreColorTransforms )
				{
					red = Trig.lim( (ctrans.redMultiplier + ctrans.redOffset) * 255, 0, 255 );
					green = Trig.lim( (ctrans.greenMultiplier + ctrans.greenOffset) * 255, 0, 255 );
					blue = Trig.lim( (ctrans.blueMultiplier + ctrans.blueOffset) * 255, 0, 255 );
					_alpha = Trig.lim( img.alpha * 255, 0, 255 );
					if ( img is Image ) (img as Image).color = Color.argb( _alpha, red, green, blue );
					else if ( img is starling.display.MovieClip )(img as starling.display.MovieClip).color = Color.argb( _alpha, red, green, blue );
				}
				
				if ( this.getChildIndex(img) != index ) this.setChildIndex( img, index );
			}
			else
			{
				img.visible = false;
			}
		}
		
		/**
		 * Retrieves the current frame that the playhead is located at (will be a value of 1 to n)
		 */
		
		public function get currentFrame():int 
		{
			return _currentFrame;
		}
		
		/**
		 * Retrieves if the animation construct is currently playing (is 'true' if the Starling juggler contains this object)
		 */
		public function get isPlaying():Boolean
		{
			return Starling.juggler.contains(this);
		}
		
		/**
		 * Obtains the direction of the animation. If moving forward, this value is 1. If moving backwards, this value is -1;
		 */
		
		public function get direction():int 
		{
			return _direction;
		}
		
		/**
		 * Sets the looping value of the animation construct. (Default value is true)
		 */
		public function get looping():Boolean 
		{
			return _looping;
		}
		
		/**
		 * @private
		 */
		public function set looping(value:Boolean):void 
		{
			if ( value == true && this.repeatCount == 0 )
			{
				this.repeatCount = -1;
			}
			_looping = value;
		}
		
		/**
		 * The desired frames-per-second of the animation construct.
		 */
		public function get fps():int 
		{
			return _fps;
		}
		
		/**
		 * @private
		 */
		public function set fps(value:int):void
		{
			_fps = value;
		}
		
		/**
		 * Sets and retrieves the number of loops the animation will cycle through before stopping. Settings this value to 0 will also set the looping variable to false.
		 */
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		/**
		 * @private
		 */
		public function set repeatCount(value:int):void 
		{
			this.repeat_counter = value;
			_repeatCount = value;
			
			if ( value == 0 ) this.looping = false;
		}
		
		/**
		 * Obtains the number of loops that are currently remaining in an animation loop. If the animation is set to loop indefinitely, the value returned is -1
		 */
		public function get remainingLoops():int
		{
			return this.repeat_counter;
		}
		
		/**
		 * Ignores all colorTransform data from the GlideExaminer when rendering if set to true
		 */
		public function get ignoreColorTransforms():Boolean 
		{
			return _ignoreColorTransforms;
		}
		
		/**
		 * @private
		 */
		public function set ignoreColorTransforms(value:Boolean):void 
		{
			_ignoreColorTransforms = value;
		}
		
		/**
		 * Once this instance has been removed from stage, if this value is set to true then the examiner associated with this instance will
		 * be disposed of.
		 * @default	false
		 */
		
		public function get disposeExaminerOnRemove():Boolean 
		{
			return _disposeExaminerOnRemove;
		}
		
		/**
		 * @private
		 */
		
		public function set disposeExaminerOnRemove(value:Boolean):void 
		{
			if ( value == true && _disposeExaminerOnRemove == false )
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, this.examinerRemoveHandler);
			}
			else
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, this.examinerRemoveHandler);
			}
			
			_disposeExaminerOnRemove = value;
		}
		
		/**
		 * If the examiner was created to include asset children, passing this as true will autoplay through the children
		 * frames upon playing this instance
		 */
		
		public function get autoPlayMovieClipChildren():Boolean 
		{
			return _autoPlayMovieClipChildren;
		}
		
		/**
		 * @private
		 */
		
		public function set autoPlayMovieClipChildren(value:Boolean):void 
		{
			_autoPlayMovieClipChildren = value;
		}
		
		/**
		 * @private
		 */
		
		private function examinerRemoveHandler(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, examinerRemoveHandler);
			this.examiner.dispose();
		}
		
		/**
		 * Switches the animation playhead direction
		 */
		public function reverse():void
		{
			this._direction == 1 ? this._direction = -1 : this._direction = 1;
		}
		
		/**
		 * Releases an asset from matrix transformation by this class. Use this call if you wish to add dynamic transformation to an asset (such as user interaction based rotation etc.)
		 * This function does not release an asset from depth, color and alpha control by this class - it will only apply release to matrix transformations.
		 * @param	asset_name	The name of the asset to disable.
		 */
		
		public function overrideAsset( asset_name:String ):void
		{
			if ( !this.override_params ) this.override_params = new Array();
			if ( !this.overrideExists(asset_name) >= 0 )
			{
				this.override_params.push( asset_name );
			}
		}
		
		/**
		 * If an asset transformation has been previously overriden, this will reinstate the asset control to this class.
		 * @param	asset_name	The name of the asset to reinstate.
		 */
		
		public function removeAssetOverride( asset_name:String ):void
		{
			var index:int = this.overrideExists(asset_name);
			if ( index >= 0 )
			{
				this.override_params.splice( index, 1 );
			}
		}
		
		/**
		 * @private	Checks if an asset is currently listed as overriden
		 * @param	asset_name
		 * @return
		 */
		
		private function overrideExists( asset_name:String ):int
		{
			if ( this.override_params )
			{
				var length:int = override_params.length;
				for ( var i:uint = 0; i < length; i++ )
				{
					if ( this.override_params[i] == asset_name )
					{
						return i;
					}
				}
			}
			
			return -1;
		}
		
		/**
		 * Retrieves the GlideExaminer object that was used to create the animation construct
		 * @return	The associated GlideExaminer object
		 */
		
		public function getExaminer():GlideExaminer
		{
			return this.examiner;
		}
		
		/**
		 * @inheritDoc
		 */
		
		public function advanceTime( passedTime:Number ):void
		{
			this.elapsed_time += passedTime;
			
			while ( this.elapsed_time > 1 / this.fps )
			{
				this._direction > 0 ? this.nextFrame() : this.prevFrame();
				this.elapsed_time -= (1 / this.fps);
			}
			
		}
		
		/**
		 * Obtains the bounds of all visible children in the construct instance for the current frame
		 * @return	Rectangle bounds
		 */
		
		public function getVisibleBounds():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			
			for ( var i:uint = 0; i < this.numChildren; i++ )
			{
				var disp:DisplayObject = this.getChildAt(i);
				if ( disp.visible == true )
				{
					rect = rect.union( disp.bounds );
				}
			}
			
			rect.x *= this.scaleX;
			rect.y *= this.scaleY;
			rect.width *= this.scaleX;
			rect.height *= this.scaleY;
			
			return rect;
		}
		
		
	}

}