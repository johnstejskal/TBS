package staticData.valueObjects 
{
	import staticData.valueObjects.powerUps.AntiGravityVO;
	import staticData.valueObjects.powerUps.BoostMoveVO;
	import staticData.valueObjects.powerUps.BoostVO;
	import staticData.valueObjects.powerUps.CoinDoubleVO;
	import staticData.valueObjects.powerUps.CoinMagnetVO;

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ShopItemVO extends ValueObject
	{
		
		public var ID:String;
		public var REF:String;
		public var NAME:String;
		public var DESCRIPTION:String;
		public var PRICE:String;
		public var AVAILABLE:String;
		public var PURCHASED:Boolean;
		public var EQUIPPED:Boolean;
		public var LEVEL:String; //applies to powerup items
		public var IS_DEFAULT_ITEM:Boolean;
		public var LEVELABLE:Boolean;
		public var TYPE:String;
		public var CRITERIA_MET:Boolean;
		public var SKILL_VO:Class;
		
		public static const TYPE_POWERUP:String = "powerup";
		public static const TYPE_FASHION:String = "fashion";
		public static const TYPE_PINDROP:String = "pinDrop";
		public static const TYPE_NUG_ZONE:String = "nugZone";
		
		public static const REF_COIN_MAGNET:String = CoinMagnetVO.REF_NAME;
		public static const REF_COIN_MULTI:String = CoinDoubleVO.REF_NAME;
		public static const REF_PINDROP:String = BoostVO.REF_NAME;	
		public static const REF_PINDROP_MOVE:String = BoostMoveVO.REF_NAME;	
		public static const REF_ANTI_GRAVITY:String = AntiGravityVO.REF_NAME;	
		
		//accociated skill VO for powerups/pindrop
		
		
		




		
		
		public function ShopItemVO() 
		{
			
		}
		
		
		
		
	}

}