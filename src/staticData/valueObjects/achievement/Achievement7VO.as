package staticData.valueObjects.achievement 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Achievement7VO 
	{
		//coin magnet powerup
		
		//activate x slow down powerups
		public static var ID:String = "7";
		public static var NAME:String = "Steady Fall";
		public static var DESC:String = "Activate " +QUANTITY+" Slow Down Powerups";
		public static var COMPLETED:Boolean = false;
		static public const QUANTITY:int = 10;
		static public var COUNT:int = 0;
		
		public function Achievement7VO() 
		{
			
		}
		
		
		
		
	}

}