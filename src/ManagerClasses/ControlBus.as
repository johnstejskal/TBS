package ManagerClasses 
{
	import ManagerClasses.controllers.AchievementController;
	import ManagerClasses.controllers.AppUIController;

	import ManagerClasses.controllers.InventoryController;
	import ManagerClasses.controllers.MapsController;

	import ManagerClasses.controllers.ShopItemController;
	import ManagerClasses.controllers.SoundController;
	import ManagerClasses.supers.SuperController;
	import singleton.Core;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ControlBus 
	{
		public var core:Core
		public function ControlBus() 
		{
			core = Core.getInstance();
		}
		
		public var appUIController:AppUIController;
		public var mapsController:MapsController;
		public var achievementController:AchievementController;
/*		public var powerupController:PowerUpController;
		public var gameHUDController:HUDController;*/
		public var inventoryController:InventoryController;
		public var shopItemController:ShopItemController;

		public var soundController:SoundController;

		
		public function initController(controller:SuperController, classRef:Class):void
		{
			controller = new classRef();
		}
		
	}

}