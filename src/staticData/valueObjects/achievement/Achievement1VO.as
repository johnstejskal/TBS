package staticData.valueObjects.achievement 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Achievement1VO 
	{
		

		public static var ID:String = "1";
		public static var NAME:String = "Penny pincher";
		public static var DESC:String = "collect " +QUANTITY+" coins";
		public static var COMPLETED:Boolean = false;
		static public const QUANTITY:int = 10;
		
		
		public function Achievement1VO() 
		{
			
		}
		
		
		
		
	}

}