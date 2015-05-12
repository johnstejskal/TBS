package com.thirdsense.ui.display.menu 
{
	import com.thirdsense.controllers.MobilityControl;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.Profiles;
	import flash.utils.getQualifiedClassName;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Base class for use with the LaunchPad classic display list menu system
	 * @author Ben Leffler
	 */
	
	public class LPBaseMenu extends Sprite 
	{
		private var _section:String;
		
		/**
		 * Function that gets called once this menu has finished tweening in to position
		 */
		public var onTransition:Function;
		
		/**
		 * Constructor for the base menu class. All menus using the LaunchPad classic display list menu system should extend this class and call super()
		 * @param	onTransitionIn	The function that gets called once the menu has completed it's transition in to view
		 */
		
		public function LPBaseMenu( onTransitionIn:Function=null ) 
		{
			var arr:Array = getQualifiedClassName(this).split("::");
			this._section = arr[arr.length - 1];
			
			this.onTransition = onTransitionIn;
			
			this.addEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler, false, 0, true );
		}
		
		/**
		 * The name of this menu (usually this will echo the name of the class)
		 */
		
		public function get section():String 
		{
			return _section;
		}
		
		/**
		 * When this menu is removed from the stage, this handler is called. Available for override if you want a custom removal for this menu instance.
		 * @param	evt	The event that gets fired when removed from the stage.
		 * @see	flash.events.Event
		 */
		
		private function removeHandler( evt:Event ):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
			this.onMenuRemove();
		}
		
		/**
		 * Function that gets called upon this menu instance being removed from the stage. This function is empty in the classic display list variant of the LaunchPad menu framework
		 * but it's structure has been retained for the purpose of mirroring the Starling variant of this class.
		 */
		
		public function onMenuRemove():void
		{
			//
		}
		
		/**
		 * Returns the stage width of the stage
		 */
		
		public function get stage_width():Number
		{
			return LaunchPad.instance.nativeStage.stageWidth;
		}
		
		/**
		 * Returns the stage height of the stage
		 */
		
		public function get stage_height():Number
		{
			return LaunchPad.instance.nativeStage.stageHeight;
		}
		
		/**
		 * Navigates to the last detected menu section
		 * @param	transition	The type of transition to use. By default, it uses LPMenuTransition.TO_RIGHT
		 * @see	com.thirdsense.ui.starling.menu.LPMenuTransition
		 */
		
		public function navToPreviousMenu( transition:String = "R" ):void
		{
			LPMenu.navigateTo( LPMenu.last_menu, transition );
		}
		
	}

}