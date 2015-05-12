package com.thirdsense.ui.starling.menu 
{
	import flash.geom.Point;
	
	/**
	 * Transition types for the LaunchPad menu system
	 * @author Ben Leffler
	 */
	
	public class LPMenuTransition 
	{
		/**
		 * Causes a menu to transition from right to left
		 */
		public static const TO_LEFT:String = "L";
		
		/**
		 * Causes a menu to transition from left to right
		 */
		public static const TO_RIGHT:String = "R";
		
		/**
		 * Causes a menu to transition from left to right
		 */
		public static const FROM_LEFT:String = "R";
		
		/**
		 * Causes a menu to transition from right to left
		 */
		public static const FROM_RIGHT:String = "L";
		
		/**
		 * Causes a menu to immediately appear with no transition
		 */
		public static const NONE:String = "";
		
		/**
		 * Causes a menu to transition in an upward direction
		 */
		public static const UP:String = "T";
		
		/**
		 * Causes a menu to transition in a downward direction
		 */
		public static const DOWN:String = "B";
		
		/**
		 * Causes a menu to transition downward then the new menu transitions back up
		 */
		public static const BOUNCE_DOWN:String = "B_T";
		
		/**
		 * Causes a menu to transition upward then the new menu transitions back down
		 */
		public static const BOUNCE_UP:String = "T_B";
		
		/**
		 * Causes a menu to transition left then the new menu transitions back right
		 */
		public static const BOUNCE_LEFT:String = "L_R";
		
		/**
		 * Causes a menu to transition right then the new menu transitions back left
		 */
		public static const BOUNCE_RIGHT:String = "R_L";
		
		public function LPMenuTransition() 
		{
			
		}
		
		/**
		 * Causes a menu to transition in a random direction
		 */
		
		public static function get RANDOM():String
		{
			var arr:Array = [ "L", "R", "T", "B", "B_T", "T_B", "L_R", "R_L" ];
			return arr[ Math.floor(Math.random() * arr.length) ];
		}
		
		/**
		 * @private	Translates a transition in to a point co-ordinate for use with the tweening engine
		 */
		
		public static function translate( transition:String ):Point
		{
			var pt:Point = new Point();
			
			switch ( transition )
			{
				case TO_LEFT:
				case FROM_RIGHT:
				case BOUNCE_LEFT:
					pt.x = -1;
					pt.y = 0;
					break;
					
				case TO_RIGHT:
				case FROM_LEFT:
				case BOUNCE_RIGHT:
					pt.x = 1;
					pt.y = 0;
					break;
					
				case NONE:
					pt.x = 0;
					pt.y = 0;
					break;
					
				case UP:
				case BOUNCE_UP:
					pt.x = 0;
					pt.y = -1;
					break;
					
				case DOWN:
				case BOUNCE_DOWN:
					pt.x = 0;
					pt.y = 1;
					break;
			}
			
			return pt;
		}
		
	}

}