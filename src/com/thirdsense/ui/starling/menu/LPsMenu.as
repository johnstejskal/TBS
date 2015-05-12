package com.thirdsense.ui.starling.menu 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.utils.Trig;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.filters.BlurFilter;
	
	/**
	 * The LaunchPad Starling based menu scaffold.
	 * @author Ben Leffler
	 */
	
	public class LPsMenu extends Sprite 
	{
		private static var instance:LPsMenu;
		private static var _last_menu:String;
		private static var _current_menu:String;
		private static var _menus_class_path:String;
		private static var registered_menus:Array;
		private static var _fading:Boolean;
		private static var _blurring:Boolean;
		private static var _stitch:Boolean;
		private static var _enabled3D:Boolean = false;
		private static var onTransitionStart:Function;
		private static var _transitioning:Boolean;
		private static var _transition_tween_type:String = BTween.EASE_IN_OUT;
		private static var _transition_tween_speed:int = 30;
		
		private var onComplete:Function;
		private var content:Sprite;
		
		/**
		 * Constructor of the LaunchPad Starling based menu framework
		 */
		
		public function LPsMenu() 
		{
			instance = this;
			_last_menu = "";
			_current_menu = "";
			_transitioning = false;
			
		}
		
		/**
		 * @private
		 */
		
		private function addMenu( menu_name:String = "", transition:String = "", onComplete:Function=null, allow_reload:Boolean = false ):void
		{
			if ( menu_name != _current_menu )
			{
				_last_menu = _current_menu;
				_current_menu = menu_name;
			}
			else if ( !allow_reload )
			{
				return void;
			}
			
			this.onComplete = onComplete;
			_transitioning = true;
			
			if ( this.content && transition != "" )
			{
				if ( !this.content.numChildren || !(this.content.getChildAt(0) is Sprite3D) )
				{
					this.content.flatten();
				}
				
				var pt:Point = LPMenuTransition.translate(transition);
				
				if ( _transition_tween_speed > 0 )
				{
					var tween_speed:int = _transition_tween_speed;
				}
				else if ( _stitch )
				{
					tween_speed = 30;
				}
				else
				{
					tween_speed = 15;
				}
				
				var tween:BTween = new BTween( this.content, tween_speed, _transition_tween_type, 1 );
				tween.moveTo( pt.x * Starling.current.stage.stageWidth, pt.y * Starling.current.stage.stageHeight );
				if ( _blurring )
				{
					tween.onTween = this.blurTransitionEffect;
					tween.onTweenArgs = [ tween, pt ];
				}
				else if ( _enabled3D && this.content.numChildren && this.content.getChildAt(0) is Sprite3D )
				{
					var s3d:Sprite3D = this.content.getChildAt(0) as Sprite3D;
					s3d.pivotX += Starling.current.stage.stageWidth >> 1;
					s3d.pivotY += Starling.current.stage.stageHeight >> 1;
					s3d.x += s3d.pivotX;
					s3d.y += s3d.pivotY;
					tween.onTween = this.tweenSprite3D;
					tween.onTweenArgs = [ tween ];
					
					var quad:Quad = new Quad( Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0 );
					quad.x = 0;
					quad.y = 0;
					s3d.addChild( quad );
					var qtween:BTween = new BTween( quad, tween_speed, _transition_tween_type, 1 )
					qtween.fadeFromTo(0, 1);
					qtween.start();
				}
				if ( _fading ) tween.fadeTo(0);
				if ( _stitch )
				{
					this.onMenuTransition( transition );
					tween.onComplete = this.onStitchedMenuTransitionComplete;
					tween.onCompleteArgs = [ tween ];
				}
				else
				{
					tween.onComplete = this.onMenuTransition;
					tween.onCompleteArgs = [ transition ];
				}
				tween.start();
			}
			else
			{
				this.onMenuTransition( transition );
			}
			
			if ( onTransitionStart != null )
			{
				onTransitionStart();
			}
		}
		
		private function tweenSprite3D( tween:BTween ):void 
		{
			var s3d:Sprite3D = tween.target.getChildAt(0) as Sprite3D;
			s3d.rotationY = Trig.toRadians((tween.target.x / Starling.current.stage.stageWidth) * 90)
			s3d.rotationX = Trig.toRadians((tween.target.y / Starling.current.stage.stageHeight) * -90)
		}
		
		/**
		 * @private	Handles the removal of the last menu in a stitched instance
		 */
		
		private function onStitchedMenuTransitionComplete( tween:BTween ):void
		{
			if ( tween.target.parent ) tween.target.parent.removeChild( tween.target );
		}
		
		/**
		 * @private	Provides a blur effect on the content container when transitioning a menu off screen
		 */
		
		private function blurTransitionEffect( tween:BTween, transition:Point ):void
		{
			var progress:Number = tween.progress;
			var blur:int = 15;
			if ( _fading ) blur *= 2;
			if ( _stitch ) blur /= 4;
			var filter:BlurFilter = new BlurFilter( progress * blur * Math.abs(transition.x), progress * blur * Math.abs(transition.y), 0.25 );
			tween.target.filter = filter;			
		}
		
		/**
		 * @private
		 */
		
		private function onMenuTransition( transition:String ):void
		{
			if ( this.content && (!_stitch || transition == "") )
			{
				this.content.unflatten();
				this.content.filter = null;
				this.content.removeChildren( 0, -1 );
			}
			else
			{
				this.content = new Sprite();
				this.addChild( this.content );
			}
			
			if ( _current_menu != "" )
			{
				var pt:Point = LPMenuTransition.translate(transition);
				
				if ( transition == LPMenuTransition.BOUNCE_UP || transition == LPMenuTransition.BOUNCE_DOWN )
				{
					pt.y *= -1;
				}
				else if ( transition == LPMenuTransition.BOUNCE_LEFT || transition == LPMenuTransition.BOUNCE_RIGHT )
				{
					pt.x *= -1;
				}
				
				this.content.x = pt.x * -Starling.current.stage.stageWidth;
				this.content.y = pt.y * -Starling.current.stage.stageHeight;
				
				var menu_class:String = this.getMenuPath( _current_menu );
				
				var cl:Class = getDefinitionByName( menu_class ) as Class;
				var menu:* = new cl();
				menu.x = 0;
				menu.y = 0;
				this.content.addChild( menu );
			}
			
			this.initMenu();
		}
		
		/**
		 * @private
		 */
		
		private function getMenuPath( name:String ):String
		{
			if ( !registered_menus )	return null;
			
			for ( var i:uint = 0; i < registered_menus.length; i++ )
			{
				if ( registered_menus[i].name == name )
				{
					return registered_menus[i].path + registered_menus[i].name;
				}
			}
			
			return null;
		}
		
		/**
		 * @private
		 */
		
		private function initMenu():void
		{
			if ( this.content )
			{
				if ( this.content.x != 0 || this.content.y != 0 )
				{
					//var tween_type:String = BTween.EASE_OUT;
					//if ( _stitch ) tween_type = BTween.EASE_IN_OUT;
					
					var tween:BTween = new BTween( this.content, _transition_tween_speed, _transition_tween_type, 1 );
					tween.moveTo(0, 0);
					if ( _fading ) tween.fadeFromTo(0, 1);
					tween.onComplete = this.onTransitionComplete;
					
					var s3d:Sprite3D = content.getChildAt(0) as Sprite3D;
					if ( s3d && _enabled3D )
					{
						s3d.pivotX = Starling.current.stage.stageWidth >> 1;
						s3d.pivotY = Starling.current.stage.stageHeight >> 1;
						s3d.x += s3d.pivotX;
						s3d.y += s3d.pivotY;
						tween.onTween = tweenSprite3D;
						tween.onTweenArgs = [ tween ];
						
						var quad:Quad = new Quad( Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0 );
						quad.x = 0;
						quad.y = 0;
						BTween.callOnFrame( 2, s3d.addChild, [quad] );
						var qtween:BTween = new BTween( quad, _transition_tween_speed, _transition_tween_type, 1 )
						qtween.fadeFromTo(1, 0);
						qtween.start();
						qtween.onComplete = quad.removeFromParent;
					}
					tween.start();
				}
				else
				{
					this.onTransitionComplete();
				}
			}
			
			if ( current_menu != "" )
			{
				if ( LPSettings.ANALYTICS_TRACKING_ID.length > 0 )
				{
					Analytics.trackScreen( current_menu );
				}
			}
		}
		
		/**
		 * @private
		 */
		
		private function onTransitionComplete():void
		{
			_transitioning = false;
			
			if ( this.content.numChildren )
			{
				var mm:* = this.content.getChildAt(0);
				mm.pivotX = 0;
				mm.pivotY = 0;
				mm.x = 0;
				mm.y = 0;
				
				if ( mm.onTransition != null )	mm.onTransition();
			}
			
			if ( this.onComplete != null )
			{
				var fn:Function = this.onComplete;
				this.onComplete = null;
				fn();
			}
		}
		
		/**
		 * Obtains the currently showing menu instance
		 * @return	The currently showing menu instance as a DisplayObject.
		 */
		
		public static function getCurrentMenuInstance():DisplayObject
		{
			return instance.getChildAt( instance.numChildren - 1 );
		}
		
		/**
		 * Obtains the name of the last menu that was visited
		 */
		
		public static function get last_menu():String 
		{
			return _last_menu;
		}
		
		
		/**
		 * Obtains the name of the currently showing menu
		 */
		public static function get current_menu():String 
		{
			return _current_menu;
		}
		
		/**
		 * Navigates the menu system to the designated screen
		 * @param	menu	Can be either the name of the menu class to invoke (String) or you can pass through the actual menu class.
		 * @param	transition_type	The menu transition type
		 * @param	onComplete	The callback function that is invoked upon the new menu completing it's transition in to position
		 */
		
		public static function navigateTo( menu:*, transition:String = "", onComplete:Function=null, allowReload:Boolean = false ):void
		{
			if ( menu is String )
			{
				var menu_name:String = menu;
			}
			else
			{
				var arr:Array = getQualifiedClassName(menu).split("::");
				menu_name = arr[arr.length - 1];
			}
			
			if ( !instance.getMenuPath(menu_name) )
			{
				trace( "LaunchPad", LPsMenu, "Error retrieving '" + menu_name + "' as it needs to be registered with LPsMenu.registerMenu first" );
			}
			else
			{
				instance.addMenu( menu_name, transition, onComplete, allowReload );
			}
		}
		
		/**
		 * Returns the scaleX value of the menu container.
		 */
		
		public static function get scale():Number
		{
			return instance.scaleX;
		}
		
		/**
		 * Enables or disables fading of each menu as it transitions (Your app may take a performance hit on mobile devices if it is enabled and your menus are quite busy)
		 */
		
		public static function get fading():Boolean 
		{
			return _fading;
		}
		
		/**
		 * @private
		 */
		
		public static function set fading(value:Boolean):void 
		{
			_fading = value;
		}
		
		/**
		 * Enables or disables a motion blur effect on menu transitions (There may be a performance hit on some mobile devices if enabled)
		 */
		
		public static function get blurring():Boolean 
		{
			return _blurring;
		}
		
		/**
		 * @private
		 */
		
		public static function set blurring(value:Boolean):void 
		{
			_blurring = value;
		}
		
		/**
		 * Enables or disables menu stitching for transitioning
		 */
		
		public static function get stitch():Boolean 
		{
			return _stitch;
		}
		
		/**
		 * @private
		 */
		
		public static function set stitch(value:Boolean):void 
		{
			_stitch = value;
		}
		
		/**
		 * Registers a menu class for use with the LaunchPad Starling Menu system
		 * @param	menu	The menu class to be called upon via the LPsMenu.navigateTo function where the menu_name parameter is the class name as a String.
		 */
		
		public static function registerMenu( menu:Class ):void
		{
			if ( !registered_menus )
			{
				registered_menus = new Array();
			}
			
			var arr:Array = getQualifiedClassName(menu).split( "::" );
			
			for ( var i:uint = 0; i < registered_menus.length; i++ )
			{
				if ( registered_menus[i].name == arr[arr.length-1] )
				{
					trace( "LaunchPad", LPsMenu, "Error registering '" + arr[arr.length-1] + "' as this menu type already registered" );
					return void;
				}
			}
			
			if ( arr.length > 1 )
			{
				registered_menus.push( { path:arr[0] + ".", name:arr[1] } );
			}
			else
			{
				registered_menus.push( { path:"", name:arr[0] } );
			}
			
			trace( "LaunchPad", LPsMenu, arr[arr.length-1] + " successfully registered as a menu" );
		}
		
		/**
		 * Retrieves an array of menu names that have been registered with the LPsMenu.registerMenu function
		 * @return	Array of menu names
		 */
		
		public static function getRegisteredMenuNames():Array
		{
			if ( registered_menus == null )
			{
				return null;
			}
			
			var arr:Array = new Array();			
			for ( var i:uint = 0; i < registered_menus.length; i++ )
			{
				arr.push( registered_menus[i].name );
			}
			
			return arr;
		}
		
		public static function reloadCurrentMenu():void
		{
			navigateTo( current_menu, LPMenuTransition.NONE, null, true );
		}
		
		/**
		 * Sets a call back function when a menu transition is detected
		 * @param	fn	The function to call when a menu transitions
		 */
		
		public static function set callOnTransitionStart( fn:Function ):void
		{
			onTransitionStart = fn;
		}
		
		/**
		 * Retrieves if the menu system is currently in the act of transitioning
		 */
		
		static public function get transitioning():Boolean 
		{
			return _transitioning;
		}
		
		/**
		 * The number of frames to transition tween between menus over
		 */
		
		static public function get transition_tween_speed():int { return _transition_tween_speed };		
		static public function set transition_tween_speed(value:int):void 
		{
			_transition_tween_speed = value;
		}
		
		/**
		 * The type of tween to apply to the menu transition
		 */
		
		static public function get transition_tween_type():String { return _transition_tween_type };		
		static public function set transition_tween_type(value:String):void 
		{
			_transition_tween_type = value;
		}
		
		static public function get enabled3D():Boolean { return _enabled3D };		
		static public function set enabled3D(value:Boolean):void 
		{
			_enabled3D = value;
		}
	}

}