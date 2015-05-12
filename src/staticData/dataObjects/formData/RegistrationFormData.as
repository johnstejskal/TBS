package staticData.dataObjects.formData 
{
	/**
	 * ...
	 * @author 
	 */
	public class RegistrationFormData 
	{
		
		public static var firstName:String;
		public static var lastName:String;
		public static var email:String;
		public static var confirmEmail:String;
		public static var password:String;
		public static var postCode:String;
		public static var phoneNumber:String;
		public static var optIn:Boolean;
		public static var agreeTerms:Boolean;
		
		
		
		public static function reset():void
		{
			firstName = null;
			lastName = null;
			email = null;
			confirmEmail = null;
			password = null;
			postCode = null;
			phoneNumber = null;
			optIn = false;
			agreeTerms = false;	
			
		}

		
	}

}