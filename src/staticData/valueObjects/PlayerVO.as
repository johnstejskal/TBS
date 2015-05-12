package staticData.valueObjects 
{
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PlayerVO extends ValueObject 
	{
		
		public var device_type:String;
		public var firstName:String;
		public var lastName:String;
		public var facebook_id:String;
		public var email:String;
		public var password:String;
		public var marketing_opt_in:Boolean;
		public var agree_tc:Boolean;
		public var player_id:String;
		public var phone:String;
		public var postcode:String;
		
		public function PlayerVO() 
		{
			
		}
		
	}

}