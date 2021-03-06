package com.thirdsense.ui.starling 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * A combined scroll and swipe ui control class. Can be used for either scrolling or swiping or hybrid control.
	 * @author Ben Leffler
	 */
	
	public class SwipeScrollControl 
	{
		public static const SWIPE_CONTROL_TYPE:String = "swipeControlType";
		public static const SCROLL_CONTROL_TYPE:String = "scrollControlType";
		public static const SWIPE_SCROLL_CONTROL_TYPE:String = "swipeScrollControlType";
		
		private const SCROLL:int = 1;
		private const SWIPE:int = -1;
		
		private var _enabled:Boolean;
		private var _pixel_sensitivity:Number = 1;
		private var _pixel_trigger:Number = 10;
		private var _restrict_tap_area:Boolean = true;
		private var _restrict_swipe_direction:int = 0;
		private var _tap_area:Rectangle = null;
		private var _swipe_end_trigger:Number = 0.5;
		
		private var target:DisplayObject;
		private var viewPort:Rectangle;
		private var offset:Point;
		private var touch_location:Point;
		private var destination:Point;
		private var velocity:Point;
		private var momentum:Point;
		private var _touching:Boolean;
		private var gesture_type:int;
		private var bounds:Rectangle;
		private var momentum_multiplier:Number;
		private var initial_pos:Point;
		private var local_mute:Boolean;
		private var _type:String;
		
		public var onSwipe:Function;
		public var onSwiping:Function;
		public var onSwipeRelease:Function;
		public var onScroll:Function;
		public var onScrollRelease:Function;
		
		/**
		 * Constructor class
		 * @param	pixel_sensitivity	Controls the lag of the element when scrolling/swiping. Must be a value between 0.01 and 1. (1 equates to 1:1 movement)
		 * @param	pixel_trigger	The number of pixels the target element must move before the controller takes over movement and orientation
		 * @param	type	The type of control to be used. Can be swipe, scroll or a hybrid (use SwipeScrollControl static constants for this field)
		 */
		
		public function SwipeScrollControl( pixel_sensitivity:Number = 1, pixel_trigger:Number = 10, type:String = "swipeScrollControlType" ) 
		{
			this._type = type;
			this.pixel_sensitivity = pixel_sensitivity;
			this.pixel_trigger = pixel_trigger;
		}
		
		/**
		 * Returns if the controller is currently enabled or disabled.
		 */
		public function get enabled():Boolean { return _enabled };
		
		/**
		 * Sets the smoothness of the lag when controlling the element. Must be a value between 0.01 and 1 (1 equates to 1:1 ratio movement)
		 */
		public function get pixel_sensitivity():Number {  return _pixel_sensitivity };		
		public function set pixel_sensitivity(value:Number):void 
		{
			_pixel_sensitivity = Math.max(value, Math.min(0.01, 1));
		}
		
		/**
		 * The number of pixels a gesture must move before the controller assumes control of the target element.
		 */
		public function get pixel_trigger():Number { return _pixel_trigger };
		public function set pixel_trigger(value:Number):void 
		{
			_pixel_trigger = Math.max(value, 0);
		}
		
		/**
		 * Sets if the element can only be interacted within the bounds of the viewport. (Defaults to true)
		 */
		public function get restrict_tap_area():Boolean { return _restrict_tap_area };		
		public function set restrict_tap_area(value:Boolean):void 
		{
			_restrict_tap_area = value;
		}
		
		/**
		 * Indicates if the controller is currently in the act of scrolling
		 */
		public function get scrolling():Boolean { return (gesture_type == SCROLL) };
		
		/**
		 * Indicates if the controller is currently in the act of swiping
		 */
		public function get swiping():Boolean { return (gesture_type == SWIPE) };
		
		/**
		 * Indicates if the controller is currently being interacted with by the user
		 */
		public function get triggered():Boolean { return (gesture_type != 0) };
		
		/**
		 * Returns the controller type as set in the constructor.
		 */
		public function get type():String { return _type };
		
		/**
		 * Indicates if the user is currently touching the scroll container
		 */
		public function get touching():Boolean { return _touching };
		
		/**
		 * Sets if the swipe gesture is restricted to a specific direction.
		 */
		public function get restrict_swipe_direction():int { return _restrict_swipe_direction };		
		public function set restrict_swipe_direction( value:int ):void 
		{
			if ( value < 0 ) value = -1;
			else if ( value > 0 ) value = 1;
			else value = 0;
			
			_restrict_swipe_direction = value;
		}
		
		/**
		 * The area relative to the target's parent that will accept user swipe/scroll interaction. This only applies when
		 * restrict_tap_area is true.
		 */
		public function get tap_area():Rectangle { return _tap_area };
		public function set tap_area(value:Rectangle):void 
		{
			_tap_area = value;
		}
		
		/**
		 * Percentage of the viewport width that the swipe content is allowed to be moved by the user before onSwipe is triggered.
		 * Default is 0.5 (onSwipe is triggered when left/right bounds position is < 0.25 || > 0.75 of viewport)
		 */
		public function get swipe_end_trigger():Number { return _swipe_end_trigger };		
		public function set swipe_end_trigger(value:Number):void 
		{
			_swipe_end_trigger = Math.max( 0.01, value );
		}
		
		/**
		 * Sets the controller to be enabled.
		 */
		public function enable():void
		{
			_enabled = true;
		}
		
		/**
		 * Sets the controller to be disabled.
		 */
		public function disable():void
		{
			_enabled = false;
			local_mute = true;
		}
		
		/**
		 * Called to initialise and start the controller.
		 * @param	target	The Starling display object that will be the target of the control.
		 * @param	viewPort	A rectangle that states the bounds of the object movement (co-ordinates relative to the target's parent)
		 */
		public function init( target:DisplayObject, viewPort:Rectangle ):void
		{
			this._enabled = true;
			this.viewPort = viewPort;
			this.target = target;
			this.touch_location = new Point(target.x, target.y);
			this.offset = new Point(0, 0);
			this.velocity = new Point(0, 0);
			this.momentum = new Point(0, 0);
			this.destination = new Point(target.x, target.y);
			this._touching = false;
			this.gesture_type = 0;
			this.momentum_multiplier = 1;
			this.initial_pos = new Point(target.x, target.y);
			this.local_mute = false;
			
			if ( !target.stage )
			{
				trace( "LaunchPad - SwipeScrollControl :: Error. The target must be on the stage before calling to init" );
				return void;
			}
			
			this.target.stage.addEventListener(TouchEvent.TOUCH, this.touchHandler);
			this.target.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
			this.target.addEventListener(EnterFrameEvent.ENTER_FRAME, this.enterFrameHandler);
			
			this.bounds = target.getBounds(target.parent);
			
		}
		
		public function reInitialize():void
		{
			this.target.stage.removeEventListener(TouchEvent.TOUCH, this.touchHandler);
			this.target.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
			this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.enterFrameHandler);
			
			this.target.stage.addEventListener(TouchEvent.TOUCH, this.touchHandler);
			this.target.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
			this.target.addEventListener(EnterFrameEvent.ENTER_FRAME, this.enterFrameHandler);
		}
		
		/**
		 * @private	
		 */
		
		private function touchHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch( this.target.stage );
			if ( touch )
			{
				switch ( touch.phase )
				{
					case TouchPhase.BEGAN:
						if ( _enabled )
						{
							touch.getLocation( this.target.parent, offset );
							if ( restrict_tap_area && ((!_tap_area && !viewPort.containsPoint(offset)) || (_tap_area && !tap_area.containsPoint(offset))) )
							{
								offset.x = 0;
								offset.y = 0;
								return void;
							}
							offset.x -= target.x;
							offset.y -= target.y;
							velocity.x = 0;
							velocity.y = 0;
							momentum.x = 0;
							momentum.y = 0;
							this._touching = true;
							this.gesture_type = 0;
							this.local_mute = false;
						}
						break;
						
					case TouchPhase.ENDED:
						momentum.x = velocity.x * 4;
						momentum.y = velocity.y;
						velocity.x = 0;
						velocity.y = 0;
						offset.x = 0;
						offset.y = 0;
						destination.x = initial_pos.x;
						this._touching = false;
						momentum_multiplier = 0.99;
						if ( this.gesture_type == SCROLL && this.onScrollRelease != null )
						{
							this.onScrollRelease();
						}
						else if ( this.gesture_type == SWIPE && this.onSwipeRelease != null )
						{
							this.onSwipeRelease();
						}
						break;
						
					case TouchPhase.MOVED:
						if ( _enabled )
						{
							touch.getLocation( this.target.parent, touch_location );
							var dx:Number = touch_location.x - offset.x;
							var dy:Number = touch_location.y - offset.y;
							if ( !_restrict_swipe_direction || (_restrict_swipe_direction > 0 && dx < initial_pos.x) || (_restrict_swipe_direction < 0 && dx > initial_pos.x) )
							{
								destination.x = dx;
							}
							else
							{
								destination.x = target.x;
							}
							
							if ( target.height > viewPort.height || dy > initial_pos.y )
							{
								destination.y = dy;
							}
							else
							{
								destination.y = target.y;
							}
							
							this.controlGestureType();
						}
						break;
						
					default:
						break;
				}
			}
		}
		
		/**
		 * @private	Checks if scrolling is enabled as set by the type argument in the constructor
		 */
		
		private function isScrollEnabled():Boolean
		{
			return ( _type == SwipeScrollControl.SCROLL_CONTROL_TYPE || _type == SwipeScrollControl.SWIPE_SCROLL_CONTROL_TYPE );
		}
		
		/**
		 * @private	Checks if swiping is enabled as set by the type argument in the constructor
		 */
		
		private function isSwipeEnabled():Boolean
		{
			return ( _type == SwipeScrollControl.SWIPE_CONTROL_TYPE || _type == SwipeScrollControl.SWIPE_SCROLL_CONTROL_TYPE );
		}
		
		/**
		 * @private	Trigger control once an interaction has passed the pixel trigger threshold and assigns it's movement type
		 */
		
		private function controlGestureType():void
		{
			if ( !gesture_type )
			{
				if ( Math.abs(destination.x - target.x) > _pixel_trigger && isSwipeEnabled() ) gesture_type = SWIPE;
				else if ( Math.abs(destination.y - target.y) > _pixel_trigger && isScrollEnabled() ) gesture_type = SCROLL;
			}
		}
		
		/**
		 * @private
		 */
		
		private function enterFrameHandler(e:EnterFrameEvent):void 
		{
			if ( this._touching )
			{
				controlVelocity();
			}
			else
			{
				controlMomentum();
			}
			
			if ( _enabled )
			{
				moveTarget();
			}
			else
			{
				this.momentum.x = this.momentum.y = 0;
				this.velocity.x = this.velocity.y = 0;
			}
		}
		
		/**
		 * @private
		 */
		
		private function controlVelocity():void 
		{
			velocity.x = (destination.x - target.x) * _pixel_sensitivity;
			velocity.y = (destination.y - target.y) * _pixel_sensitivity;
		}
		
		/**
		 * @private
		 */
		
		private function controlMomentum():void 
		{
			if ( this.momentum.x || this.momentum.y )
			{
				this.momentum.x *= momentum_multiplier;
				this.momentum.y *= momentum_multiplier;
				
				if ( Math.abs(this.momentum.x) < 0.1 ) this.momentum.x = 0;
				if ( Math.abs(this.momentum.y) < 0.1 ) this.momentum.y = 0;
			}
		}
		
		/**
		 * @private
		 */
		
		private function moveTarget():void
		{
			target.getBounds(target.parent, bounds);
			
			if ( this.gesture_type )
			{
				if ( gesture_type == SWIPE )
				{
					this.target.x += this.velocity.x + momentum.x;					
					momentum_multiplier = 0.9;
					
					if ( this.onSwiping != null )
					{
						this.onSwiping();
					}
				}
				
				if ( gesture_type == SCROLL )
				{
					this.target.y += this.velocity.y + momentum.y;
					
					if ( bounds.y > viewPort.y )
					{
						target.y -= (bounds.y - viewPort.y);
						momentum_multiplier = 0.65;
					}
					else if ( bounds.y + bounds.height < viewPort.y + viewPort.height && bounds.height > viewPort.height )
					{
						target.y -= ( (bounds.y + bounds.height) - (viewPort.y + viewPort.height) );
						momentum_multiplier = 0.65;
					}
					else
					{
						if ( _touching )
						{
							momentum_multiplier = 0.95;
						}
						else
						{
							momentum_multiplier *= 0.999;
						}
					}
					
					if ( this.onScroll != null )
					{
						this.onScroll();
					}
				}
				
				if ( !_touching && !velocity.x && !velocity.y && !momentum.x && !momentum.y )
				{
					gesture_type = 0;
					
				}
			}
			
			if ( !this._touching )
			{
				this.target.x += (initial_pos.x - target.x) / 3;
				
				if ( Math.abs(initial_pos.x - target.x) < _pixel_trigger )
				{
					target.x = initial_pos.x;
					velocity.x = 0;
					momentum.x = 0;
				}
				
				if ( local_mute ) return void;
				
				if ( bounds.x < viewPort.x - (bounds.width * _swipe_end_trigger) )
				{
					this.triggerSwipe( -1);
				}
				else if ( bounds.x > (viewPort.x + viewPort.width) - (bounds.width * (1 - _swipe_end_trigger)) )
				{
					this.triggerSwipe( 1 );
				}
			}
		}
		
		/**
		 * @private
		 */
		
		private function triggerSwipe( dir:Number ):void 
		{
			this.momentum.x = 0;
			this.velocity.x = 0;
			
			this.local_mute = true;
			
			if ( this.onSwipe != null )
			{
				this.onSwipe( dir );
			}
		}
		
		
		/**
		 * @private
		 */
		
		private function removeHandler(e:Event):void 
		{
			this.target.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			this.target.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.enterFrameHandler);
			this.target.stage.removeEventListener(TouchEvent.TOUCH, this.touchHandler);
		}
		
		/**
		 * Kills the listeners associated with this element. To restart the controller, call to init is required.
		 */
		
		public function kill():void
		{
			removeHandler(null);
		}
		
	}

}