package staticData.valueObjects.achievement 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Achievement5VO 
	{
		
		public static var ID:String = "5";
		public static var NAME:String = "treasure hunter";
		public static var DESC:String = "collect " +QUANTITY+" coins";
		public static var COMPLETED:Boolean = false;
		static public const QUANTITY:int = 100000;
		
		public function Achievement5VO() 
		{
			
		}
		
		
		
		
	}

}