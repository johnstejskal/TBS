package staticData 
{

	import flash.display.BitmapData;
	import flash.geom.Point;
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
	public class GameData
	{

		
		
		
	static public var arrDestinationSlots:Array = [];
	static public var arrDestinationSlotsR:Array = [];
	
	static public var currentGameLevel:int = 1;
	static public var currentPlayerLevel:int = 1;
	static public var currentSpeed:Number = 0;// PublicSettings.BASE_GAME_SPEED;
	
	static public var currentPlayerXP:int = 0;	
	static public var currentPlayerLevelXP:int = 0;		
	static public var nextLevelXP:int;	
	
	
	static public var baseResX:int;
	static public var baseResY:int;
	static public var isBoosting:Boolean = false;
	static public var currMapLength:int = 0;

	static public var isGameInPlay:Boolean = false;
	
	static public var arrRoadTilesL:Array = [];
	static public var arrRoadTilesR:Array = [];
	
	static public var ptExitSlotL:Point;
	static public var ptExitSlotR:Point;
	static public var showRoadSign:Boolean = false;
	static public var roadSignCount:int = 0;
	static public var currMapCount:int = 0;
	static public var isSliding:Boolean = false;
	static public var currLaneChangeSpeed:Number = .4;
	static public var currCoins:int = 0;
	static public var currDistance:int = 0;


	
	
		static public function reset():void 
		{
			trace(AppData + "reset()");

		}
	
	
	

	
	

	}

	
	
	


}