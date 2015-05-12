package com.thirdsense.ui.display 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.sound.SoundStream;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	
	/**
	 * Creates a button from a classic Display List MovieClip
	 * @author Ben Leffler
	 */
	
	public dynamic class LPButton extends Sprite 
	{
		private var _source_width:Number;
		private var _source_height:Number;
		private var onRelease:Function;
		private var _disabled:Boolean;
		private var content:MovieClip;
		
		public static var button_sound:String = "";
		
		/**
		 * The local tween instance that can be used for transitions and animation of this button
		 */
		public var tween:BTween;
		
		/**
		 * This function is called (if not null) when this button has been disabled by the disable() function
		 */
		public var onDisable:Function;
		
		/**
		 * This function is called (if not null) when this button has been enabled by the enable() function
		 */
		public var onEnable:Function;
		
		/**
		 * Constructs a simple button based on a classic display list MovieClip
		 * @param	mc	The MovieClip object to use as a button
		 * @param	onRelease	If a click on the button is detected, call this function. The function must accept an LPButton object as it's argument.
		 */
		
		public function LPButton( mc:MovieClip, onRelease:Function ) 
		{
			this.onRelease = onRelease;
			this.content = mc;
			
			mc.x = 0;
			mc.y = 0;
			this.addChild( mc );
			mc.gotoAndStop(1);
			
			this.addListeners();
			
			this._disabled = false;
			this.mouseEnabled = true;
			this.mouseChildren = false;
			
		}
		
		/**
		 * Disables the button.
		 * @param	fade_button	Multiplies the button's alpha value by 0.25 if passed as true
		 */
		
		public function disable( fade_button:Boolean=true ):void
		{
			if ( this._disabled ) return void;
			
			this._disabled = true;
			
			if ( fade_button )
			{
				this.alpha *= 0.25;
			}
			
			if ( this.onDisable != null )
			{
				this.onDisable();
			}
			
		}
		
		/**
		 * Returns the x,y co-ords of the button in a point format
		 * @return
		 */
		
		public function getPoint():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * Enables a button if previously disabled and turns it fully visable or multiplies it's alpha by 4 (whatever is less in value)
		 */
		
		public function enable():void
		{
			if ( this._disabled ) {
				this._disabled = false;
				this.alpha = Math.min( 1, this.alpha * 4 );
				if ( this.onEnable != null )
				{
					this.onEnable();
				}
			}
			
		}
		
		/**
		 * @private	Adds the listeners necessary for this to become a button
		 */
		
		private function addListeners():void
		{
			this.addEventListener( MouseEvent.MOUSE_DOWN, this.clickHandler, false, 0, true );
			this.addEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler, false, 0, true );			
		}
		
		/**
		 * @private
		 */
		
		private function clickHandler( evt:MouseEvent ):void
		{
			if ( this._disabled ) return void;
			
			switch ( evt.type )
			{
				case MouseEvent.MOUSE_DOWN:
					if ( this.content.totalFrames > 1 )
					{
						this.content.gotoAndStop(2);
					}
					this.stage.addEventListener( MouseEvent.MOUSE_UP, this.clickHandler, false, 0, true );
					this.addEventListener( MouseEvent.MOUSE_UP, this.clickHandler, false, 0, true );
					this.addEventListener( MouseEvent.MOUSE_OVER, this.hoverHandler, false, 0, true );
					this.addEventListener( MouseEvent.MOUSE_OUT, this.hoverHandler, false, 0, true );
					break;
					
				case MouseEvent.MOUSE_UP:
					this.content.gotoAndStop(1);
					this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.clickHandler );
					this.removeEventListener( MouseEvent.MOUSE_UP, this.clickHandler );
					this.removeEventListener( MouseEvent.MOUSE_OVER, this.hoverHandler );
					this.removeEventListener( MouseEvent.MOUSE_OUT, this.hoverHandler );
					
					if ( evt.currentTarget != this.stage && this.onRelease != null )
					{
						if ( button_sound.length )
						{
							SoundStream.play( button_sound );
						}
						
						this.onRelease( this );
					}
					break;
				
			}
		}
		
		/**
		 * @private
		 */
		
		private function hoverHandler( evt:MouseEvent ):void
		{
			switch ( evt.type )
			{
				case MouseEvent.MOUSE_OVER:
					this.content.gotoAndStop(2);
					break;
					
				case MouseEvent.MOUSE_OUT:
					this.content.gotoAndStop(1);
					break;
			}
		}
		
		/**
		 * All listeners on this button are terminated, the button returns to it's initial pre-init state and can not be interacted with
		 */
		
		public function kill():void
		{
			this.content.gotoAndStop(1);
			this.removeHandler();
		}
		
		/**
		 * Reinstates the button as operative if a call to 'kill()' has been previously made.
		 */
		
		public function revive():void
		{
			if ( !this.hasEventListener(MouseEvent.MOUSE_DOWN) )
			{
				this.addListeners();
			}
		}
		
		/**
		 * @private	Removes listeners from memory upon the removal of this button from the stage
		 */
		
		private function removeHandler( evt:Event = null ):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, this.clickHandler );
			this.removeEventListener( MouseEvent.MOUSE_UP, this.clickHandler );
			this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.clickHandler );
			this.removeEventListener( MouseEvent.MOUSE_OVER, this.hoverHandler );
			this.removeEventListener( MouseEvent.MOUSE_OUT, this.hoverHandler );
			
		}
		
		/**
		 * Retrieves if the button is currently disabled
		 */
		
		public function get disabled():Boolean 
		{
			return _disabled;
		}
		
		public function getContent():MovieClip
		{
			return this.content;
		}
		
	}

}