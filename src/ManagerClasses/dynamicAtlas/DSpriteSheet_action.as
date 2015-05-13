package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;
	import staticData.AppData;
	import staticData.dataObjects.PlayerData;
	import staticData.settings.PublicSettings;

	/**
	 * ...
	 * @author 
	 */
	public class DSpriteSheet_action 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "action";
		static public var _onComplete:Function;
		static public var arrUpgrades:Array = [MC_car0, MC_car1, MC_car2, MC_car3, MC_car4, MC_car5, MC_car6, MC_car7, MC_car8, MC_car9, MC_car10, MC_car11];
		
		public function DSpriteSheet_action() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			return;
			_onComplete = complete;
			trace(DSpriteSheet_action + "init()");
			dtm = new DMTBasic(ref, false);
				
			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process( true, 1, PublicSettings.FLASH_IDE_COMPILE);	
			

		}
		
		static private function onProcessComplete(e:Event):void 
		{
			dtm.removeEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			
			if (_onComplete != null)
			_onComplete();
		}
		
		
		public static function trash():void
		{
			if (dtm != null)
			{
				dtm.dispose();
				dtm = null;
			}
		}

		
	}

}