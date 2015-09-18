package ManagerClasses.controllers 
{

	import ManagerClasses.supers.SuperController;
	import staticData.dataObjects.Disciplines;
	import staticData.dataObjects.PlayerData;

 
	//================================================o
	/**
	 * ...
	 * @author ...
	 */
	//================================================o
	public class PlayerController extends SuperController
	{
		private var _nextMiningLevelExp:int;
		private var _nextSmithingLevelExp:int;
		private var _nextLumberingLevelExp:int;
		
		
		//================================================o
		//------ Constructor /\/\/\/\/\//\/\/\/\/\/\/\/\/\/
		//================================================o			
		public function PlayerController() 
		{
			trace(this+"constructed");
			init();
		}
		
		
		public function init():void
		{
			setNextLevels();
		}
		
		private function setNextLevels():void 
		{
			_nextMiningLevelExp = PlayerData.currMiningLevel * 5;
			_nextSmithingLevelExp = PlayerData.currSmithingLevel * 5;
			_nextLumberingLevelExp = PlayerData.currLumberingLevel * 5;
		}
		
		public function updateExperience(descipline:String, amount:int):void 
		{
			
			trace(this + "updateExperience(descipline:" + descipline+", amount:" + amount + ")");
			switch(descipline)
			{
				case Disciplines.SMITHING:
				
				break;
				//------------------------o
			    case Disciplines.MINING:
				PlayerData.currMiningExp += amount;
				if (PlayerData.currMiningExp >= _nextMiningLevelExp)
				{
					
					doLevelUp(Disciplines.MINING);
					
				}
				break;	
				//------------------------o
				case Disciplines.LUMBERING:
				
				break;						
			}
			
		}
		
		private function doLevelUp(descipline:String):void 
		{
			trace(this + "LEVEL UP of " + descipline);
			switch(descipline)
			{
				case Disciplines.SMITHING:
				
				break;
				//------------------------o
			    case Disciplines.MINING:
					PlayerData.currMiningLevel ++;
					PlayerData.currMiningExp = 0;
				break;	
				//------------------------o
				case Disciplines.LUMBERING:
				
				break;						
			}	
			setNextLevels();
		}
		
		public function get nextMiningLevelExp():int 
		{
			return _nextMiningLevelExp;
		}
		
		

		
		
	}

}