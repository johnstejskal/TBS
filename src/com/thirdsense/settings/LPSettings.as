package com.thirdsense.settings 
{
	import com.thirdsense.utils.NativeApplicationUtils;
	/**
	 * Global LaunchPad project settings. Most of the elements within this class are predetermined in the parsing process of the config.xml file
	 * @author Ben Leffler
	 */
	
	public class LPSettings 
	{
		/**
		 * Web extension relative to the swf delivery location of where config.xml is located
		 */
		public static var LIVE_EXTENSION:String = "";
		
		/**
		 * Google Analytics tracking id (passed through from config.xml)
		 */
		public static var ANALYTICS_TRACKING_ID:String = "";
		
		/**
		 * Application name (passed through from config.xml)
		 */
		public static var APP_NAME:String = "";
		
		
		
		/**
		 * Application is forcing mobile profile (passed through from config.xml)
		 */
		public static var FORCE_MOBILE_PROFILE:Boolean = false;
		
		/**
		 * Facebook application ID (passed through from config.xml)
		 */
		public static var FACEBOOK_APP_ID:String = "";
		
		/**
		 * Facebook redirection URL as defined in the Facebook Developer portal (passed through from config.xml)
		 */
		public static var FACEBOOK_REDIRECT_URL:String = "";
		
		/**
		 * The location of the Facebook wall picture to be used in stream posts (passed through from config.xml). This must exist within a domain that is listed in the FB Dev portal record for the app.
		 */
		public static var FACEBOOK_WALLPIC_URL:String = "";
		
		/**
		 * An array of requested permissions the app will request upon a user's first connection to Facebook through the app. (passed through from config.xml)
		 */
		public static var FACEBOOK_PERMISSIONS:Array;
		
		/**
		 * @private
		 */
		private static var _APP_VERSION:String = "";
		
		/**
		 * Application version (passed through from config.xml - if no version is found and application is mobile app, pulls the version from the descriptor xml)
		 */
		static public function get APP_VERSION():String 
		{
			if ( !Profiles.mobile )
			{
				return _APP_VERSION;
			}
			else if ( _APP_VERSION.length )
			{
				var arr1:Array = _APP_VERSION.split(".");
				var arr2:Array = NativeApplicationUtils.getAppVersion().split(".");
				for ( var i:uint = 0; i < arr1.length && i < arr2.length; i++ )
				{
					if ( Number(arr1[i]) > Number(arr2[i]) )
					{
						return _APP_VERSION;
					}
					else if ( Number(arr1[i]) < Number(arr2[i]) )
					{
						return NativeApplicationUtils.getAppVersion();
					}
				}
				
				if ( arr1.length > arr2.length )
				{
					return _APP_VERSION;
				}
				else
				{
					return NativeApplicationUtils.getAppVersion();
				}
			}
			else
			{
				return NativeApplicationUtils.getAppVersion();
			}
		}
		
		/**
		 * @private
		 */
		static public function set APP_VERSION(value:String):void 
		{
			_APP_VERSION = value;
		}
		
	}

}