package staticData 
{

	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import staticData.settings.PublicSettings;
	import staticData.valueObjects.powerUps.AntiGravityVO;
	import staticData.valueObjects.powerUps.BoostVO;
	import staticData.valueObjects.powerUps.HeadGearVO;
	import view.components.ui.SlideOutMenu;

	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class AppData
	{
	static public var isGuest:Boolean = false;	
		
	static public var STAGE_WIDTH:int;
	static public var STAGE_HEIGHT:int;
	
	static public var currentGameLevel:int = 1;
	static public var currentPlayerLevel:int = 1;
	
	static public var currentPlayerXP:int = 0;	
	static public var currentPlayerLevelXP:int = 0;		
	static public var nextLevelXP:int;	
	
	
	public static var deviceResX:int;
	public static var deviceResY:int;	
	
	public static var deviceScaleX:Number;
	public static var deviceScaleY:Number;
		
	public static var offsetScaleX:Number;
	public static var offsetScaleY:Number;
	
	static public var baseResX:int;
	static public var baseResY:int;
	static public var isBoosting:Boolean = false;
	static public var currMapLength:int = 0;

	static public var isFreeze:Boolean = false;
	static public var isMovable:Boolean = true;
	static public var isGameInPlay:Boolean = false;
	static public var currSpeed:Number;
	static public var currBoostSpeed:int;
	static public var currLives:int;

	
	static public var isFreezePlay:Boolean = false;
	static public var totalLives:int = HeadGearVO.CURRENT_LEVEL
	static public var currAccSpeed:Number;
	static public var notifyOfPassReset:Boolean = false;
	static public var scoreThreshold:int;
	
	static public var currBoostFuel:Number;
	static public var maxBoostFuel:Number;
	
	
		
	static public var currDriftFuel:Number;
	static public var maxDriftFuel:Number;
	
	
	static public var currDiveScore:int;
	static public var currDiveDistance:int;
	static public var currDiveCoins:int;
	static public var currDiveMobsKill:int;
	static public var currDiveNugs:int = 0;
	static public var currLandingScore:int;
	
	static public var currentLevel:int = 0;
	static public var currDifficultyBracket:String = "beginner";
	static public var arrStageTextInstanes:Array = [];
	
	
	
	static public var badWords:Array;
	static public var badWordsSource:ByteArray;
	static public var bitmapScreenNormal:BitmapData;
	static public var bitmapScreenPrize:BitmapData;
	static public var mysteryChance:int = 6; // 0 - 10
	static public var currDeathXPos:Number = 0;
	
	static public var arrSpeedLines:Array = [];
	static public var arrActionObjects:Array = [];
	static public var arrClouds:Array = [];
	static public var isGamePlayedOnce:Boolean = false;
	static public var requiredAppVersion:String;
	static public var isCoreMobileSupported:Boolean = false;
	static public var pendingNotificationID:String;
	static public var isInSpecialZone:Boolean = false;
	static public var currDiveNugZoneVisits:int = 0;
	static public var deviceScale:Number;

	

	
	
	
	

	
	
	
	static public function reset():void 
	{
		trace(AppData + "reset()");
		//currSpeed = PublicSettings.BASE_SPEED;
		//currBoostSpeed = PublicSettings.BASE_BOOST_SPEED;
		currDiveNugZoneVisits = 0
		currDiveScore = 0;
		//currDiveDistance = PublicSettings.START_DISTANCE;
		currDiveCoins = 0;
		currDiveMobsKill = 0;
		currDeathXPos = 0;
		currDiveNugs = 0;
		currLandingScore = 0;
	
		//mysteryChance = PublicSettings.MYSTERY_PERC;
		currLives = 0;
		currentLevel = 0;
		isFreezePlay = false;
		isMovable = true;
		isBoosting = false;
		
		
		
		currDifficultyBracket = "beginner";
		
		maxBoostFuel = BoostVO.CURRENT_LEVEL * 500;
		currBoostFuel = maxBoostFuel;	
		maxDriftFuel = AntiGravityVO.CURRENT_LEVEL * 150;
		currDriftFuel = maxDriftFuel;
		
		trace("currBoostFuel :" + currBoostFuel);
		//Inventory.coins = PublicSettings.COIN_START_AMOUNT;
	}
	
	
	

	
	

	}

	
	
	


}