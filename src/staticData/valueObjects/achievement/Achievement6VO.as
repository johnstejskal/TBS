package staticData.valueObjects.achievement 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Achievement6VO  
	{
		//coin magnet powerup
		
		//activate x coin magnets
		public static var ID:String = "6";
		public static var NAME:String = "Magnet Man";
		public static var DESC:String = "Activate " +QUANTITY+" Coin Magnet Powerups";
		public static var COMPLETED:Boolean = false;
		static public const QUANTITY:int = 2;
		static public var COUNT:int = 0;
		
		public function Achievement6VO() 
		{
			
		}
		
		
		
		
	}

}