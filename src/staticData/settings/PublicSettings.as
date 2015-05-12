package staticData.settings 
{

	import ManagerClasses.StateMachine;

	//============================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//============================================o
	
	//============================================o
	 /*
	  * This is a public interface for global app settings.
	  *
	  */
	 //============================================o
	public class PublicSettings
	{
		
	static public var VERSION:String = "v1.0.0";
	static public var PLATFORM:String = "IOS";
	static public var DEVICE_RELEASE:Boolean = false;
	static public var DEBUG_RELEASE:Boolean = true;
	static public var FLASH_IDE_COMPILE:Boolean = false;
	
	static public const SHOW_STARLING_STATS:Boolean = true;
	static public const ENABLE_LOCAL_STORAGE:Boolean = true;
	static public const ENFORCE_APP_VERSION:Boolean = true;
	static public const ENABLE_LOCAL_NOTIFICATIONS:Boolean = true;
	
	static public const ENABLE_ANALYTICS:Boolean = true;
	static public const MUTE_MUSIC:Boolean = false;
	static public const MUTE_SOUND:Boolean = false;

	static public const DEBUG_MODE:Boolean = false;
	static public const INITIAL_APP_STATE:String = StateMachine.STATE_GAME;
	
	
	static public const WINDOW_X:String = "windowX";
	static public const WINDOW_Y:String = "windowY";
	static public const DYNAMIC_LIBRARY_UI:String = "swfLibrary_UI";
	
	
	static public const COIN_START_AMOUNT:int = 0;
	static public const ACHIEVEMENT_PANEL_TIME:int = 1;
	static public const SLIDE_MENU_OUT_SPEED:Number = .5;
	static public const SLIDE_MENU_IN_SPEED:Number = .5;
	
	
	static public const BASE_GAME_SPEED:int = 6;
	static public const SHOW_COLLISION_POINTS:Boolean = true;
	static public const NITRO_SPEED:int = 20;
	static public const MAX_SPEED:int = 15;
	
	}

}