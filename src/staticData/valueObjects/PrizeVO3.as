package staticData.valueObjects 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PrizeVO3
	{
		
		public var ID:String;
		public var PRIZE_CODE:String;
		public var NAME:String;
		public var DESCRIPTION:String;
		
		public var IS_AVAILABLE:Boolean;
		public var IS_REDEEMED:Boolean; // when user swipes to start redeem
		public var IS_CLAIMED:Boolean; // when staff memember has signed off on prize
		public var IS_EXPIRED:Boolean;
			
		public var TIMESTAMP_WON:String;
		public var TIMESTAMP_EXPIRY:Object;
		public var TIMESTAMP_COUNTDOWN_EXPIRY:Object;
		

		
	}

}