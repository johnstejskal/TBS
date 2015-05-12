package staticData.dataObjects 
{
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	import staticData.valueObjects.LeaderVO;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class LeaderboardData 
	{

		//static public var objLeaders:Object;
		static public var arrLeaders:Array = [];
		
		
		static public var objNugWeek:Object = { };
		static public var arrNugWeek:Array = [];
		
		static public var objAllALL:Object = {};
		static public var arrAllALL:Array = [];
		
		static public var objAllToday:Object = {};
		static public var arrAllToday:Array = [];
		
				
		static public var objStateToday:Object = {};
		static public var arrStateToday:Array = [];
						
		static public var objStateAll:Object = {};
		static public var arrStateAll:Array = [];
						
		static public var objFBToday:Object = {};
		static public var arrFBToday:Array = [];
						
		static public var objFBAll:Object = {};
		static public var arrFBAll:Array = [];
		
		static public var playerRankNugs:Number;
		static public var playerRankAll:Number;
		static public var playerRankToday:Number;
		static public var playerFacebookRankAll:Number;
		static public var playerFacebookRankToday:Number;
		static public var playerRankStateAll:Number;
		static public var playerRankStateToday:Number;
		static public var playerBestScoreToday:Number;
		static public var playerBestScoreAll:Number;
		
		
		static public function reset():void 
		{
		playerRankNugs = NaN;
		playerRankAll = NaN;
		playerRankToday = NaN;
		playerFacebookRankAll = NaN;
		playerFacebookRankToday = NaN;
		playerRankStateAll = NaN;
		playerRankStateToday = NaN;
		playerBestScoreToday = NaN;
		playerBestScoreAll = NaN;
		
		
		arrLeaders = [];
		
		//objAllALL = {};
		//arrAllALL = [];
		
		//objAllToday = {};
		//arrAllToday = [];
		
		objNugWeek = { }
		arrNugWeek = [];
		
		objStateToday = {};
		arrStateToday = [];
						
		objStateAll = {};
		arrStateAll = [];
						
		objFBToday = {};
		arrFBToday = [];
						
		objFBAll = {};
		arrFBAll = [];
		
		}
		

		
	}

}