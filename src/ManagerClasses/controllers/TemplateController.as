package ManagerClasses.controllers 
{
	import ManagerClasses.supers.SuperController;

	
	//================================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//================================================o
	
	public class TemplateController extends SuperController
	{
		
		
		//================================================o
		//------ Constructor
		//================================================o			
		public function TemplateController() 
		{
			trace("SettingsController constructed");
			
		}
		
		//================================================o
		//------ init
		//================================================o				
		public function init():void
		{
			restoreSettings();
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