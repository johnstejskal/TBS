package com.thirdsense.ui.starling 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.ui.GenericAlert;
	import com.thirdsense.ui.GenericPrompt;
	import com.thirdsense.utils.DuplicateDisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	
	/**
	 * Static instance of the LaunchPad Starling based App UI providing access to Alert and Prompt UI elements
	 * @author Ben Leffler
	 */
	
	public class LPsAppUI extends Sprite 
	{
		private static var instance:LPsAppUI;
		private static var onComplete:Function;
		private static var onCancel:Function;
		private static var last_alert:MovieClip;
		private static var last_prompt:MovieClip;
		
		/**
		 * Adds a dark slightly transparent quad as a background to the ui element if set as true when calling a UI element to the stage
		 */
		
		public static var createQuadBackground:Boolean = true;
		
		/**
		 * Sets the tween type to use on invoking visual assets
		 */
		public static var tween_type:String = BTween.EASE_OUT;
		
		/**
		 * Sets the speed of the tween being used when invoking visual assets
		 */
		public static var tween_speed:int = 10;
		
		/**
		 * Constructor
		 */
		
		public function LPsAppUI() 
		{
			
		}
		
		/**
		 * @private	Creates a quad based background overlay
		 */
		
		private function createShapeOverlay():void
		{
			var quad:Quad = new Quad( Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0x000000 );
			quad.x = 0;
			quad.y = 0;
			this.addChild( quad );
			
			var tween:BTween = new BTween( quad, Math.round(15 * (LaunchPad.instance.nativeStage.frameRate / 60)) );
			tween.fadeFromTo( 0, 0.75 );
			tween.start();
		}
		
		/**
		 * @private	Checks if an instance of the AppUI container exists. If not, add one and ensure it is on the upper-most layer
		 * @return	Returns false if a UI element exists already on stage
		 */
		
		private static function checkInstance():Boolean
		{
			var cont:Sprite = Starling.current.root as Sprite;
			
			if ( !instance )
			{
				instance = new LPsAppUI();
				cont.addChild( instance );
			}
			else if ( hasUI() )
			{
				return false;
			}
			else if ( cont.getChildIndex(instance) < cont.numChildren - 1 )
			{
				cont.setChildIndex( instance, cont.numChildren - 1 );
			}
			
			return true;
		}
		
		/**
		 * Retrieves if a UI element exists on the stage
		 * @return
		 */
		
		public static function hasUI():Boolean
		{
			if ( instance && instance.numChildren > 0 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Removes any UI elements that are on stage
		 */
		
		public static function killUI():void
		{
			if ( hasUI() )
			{
				instance.removeChildren();
				onComplete = null;
				onCancel = null;
			}
		}
		
		/**
		 * Add a Prompt UI element to the stage. Only a single instance of a UI element may exist at any point
		 * @param	heading	Text is displayed in the heading field
		 * @param	copy	Text that is displayed in the copy field
		 * @param	element	The MovieClip to use as the prompt scaffold. If left as null, a GenericPrompt instance is created and used.
		 * @param	onComplete	The function to call when a user taps the ok_button element
		 * @param	onCancel	The function to call when a user taps the cancel_button element
		 * @return	A Boolean value that indicates if the UI element was added to the stage
		 * @see	com.thirdsense.ui.GenericPrompt
		 */
		
		public static function addPrompt( heading:String = "", copy:String = "", element:MovieClip = null, onComplete:Function = null, onCancel:Function = null ):Boolean
		{
			if ( !checkInstance() ) 
			{
				trace( "LPsAppUI :: Can not add Prompt element to the stage as a UI element already exists on stage" );
				return false;
			}
			
			if ( createQuadBackground ) instance.createShapeOverlay();
			
			if ( element )
			{
				if ( element is GenericPrompt )
				{
					last_prompt = null;
				}
				else
				{
					last_prompt = DuplicateDisplayObject.duplicate(element) as MovieClip;
				}
			}
			else if ( last_prompt )
			{
				element = DuplicateDisplayObject.duplicate(last_prompt) as MovieClip;
			}
			else
			{
				element = new GenericPrompt();
			}
			
			configElement(element, heading, copy);
			
			LPsAppUI.onComplete = onComplete;
			LPsAppUI.onCancel = onCancel;
			
			return true;
		}
		
		/**
		 * Adds an Alert UI element to the stage. Only a single instance of any UI element may exist at any point
		 * @param	heading	Text that is displayed in the heading field
		 * @param	copy	Text that is displayed in the copy field
		 * @param	element	The MovieClip to use as the prompt scaffold. If left as null, a GenericAlert instance is created and used
		 * @param	onComplete	The function to call when the user dismisses the alert
		 * @return	A Boolean value that indicates if the UI element was added to the stage
		 * @see	com.thirdsense.ui.GenericPrompt
		 */
		
		public static function addAlert( heading:String = "", copy:String = "", element:MovieClip = null, onComplete:Function = null ):Boolean
		{
			if ( !checkInstance() ) {
				trace( "LPsAppUI :: Can not add Alert element to the stage as a UI element already exists on stage" );
				return false;
			}
			
			if ( createQuadBackground ) instance.createShapeOverlay();
			
			if ( element )
			{
				if ( element is GenericAlert )
				{
					last_alert = null;
				}
				else
				{
					last_alert = DuplicateDisplayObject.duplicate(element) as MovieClip;
				}
			}
			else if ( last_alert )
			{
				element = DuplicateDisplayObject.duplicate(last_alert) as MovieClip;
			}
			else
			{
				element = new GenericAlert();
			}
			
			configElement( element, heading, copy );
			
			LPsAppUI.onComplete = onComplete;
			
			return true;
		}
		
		/**
		 * @private	Handler of user interaction
		 * @param	touch
		 */
		
		private static function clickHandler( touch:Touch ):void
		{
			var but:LPsButton = touch.target as LPsButton;
			
			if ( but.name == "ok_button" )
			{
				var fn:Function = onComplete;
			}
			
			if ( but.name == "cancel_button" )
			{
				fn = onCancel;
			}
			
			onComplete = null;
			onCancel = null;
			killUI();
			
			if ( fn != null )
			{
				fn();
			}
		}
		
		/**
		 * @private	Populates the UI element with the required copy
		 * @param	element	The MovieClip that is being used as the UI element's scaffold
		 * @param	heading	Heading text
		 * @param	copy	Copy text
		 */
		
		private static function configElement( element:MovieClip, heading:String, copy:String ):void
		{
			if ( element is GenericPrompt )
			{
				var prompt:GenericPrompt = element as GenericPrompt;
				prompt.create( heading, copy );
				
				var b1:MovieClip = prompt.ok_button;
				var b2:MovieClip = prompt.cancel_button;
				var pt1:Point = new Point(b1.x, b1.y);
				var pt2:Point = new Point(b2.x, b2.y);
				
				b1.x = 0;
				b1.y = 0;
				b2.x = 0;
				b2.y = 0;
				
				prompt.removeChild(b1);
				prompt.removeChild(b2);
				
				TexturePack.createFromMovieClip(element, "LPsAppUI", "Prompt BG");
				
				var mc:MovieClip = new MovieClip();
				mc.addChild(b1);
				TexturePack.createFromMovieClip( mc, "LPsAppUI", "Prompt OK", b1 );
				
				mc = new MovieClip();
				mc.addChild(b2);
				TexturePack.createFromMovieClip( mc, "LPsAppUI", "Prompt Cancel", b2 );
				
				var spr:Sprite = new Sprite();
				var img:Image = TexturePack.getTexturePack( "LPsAppUI", "Prompt BG" ).getImage();
				img.x = 0;
				img.y = 0;
				img.touchable = false;
				spr.addChild( img );
				
				var but1:LPsButton = new LPsButton( TexturePack.getTexturePack("LPsAppUI", "Prompt OK"), clickHandler );
				but1.x = pt1.x;
				but1.y = pt1.y;
				but1.name = "ok_button";
				spr.addChild( but1 );
				
				var but2:LPsButton = new LPsButton( TexturePack.getTexturePack("LPsAppUI", "Prompt Cancel"), clickHandler );
				but2.x = pt2.x;
				but2.y = pt2.y;
				but2.name = "cancel_button";
				spr.addChild( but2 );
				
			}
			else if ( element is GenericAlert )
			{
				var alert:GenericAlert = element as GenericAlert;
				alert.create( heading, copy );
				
				b1 = alert.ok_button;
				pt1 = new Point( b1.x, b1.y );
				b1.x = 0;
				b1.y = 0;
				alert.removeChild( b1 );
				
				TexturePack.createFromMovieClip(element, "LPsAppUI", "Alert BG");
				
				mc = new MovieClip();
				mc.addChild(b1);
				TexturePack.createFromMovieClip( mc, "LPsAppUI", "Alert OK", b1 );
				
				spr = new Sprite();
				img = TexturePack.getTexturePack( "LPsAppUI", "Alert BG" ).getImage();
				img.x = 0;
				img.y = 0;
				img.touchable = false;
				spr.addChild( img );
				
				but1 = new LPsButton( TexturePack.getTexturePack("LPsAppUI", "Alert OK"), clickHandler );
				but1.x = pt1.x;
				but1.y = pt1.y;
				but1.name = "ok_button";
				spr.addChild( but1 );
			}
			else
			{
				if ( element.heading && element.heading is TextField ) element.heading.text = heading;
				if ( element.copy && element.copy is TextField ) element.copy.text = copy;
				
				if ( element.ok_button && element.ok_button is MovieClip )
				{
					b1 = element.ok_button;
					pt1 = new Point( b1.x, b1.y );
					b1.x = 0;
					b1.y = 0;
					element.removeChild( b1 );
				}
				
				if ( element.cancel_button && element.cancel_button is MovieClip )
				{
					b2 = element.cancel_button;
					pt2 = new Point( b2.x, b2.y );
					b2.x = 0;
					b2.y = 0;
					element.removeChild( b2 );
				}
				
				TexturePack.createFromMovieClip( element, "LPsAppUI", "Element BG" );
				
				if ( b1 )
				{
					mc = new MovieClip();
					mc.addChild( b1 );
					TexturePack.createFromMovieClip( mc, "LPsAppUI", "Element OK", b1 );
				}
				
				if ( b2 )
				{
					mc = new MovieClip();
					mc.addChild( b2 )
					TexturePack.createFromMovieClip( mc, "LPsAppUI", "Element Cancel", b2 );
				}
				
				spr = new Sprite();
				img = TexturePack.getTexturePack( "LPsAppUI", "Element BG" ).getImage();
				img.x = 0;
				img.y = 0;
				img.touchable = false;
				spr.addChild( img );
				
				if ( b1 ) {
					but1 = new LPsButton( TexturePack.getTexturePack("LPsAppUI", "Element OK"), clickHandler );
					but1.x = pt1.x;
					but1.y = pt1.y;
					but1.name = "ok_button";
					spr.addChild( but1 );
				}
				
				if ( b2 )
				{
					but2 = new LPsButton( TexturePack.getTexturePack("LPsAppUI", "Element Cancel"), clickHandler );
					but2.x = pt2.x;
					but2.y = pt2.y;
					but2.name = "cancel_button";
					spr.addChild( but2 );
				}
			}
			
			spr.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			instance.addChild( spr );
			
			var bounds:Rectangle = spr.getBounds(instance);
			var pt:Point = new Point( (bounds.width / 2) - bounds.x, (bounds.height / 2) - bounds.y );
			
			spr.x = Starling.current.stage.stageWidth - spr.width >> 1;
			spr.y = Starling.current.stage.stageHeight - spr.height >> 1;
			
			var tween:BTween = new BTween( spr, Math.round(tween_speed * (LaunchPad.instance.nativeStage.frameRate / 60)), tween_type );
			tween.moveFromTo( spr.x + pt.x, spr.y + pt.y, spr.x, spr.y );
			tween.scaleFromTo( 0, 1 );
			tween.start();
			
			trace( tween_speed, tween_type );
		}
		
		/**
		 * @private	When the UI element is removed from the stage, the TexturePack's that were used are disposed of
		 * @param	evt
		 */
		
		private static function removeHandler(evt:Event):void
		{
			evt.currentTarget.removeEventListener( Event.REMOVED_FROM_STAGE, removeHandler );
			TexturePack.deleteTexturePack( "LPsAppUI" );
		}
		
	}

}