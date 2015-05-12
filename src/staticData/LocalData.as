package staticData 
{
	/**
	 * ...
	 * @author 
	 */
	public class LocalData 
	{
		//----------------------------------------o
		//------ Data list 
		//----------------------------------------o		
		public static var first_name:String;
		public static var last_name:String;
		public static var email:String;
		public static var password:String;
		
		
		
		
		public static var arrMasterPrizeList:Array;
		static public var playerDataObj:String;
		static public var isNotificationViewed_suit:Boolean = false;
		static private var arrScreenNotificationsViewed:Array = [];
		
		
		static public var hasAgreedAppTerms:Boolean = false;
		

		public function LocalData() 
		{

		}
		
		static public function reset():void 
		{
			trace(LocalData + "reset()");
			playerDataObj = null
			first_name = null;
			last_name = null;
			email = null;
			password = null;
			arrScreenNotificationsViewed = [];
		}
		
	}

}