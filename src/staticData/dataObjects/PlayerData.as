package staticData.dataObjects 
{
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	import flash.utils.ByteArray;
	import staticData.settings.PublicSettings;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PlayerData 
	{

	static public var firstName:String;
	static public var arrPurchasedItems:Array = [];
	static public var arrAchievements:Array = [];
	static public var carUpgradeLevel:int = 1;
	
	
	
	static public var currMiningExp:int = 0;
	static public var currMiningLevel:int = 1;
		
	static public var currSmithingExp:int;
	static public var currSmithingLevel:int = 1;
			
	static public var currLumberingExp:int;
	static public var currLumberingLevel:int = 1;
	
	}
}
	