package staticData.valueObjects.achievement 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Achievement3VO 
	{
		
		public static var ID:String = "3";
		public static var NAME:String = "coin man";
		public static var DESC:String = "collect " +QUANTITY+" coins";
		public static var COMPLETED:Boolean = false;
		static public const QUANTITY:int = 5000;
		
		public function Achievement3VO() 
		{
			
		}
		
		
		
		
	}

}