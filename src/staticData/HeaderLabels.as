package staticData 
{
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class HeaderLabels 
	{
		
	 public static var APP_CLOSED_SCREEN:String  = "";
	 public static var HOME_SCREEN:String;
	 public static var ACHIEVEMENT_SCREEN:String;
	 public static var INFO_SCREEN:String;
	 public static var PRIZES_SCREEN:String;
	 public static var COMPETITION_SCREEN:String;
	 public static var SHOP_SCREEN:String;
	 public static var SHARE_SCREEN:String;
	 public static var ABOUT_SCREEN:String;
	 public static var INVITE_SCREEN:String;
	 public static var CHECK_IN_SCREEN:String;
	 
	 public static var LEADERBOARD_SCREEN:String;
	 public static var LOGIN_SCREEN:String;
	 public static var REDEEM_SCREEN:String;
	 public static var PRE_PLAY_SCREEN:String;
	 public static var PROFILE_SCREEN:String;
	 public static var FIND_A_STORE_SCREEN:String;
	 public static var SETTINGS_SCREEN:String;
	 static public var REGISTER_SCREEN:String;
				
	 public static var SLIDER_HOME:String;
	 public static var SLIDER_PLAY:String;
	 public static var SLIDER_ACHIEVEMENT:String;
	 public static var SLIDER_INFO:String;
	 public static var SLIDER_PRIZES:String;
	 public static var SLIDER_COMPETITION:String;
	 public static var SLIDER_SHOP:String;
	 public static var SLIDER_SHARE:String;
	 public static var SLIDER_ABOUT:String;
	 public static var SLIDER_INVITE:String;
	 public static var SLIDER_LEADERBOARD:String;
	 public static var SLIDER_LOGIN:String;
	 public static var SLIDER_REDEEM:String;
	 public static var SLIDER_PROFILE:String;
	 public static var SLIDER_FIND_A_STORE:String;
	 public static var SLIDER_SETTINGS:String;
	 static public var SLIDER_REGISTER:String;
	 static public var SLIDER_CHECK_IN:String;		
		
		
		
		public static var SHOP_HOME:String;
		public static var SHOP_HOME_SUB:String;
		
		public static var SHOP_FASHION:String;
		public static var SHOP_FASHION_SUB:String;
			
		public static var SHOP_POWERUPS:String;
		public static var SHOP_POWERUPS_SUB:String;
			
		public static var SHOP_PINDROP:String;
		public static var SHOP_PINDROP_SUB:String;
		
		public static var FIND_STORE_HOME:String;
		public static var FIND_STORE_HOME_SUB:String;	
				
		public static var MY_PRIZES_LIST:String;
		public static var MY_PRIZES_LIST_SUB:String;
										
		public static var MY_PRIZES_NO_PRIZES:String;
		public static var MY_PRIZES_NO_PRIZES_SUB:String;
																	
		public static var GRAND_PRIZE_WON:String;
		public static var GRAND_PRIZE_WON_SUB:String;
												
		public static var ABOUT:String;
		public static var ABOUT_SUB:String;
														
		public static var HELP:String;
		public static var HELP_SUB:String;
																
		public static var CREDITS:String;
		public static var CREDITS_SUB:String;
		
		public static var SETTINGS:String;
		public static var SETTINGS_SUB:String;
								
		public static var SHARE:String;
		public static var SHARE_SUB:String;
														
		public static var REDEEM:String;
		public static var REDEEM_SUB:String;	
																	
		public static var REDEEM_UNLOGGED_HEADER:String;
		public static var REDEEM_UNLOGGED_SUB:String;
						
		public static var COMPETITION:String;
		public static var COMPETITION_SUB:String;
								
		public static var PRE_PLAY:String;
		public static var PRE_PLAY_SUB:String;
										
		public static var PRE_PLAY_NO_COMP:String;
		public static var PRE_PLAY_NO_COMP_SUB:String;
		
		static public var LOGIN:String;
		static public var LOGIN_SUB:String;
						
		static public var FORGOT_PASS:String;
		static public var FORGOT_PASS_SUB:String;
									
		static public var REGISTER:String;
		static public var REGISTER_SUB:String;
		
		static public var PROFILE_HOME:String;
		static public var PROFILE_HOME_SUB:String;
				
		static public var PROFILE_UPDATE:String;
		static public var PROFILE_UPDATE_SUB:String;
						
		static public var PASSWORD:String;
		static public var PASSWORD_SUB:String;
		
		static public var EMAIL_LOGIN:String;
		static public var EMAIL_LOGIN_SUB:String;
		
		static public var ACHIEVEMENTS:String;
		static public var ACHIEVEMENTS_SUB:String;
		
		static public var APP_CLOSED:String;
		static public var APP_CLOSED_SUB:String;
		
		static public var LEADERBOARD:String;
		static public var LEADERBOARD_SUB:String;
		
		static public var SHARE_PRIZE_MESSAGE:String;
		static public var SHARE_SCORE_MESSAGE:String;
		
		static public var FB_SHARE_POST_NAME:String;
		static public var FB_SHARE_POST_LINK:String;
		static public var FB_SHARE_CAPTION:String;
		static public var FB_SHARE_MESSAGE:String;
		static public var FB_SHARE_DESCRIPTION_COMP_ON:String;
		static public var FB_SHARE_DESCRIPTION_COMP_OFF:String;		
		
		static public var EMAIL_SHARE_COMP_ON:String;
		static public var EMAIL_SHARE_COMP_OFF:String;
		
		static public var FORM_ERROR_MESSAGE_1:String;
		
		static public var NEW_TERMS:String;
		static public var NEW_TERMS_SUB:String;		
		static public var NEW_TERMS_COMP_CLOSED:String;
		static public var NEW_TERMS_SUB_COMP_CLOSED:String;


		static public function populate(labels:Object):void 
		{
/*				for (var i:String in labels)
				{
					trace(" # :" + labels[i]); 

				}*/
				
	 
	 APP_CLOSED_SCREEN  = "";
	 HOME_SCREEN  = labels[0].HOME_SCREEN;
	 ACHIEVEMENT_SCREEN  = labels[0].ACHIEVEMENT_SCREEN;
	 INFO_SCREEN  = labels[0].INFO_SCREEN;
	 PRIZES_SCREEN  = labels[0].PRIZES_SCREEN;
	 CHECK_IN_SCREEN  = labels[0].CHECK_IN_SCREEN;
	 COMPETITION_SCREEN  = labels[0].COMPETITION_SCREEN;
	 SHOP_SCREEN  = labels[0].SHOP_SCREEN;
	 SHARE_SCREEN  = labels[0].SHARE_SCREEN;
	 ABOUT_SCREEN  = labels[0].ABOUT_SCREEN;
	 INVITE_SCREEN  = labels[0].INVITE_SCREEN;
	 LEADERBOARD_SCREEN = labels[0].LEADERBOARD_SCREEN;
	 LOGIN_SCREEN  = labels[0].LOGIN_SCREEN;
	 REDEEM_SCREEN  = labels[0].REDEEM_SCREEN;
	 PRE_PLAY_SCREEN  = labels[0].PRE_PLAY_SCREEN;
	 PROFILE_SCREEN  = labels[0].PROFILE_SCREEN;
	 FIND_A_STORE_SCREEN  = labels[0].FIND_A_STORE_SCREEN;
	 SETTINGS_SCREEN  = labels[0].SETTINGS_SCREEN;
	 REGISTER_SCREEN = labels[0].REGISTER_SCREEN;
				
	 SLIDER_HOME  = labels[0].SLIDER_HOME;
	 SLIDER_ACHIEVEMENT = labels[0].SLIDER_ACHIEVEMENT;
	 SLIDER_INFO  = labels[0].SLIDER_INFO;
	 SLIDER_PRIZES = labels[0].SLIDER_PRIZES;
	 SLIDER_COMPETITION = labels[0].SLIDER_COMPETITION;
	 SLIDER_SHOP  = labels[0].SLIDER_SHOP;
	 SLIDER_SHARE  = labels[0].SLIDER_SHARE;
	 SLIDER_ABOUT  = labels[0].SLIDER_ABOUT;
	 SLIDER_INVITE  = labels[0].SLIDER_INVITE;
	 SLIDER_LEADERBOARD  = labels[0].SLIDER_LEADERBOARD;
	 SLIDER_LOGIN  = labels[0].SLIDER_LOGIN;
	 SLIDER_REDEEM  = labels[0].SLIDER_REDEEM;
	 SLIDER_PROFILE  = labels[0].SLIDER_PROFILE;
	 SLIDER_FIND_A_STORE  = labels[0].SLIDER_FIND_A_STORE;
	 SLIDER_SETTINGS  = labels[0].SLIDER_SETTINGS;
	 SLIDER_REGISTER = labels[0].SLIDER_REGISTER;
	 SLIDER_CHECK_IN = labels[0].SLIDER_CHECK_IN;
    	
		NEW_TERMS = labels[0].NEW_TERMS;		
		NEW_TERMS_SUB = labels[0].NEW_TERMS_SUB;
		
		NEW_TERMS_COMP_CLOSED = labels[0].NEW_TERMS_COMP_CLOSED;		
		NEW_TERMS_SUB_COMP_CLOSED = labels[0].NEW_TERMS_SUB_COMP_CLOSED;		
		
		MY_PRIZES_LIST = labels[0].MY_PRIZES_LIST;
		MY_PRIZES_LIST_SUB = labels[0].MY_PRIZES_LIST_SUB;
			SHOP_HOME = labels[0].SHOP_HOME;
			SLIDER_PLAY = labels[0].SLIDER_PLAY;
			SHOP_HOME_SUB = labels[0].SHOP_HOME_SUB;
			SHOP_FASHION = labels[0].SHOP_FASHION;
			SHOP_FASHION_SUB = labels[0].SHOP_FASHION_SUB;
			SHOP_POWERUPS = labels[0].SHOP_POWERUPS;
			SHOP_POWERUPS_SUB = labels[0].SHOP_POWERUPS_SUB;
			SHOP_PINDROP = labels[0].SHOP_PINDROP;
			SHOP_PINDROP_SUB = labels[0].SHOP_PINDROP_SUB;
			FIND_STORE_HOME = labels[0].FIND_STORE_HOME;
			FIND_STORE_HOME_SUB = labels[0].FIND_STORE_HOME_SUB;
			GRAND_PRIZE_WON = labels[0].GRAND_PRIZE_WON;
			GRAND_PRIZE_WON_SUB = labels[0].GRAND_PRIZE_WON_SUB;
			ABOUT = labels[0].ABOUT;
			ABOUT_SUB = labels[0].ABOUT_SUB;
			MY_PRIZES_NO_PRIZES = labels[0].MY_PRIZES_NO_PRIZES;
			MY_PRIZES_NO_PRIZES_SUB = labels[0].MY_PRIZES_NO_PRIZES_SUB;
			HELP = labels[0].HELP;
			HELP_SUB = labels[0].HELP_SUB;
			CREDITS = labels[0].CREDITS;
			CREDITS_SUB = labels[0].CREDITS_SUB;
			SETTINGS = labels[0].SETTINGS;
			SETTINGS_SUB = labels[0].SETTINGS_SUB;
			SHARE = labels[0].SHARE;
			SHARE_SUB = labels[0].SHARE_SUB;
			REDEEM = labels[0].REDEEM;
			REDEEM_SUB = labels[0].REDEEM_SUB;
			REDEEM_UNLOGGED_HEADER = labels[0].REDEEM_UNLOGGED_HEADER;
			REDEEM_UNLOGGED_SUB = labels[0].REDEEM_UNLOGGED_SUB;
			COMPETITION = labels[0].COMPETITION;
			COMPETITION_SUB = labels[0].COMPETITION_SUB;
			PRE_PLAY = labels[0].PRE_PLAY;
			PRE_PLAY_SUB = labels[0].PRE_PLAY_SUB;
			PRE_PLAY_NO_COMP = labels[0].PRE_PLAY_NO_COMP;
			PRE_PLAY_NO_COMP_SUB = labels[0].PRE_PLAY_NO_COMP_SUB;
			LOGIN = labels[0].LOGIN;
			LOGIN_SUB = labels[0].LOGIN_SUB;
			FORGOT_PASS = labels[0].FORGOT_PASS;
			FORGOT_PASS_SUB = labels[0].FORGOT_PASS_SUB;
			REGISTER = labels[0].REGISTER;
			REGISTER_SUB = labels[0].REGISTER_SUB;
			PROFILE_HOME = labels[0].PROFILE_HOME;
			PROFILE_HOME_SUB = labels[0].PROFILE_HOME_SUB;
			PROFILE_UPDATE = labels[0].PROFILE_UPDATE;
			PROFILE_UPDATE_SUB = labels[0].PROFILE_UPDATE_SUB;
			PASSWORD = labels[0].PASSWORD;
			PASSWORD_SUB = labels[0].PASSWORD_SUB;
			EMAIL_LOGIN = labels[0].EMAIL_LOGIN;
			EMAIL_LOGIN_SUB = labels[0].EMAIL_LOGIN_SUB;
			ACHIEVEMENTS = labels[0].ACHIEVEMENTS;
			ACHIEVEMENTS_SUB = labels[0].ACHIEVEMENTS_SUB;
			APP_CLOSED = labels[0].APP_CLOSED;
			APP_CLOSED_SUB = labels[0].APP_CLOSED_SUB;
			LEADERBOARD = labels[0].LEADERBOARD;
			LEADERBOARD_SUB = labels[0].LEADERBOARD_SUB;
			SHARE_PRIZE_MESSAGE = labels[0].SHARE_PRIZE_MESSAGE;
			SHARE_SCORE_MESSAGE = labels[0].SHARE_SCORE_MESSAGE;
			
			FB_SHARE_POST_NAME = labels[0].FB_SHARE_POST_NAME;
			FB_SHARE_POST_LINK = labels[0].FB_SHARE_POST_LINK;
			FB_SHARE_CAPTION = labels[0].FB_SHARE_CAPTION;
			FB_SHARE_MESSAGE = labels[0].FB_SHARE_MESSAGE;
			FB_SHARE_DESCRIPTION_COMP_ON = labels[0].FB_SHARE_DESCRIPTION_COMP_ON;
			FB_SHARE_DESCRIPTION_COMP_OFF = labels[0].FB_SHARE_DESCRIPTION_COMP_OFF;
			
			EMAIL_SHARE_COMP_ON = labels[0].EMAIL_SHARE_COMP_ON;
			EMAIL_SHARE_COMP_OFF = labels[0].EMAIL_SHARE_COMP_OFF;
			
			FORM_ERROR_MESSAGE_1 = labels[0].FORM_ERROR_MESSAGE_1;
		}
		

		

	}
		
	

}