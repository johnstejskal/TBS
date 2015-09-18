package ManagerClasses.controllers 
{
	import ManagerClasses.supers.SuperController;
	import staticData.constants.ExternalData;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.ResourceData;
	import staticData.valueObjects.OreVO;

	
	//================================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//================================================o
	
	public class ResourceController extends SuperController
	{
		private var _arrOreMasterList:Array;
		
		
		//================================================o
		//------ Constructor /\/\/\/\/\/\/\/\/\/\/\/\/\/\
		//================================================o			
		public function ResourceController() 
		{
			trace("SettingsController constructed");
			
		}
		
		//================================================o
		//------ init
		//================================================o				
		public function init():void
		{
			ResourceData.objOreMasterList = JSON.parse(new ExternalData.OreList());

			for ( var i:String in ResourceData.objOreMasterList)
			{
				var obj:Object = ResourceData.objOreMasterList[i];
				var item:OreVO = new OreVO();
				item.id = obj.ID;
				item.ref = obj.REF;
				item.name = obj.NAME;
				item.description = obj.DESCRIPTION;
				item.strengthGrade = obj.STRENGTH_GRADE;
				item.requiredLevel = obj.REQUIRED_LEVEL;

				ResourceData.arrOreMasterList.push(item);
			}
			
			_arrOreMasterList = ResourceData.arrOreMasterList;
			
		}
		
		
		//================================================o
		//------ Restore Settings from SharedObjects
		//================================================o	
		private function restoreSettings():void 
		{
			
		}




		//================================================o
		//------ trash/kill/dispose
		//================================================o		
		public function trash():void
		{
			
		}
		


		
		//================================================o
		//------ Getters and Setters
		//================================================o			


		
	}

}