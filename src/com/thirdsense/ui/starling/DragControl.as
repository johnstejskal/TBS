package com.thirdsense.ui.starling 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.utils.Trig;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * A class that enables object drag and drop for Starling projects
	 * @author Ben Leffler
	 */
	
	public class DragControl 
	{
		private var target:DisplayObject;
		private var onTouch:Function;
		private var offset:Point;
		private var dx:Number;
		private var dy:Number;
		private var vx:Number;
		private var vy:Number;
		private var mx:Number;
		private var my:Number;
		private var ox:Number;
		private var oy:Number;
		private var speed:Number;
		private var _disabled:Boolean;
		private var _momentum:Number;
		private var last_pos:Point;
		private var _anchors:Vector.<DisplayObject>
		private var _dragging:Boolean;
		private var triggeredAt:Number;
		public var onMove:Function;
		
		/**
		 * Constructor class for the DragControl
		 */
		
		public function DragControl() 
		{
			this._disabled = false;
			this._momentum = 0;
			this._dragging = false;
		}
		
		/**
		 * Disables the drag functionality until enable is called
		 */
		
		public function disable():void
		{
			this._disabled = true;
		}
		
		/**
		 * Enables the drag functionality. A DragControl object is enabled by default
		 */
		
		public function enable():void
		{
			this._disabled = false;
		}
		
		/**
		 * Defines the decay of momentum of the draggable object after the user has released the drag. 0 = no momentum.
		 * @default	0
		 */
		
		public function get momentum():Number
		{
			return this._momentum;
		}
		
		/**
		 * @private
		 */
		
		public function set momentum( value:Number )
		{
			this._momentum = Math.max( value, 0 );
			this._momentum = Math.min( this._momentum, 1 );
		}
		
		/**
		 * Anchors multiple display objects to the draggable object's x/y co-ords
		 */
		
		public function get anchors():Array
		{
			if ( !this._anchors ) return null;
			
			var arr:Array = new Array();
			var len:int = this._anchors.length;
			for ( var i:uint = 0; i < len; i++ )
			{
				arr.push( this._anchors[i] );
			}
			
			return arr;
		}
		
		/**
		 * @private
		 */
		
		public function set anchors( value:Array )
		{
			this._anchors = new Vector.<DisplayObject>;
			for ( var i:uint = 0; i < value.length; i++ )
			{
				this._anchors.push( value[i] );
			}
		}
		
		
		
		/**
		 * Initialises the drag control object to start working with a desired Starling DisplayObject
		 * @param	target	The target DisplayObject to attach the DragControl object functionality to
		 * @param	speed	The speed of the drag. The higher this number, the slower the speed. For 1:1 dragging, pass this as 1.
		 * @param	onTouch	The function that is called whenever a TouchPhase.BEGAN, TouchPhase.MOVED, or TouchPhase.ENDED phase is detected on the object. The function must accept a Touch object as a param.
		 * @see	starling.events.TouchPhase
		 * @see	starling.events.Touch;
		 */
		
		public function init( target:DisplayObject, speed:Number = 5, onTouch:Function = null, triggeredAt:Number = 10 ):void
		{
			this.triggeredAt = triggeredAt;
			this.target = target;
			this.onTouch = onTouch;
			this.speed = Math.max(speed, 1);
			
			this.target.addEventListener(TouchEvent.TOUCH, this.touchHandler);
			this.target.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
			this.target.addEventListener(EnterFrameEvent.ENTER_FRAME, this.timeline);
		}
		
		private function timeline(e:EnterFrameEvent):void 
		{
			if ( this.offset )
			{
				if ( this._dragging || (!this._dragging && Math.sqrt(((dx - ox) * (dx - ox)) + ((dy - oy) * (dy - oy))) > triggeredAt) )
				{
					this._dragging = true;
					this.vx = (this.dx - this.target.x) / this.speed;
					this.vy = (this.dy - this.target.y) / this.speed;
					this.target.x += this.vx;
					this.target.y += this.vy;
					this.controlAnchors();
				}
			}
		}
		
		/**
		 * @private	When the target object is removed from stage, the DragControl removes associated listeners
		 */
		
		private function removeHandler(e:Event):void 
		{
			this.target.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			this.target.removeEventListener(TouchEvent.TOUCH, this.touchHandler);
			this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
			this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.timeline);
		}
		
		/**
		 * Kills the drag control listeners
		 */
		
		public function kill():void
		{
			this.removeHandler(null);
		}
		
		/**
		 * @private	Handler for TouchEvents on the target object
		 */
		
		private function touchHandler(evt:TouchEvent):void
		{
			if ( this._disabled ) return void;
			
			var touch:Touch = evt.getTouch(this.target);
			
			if ( touch )
			{
				switch ( touch.phase )
				{
					case TouchPhase.BEGAN:
						if ( this.momentum )
						{
							// this.target.addEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
						}
						this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
						this.target.addEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
						this.offset = touch.getLocation(this.target.parent);
						this.offset.x -= this.target.x;
						this.offset.y -= this.target.y;
						this.ox = this.target.x;
						this.oy = this.target.y;
						this.dx = touch.getLocation(this.target.parent).x - this.offset.x;
						this.dy = touch.getLocation(this.target.parent).y - this.offset.y;
						this.vx = 0;
						this.vy = 0;
						this.last_pos = new Point( this.target.x, this.target.y );
						break;
						
					case TouchPhase.ENDED:
						this.offset = null;
						
						this.vx = 0;
						this.vy = 0;
						BTween.callOnNextFrame( function() { _dragging = false } );
						break;
						
					case TouchPhase.MOVED:
						if ( this.offset )
						{
							this.dx = touch.getLocation(this.target.parent).x - this.offset.x;
							this.dy = touch.getLocation(this.target.parent).y - this.offset.y;
							
							/*if ( !this._dragging && Trig.findDistance(new Point(ox, oy), new Point(this.target.x, this.target.y)) > triggeredAt )
							{
								this._dragging = true;
							}*/
							
						}
						break;
						
					default:
						return void;
				}
				
				if ( this.onTouch != null ) this.onTouch(touch);
			}
		}
		
		public function get velocity():Point { return new Point(mx, my) };
		
		/**
		 * Retrieves if a drag is currently taking place
		 */
		public function get dragging():Boolean { return this._dragging };
		
		/**
		 * Indicated if the Drag Control is currently disabled
		 */
		public function get disabled():Boolean { return _disabled };
		
		private function controlAnchors():void
		{
			if ( !this._anchors ) return void;
			
			var len:int = this._anchors.length;			
			for ( var i:uint = 0; i < len; i++ )
			{
				if ( this.offset )
				{
					this._anchors[i].x += this.vx;
					this._anchors[i].y += this.vy;
				}
				else
				{
					this._anchors[i].x += this.mx;
					this._anchors[i].y += this.my;
				}
			}
		}
		
		private function momentumHandler(e:EnterFrameEvent):void 
		{
			if ( !this.target.stage )
			{
				this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
				return void;
			}
			
			if ( !this.offset )
			{
				if ( Math.abs(this.mx) < 0.1 && Math.abs(this.my) < 0.1 )
				{
					this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.momentumHandler);
					return void;
				}
				
				this.target.x += this.mx;
				this.target.y += this.my;
				this.controlAnchors();
				this.mx *= this.momentum;
				this.my *= this.momentum;
			}
			else
			{
				this.mx = (this.target.x - this.last_pos.x);
				this.my = (this.target.y - this.last_pos.y);
				
				this.last_pos.x = this.target.x;
				this.last_pos.y = this.target.y;
			}
			
			if ( this.onMove != null )
			{
				if ( !this.onMove.length )
				{
					this.onMove();
				}
				else if ( this.onMove.length == 1 )
				{
					this.onMove( new Point(mx, my) );
				}
				else if ( this.onMove.length == 2 )
				{
					this.onMove( mx, my );
				}
			}
		}
		
		public function stopMomentum(x_momentum:Boolean = true, y_momentum:Boolean = true ):void
		{
			if ( x_momentum ) 
			{
				this.mx = 0;
				this.last_pos.x = this.target.x;
			}
			
			if ( y_momentum )
			{
				this.my = 0;
				this.last_pos.y = this.target.y;
			}
			
			if ( x_momentum && y_momentum )
			{
				this.offset = null;
			}
		}
		
	}

}