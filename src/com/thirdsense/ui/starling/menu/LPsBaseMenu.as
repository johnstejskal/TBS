package com.thirdsense.ui.starling.menu 
{
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.controllers.MobilityControl;
	import com.thirdsense.settings.Profiles;
	import flash.utils.getQualifiedClassName;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	
	/**
	 * Base class for use with the LaunchPad Starling based menu system
	 * @author Ben Leffler
	 */
	
	public class LPsBaseMenu extends Sprite3D 
	{
		private var _section:String;
		
		/**
		 * Function that gets called once this menu has finished tweening in to position
		 */
		public var onTransition:Function;
		
		/**
		 * Constructor for the base menu class. All menus using the LaunchPad Starling menu system should extend this class and call super()
		 * @param	onTransitionIn	The function that gets called once the menu has completed it's transition in to view
		 * @param	onBackButton	On Android devices, when the back button is pressed, this function is called
		 */
		
		public function LPsBaseMenu( onTransitionIn:Function=null, onBackButton:Function=null ) 
		{
			var arr:Array = getQualifiedClassName(this).split("::");
			this._section = arr[arr.length - 1];
			
			this.onTransition = onTransitionIn;
			
			if ( Profiles.mobile ) MobilityControl.initBackButton( onBackButton );
			
			this.addEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
		}
		
		/**
		 * The name of this menu (usually this will echo the name of the class)
		 */
		
		public function get section():String 
		{
			return _section;
		}
		
		/**
		 * When this menu is removed from the stage, this handler is called. Available for override if you want a custom removal or wish to retain TexturePack assets for this menu instance.
		 * @param	evt	The event that gets fired when removed from the starling stage.
		 * @see	starling.events.Event
		 */
		
		private function removeHandler( evt:Event ):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
			this.onMenuRemove();
		}
		
		/**
		 * Function that gets called upon this menu instance being removed from the stage. This function essentially deletes any TexturePack data that was created using a pool value equivalent
		 * to the value retrieved by calling 'this.section'
		 */
		
		public function onMenuRemove():void
		{
			TexturePack.deleteTexturePack( this.section );
		}
		
		/**
		 * Returns the stage width of the Starling viewport
		 */
		
		public function get stage_width():Number
		{
			return Starling.current.stage.stageWidth / LPsMenu.scale;
		}
		
		/**
		 * Returns the stage height of the Starling viewport
		 */
		
		public function get stage_height():Number
		{
			return Starling.current.stage.stageHeight / LPsMenu.scale;
		}
		
		/**
		 * Retrieves a TexturePack object designated by it's sequence. (The pool name will be consistent with this menu's section name)
		 * @param	sequence	The sequence name of the TexturePack to retrieve
		 * @return	The desired TexturePack object. If one does not exist, null will be returned.
		 */
		
		public final function getTexturePack( sequence:String ):TexturePack
		{
			return TexturePack.getTexturePack( this.section, sequence );
		}
		
		/**
		 * Navigates to the last detected menu section
		 * @param	transition	The type of transition to use. By default, it uses LPMenuTransition.TO_RIGHT
		 * @see	com.thirdsense.ui.starling.menu.LPMenuTransition
		 */
		
		public function navToPreviousMenu( transition:String = "R" ):void
		{
			LPsMenu.navigateTo( LPsMenu.last_menu, transition );
		}
		
	}

}