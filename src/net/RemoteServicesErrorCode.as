package net 
{
	import com.thirdsense.utils.StringTools;
	/**
	 * ...
	 * @author ...
	 */
	public class RemoteServicesErrorCode 
	{
		public static const ERROR_UNKNOWN:int = -101;
		public static const ERROR_REQUEST_TIMEOUT:int = -103;
		public static const ERROR_IO:int = -104;
		public static const ERROR_SECURITY:int = -105;
		public static const ERROR_CHECKSUM_FAILED:int = -106;
		
		public static const SUCCESS:int = 0;
		public static const ERROR_GENERAL:int = 1;
		public static const ERROR_MALFORMED_JSON:int = 2;
		public static const ERROR_MISSING_FIELD:int = 3;
		public static const ERROR_FIELD_EMPTY:int = 4;
		public static const ERROR_SAVING_DATA:int = 5;
		public static const ERROR_CODE_NOT_VALID:int = 6;
		public static const ERROR_MAX_DEVICES_USED:int = 7;
		public static const ERROR_INVALID_TYPE:int = 8;
		public static const ERROR_NO_DATA_FOUND:int = 9;
		public static const ERROR_INVALID_EMAIL:int = 10;
		public static const ERROR_EMAIL_USED:int = 11;
		public static const ERROR_USER_DOESNT_EXIST:int = 12;
		public static const ERROR_GAME_STATE_DOESNT_EXIST:int = 13;
		public static const ERROR_COUPON_ALREADY_USED:int = 14;
		
		  
		public static function getErrorMessage( response_packet:Object ):String
		{
			
			switch ( response_packet.code )
			{
				case ERROR_SECURITY:
					return "A security sandbox violation was detected. Please contact the service administrator. (-105)";
									
				case ERROR_CHECKSUM_FAILED:
					return "A security violation was detected. (-106)";
					
				case ERROR_REQUEST_TIMEOUT:
					return "The service request timed out. Please check your network connection and try again. (-103)";
					
				case ERROR_IO:
					return "A communications error was detected. Please check your network connection and try again. (-104)";
					
				case ERROR_UNKNOWN:
					return "An unknown error was encountered. Please contact the service administrator. (-101)";
					
				case ERROR_USER_DOESNT_EXIST:
					if ( response_packet.message == "User credentials don't exist" )
					{
						return "The email address and password don't match any existing user credentials. (" + response_packet.code + ")";
					}
					else if ( response_packet.message == "Code doesn't exist" )
					{
						return "The code you entered doesn't match any existing promotional codes. Please try a different code (" + response_packet.code + ")";
					}
					else
					{
						return "The email address that you entered was not found to be associated with any registered account. (" + response_packet.code + ")";
					}
					
				case ERROR_INVALID_EMAIL:
					return "You have entered an invalid email. Please check the spelling or register for a new account. (" + response_packet.code + ")";
					
				case ERROR_FIELD_EMPTY:
					return "One or more mandatory fields were found to be empty. Please complete all required fields. (" + response_packet.code + ")";
					
				case ERROR_EMAIL_USED:
					return "The email address you have provided is already in use with an existing account. (" + response_packet.code + ")";
					
				case ERROR_COUPON_ALREADY_USED:
					return "The code you have entered has already been verified and used. Please try a different code. (" + response_packet.code + ")";
			}
			
			var message:String = response_packet.message;
			
			if(message != null)
			message = StringTools.replaceAll( message, "\\", "" );
			else
			message = "";
			
			return "An error was encountered:\n'" + message + "' (" + response_packet.code + ")";
		}
		
	}

}