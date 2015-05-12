package staticData.valueObjects 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PrizeVO extends ValueObject
	{
		public var id:String;
		public var type:String;  //type is 1 = food 2 = VC 3 = second chance
		public var prize_id:String; //1 - 7
		public var name:String;
		public var description:String;
		
		public var value:String;
		public var user_id:String;
		
		public var is_redeemed:Boolean; // when user swipes to start redeem
		public var is_claimed:Boolean; // when staff memember has signed off on prize
		public var is_expired:Boolean;
		public var is_mystery:Boolean;
		
		public var expiry:String;  // date format
		public var created:String;  // date format
		public var modified:String; // date format
		public var won:String; // date format
		public var is_available:Boolean;
		public var unique_code:String;
		

		
	}

}