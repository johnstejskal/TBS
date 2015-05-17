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
	public class DSpriteSheet_mining 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "mine";
		static public var _onComplete:Function;

		public function DSpriteSheet_mining() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			_onComplete = complete;
			trace(DSpriteSheet_mining + "init()");
			dtm = new DMTBasic(ref, false);
				

			// TIN ---------------------------------------------------------------o
			var mine_ore_tin_1:MC_mine_ore_tin_1 = new MC_mine_ore_tin_1();
			mine_ore_tin_1.scaleX = mine_ore_tin_1.scaleY = AppData.deviceScale;		
													
			var mine_ore_tin_2:MC_mine_ore_tin_2  = new MC_mine_ore_tin_2();
			mine_ore_tin_2.scaleX = mine_ore_tin_2.scaleY = AppData.deviceScale;		
													
			var mine_ore_tin_3:MC_mine_ore_tin_3  = new MC_mine_ore_tin_3();
			mine_ore_tin_3.scaleX = mine_ore_tin_3.scaleY = AppData.deviceScale;		

			dtm.addItemToRaster(mine_ore_tin_1, "mine_ore_tin_1");
			dtm.addItemToRaster(mine_ore_tin_2, "mine_ore_tin_2");
			dtm.addItemToRaster(mine_ore_tin_3, "mine_ore_tin_3");

			// COPER ---------------------------------------------------------------o
			var mine_ore_copper_1:MC_mine_ore_copper_1  = new MC_mine_ore_copper_1();
			mine_ore_copper_1.scaleX = mine_ore_copper_1.scaleY = AppData.deviceScale;	
													
			var mine_ore_copper_2:MC_mine_ore_copper_2  = new MC_mine_ore_copper_2();
			mine_ore_copper_2.scaleX = mine_ore_copper_2.scaleY = AppData.deviceScale;	
													
			var mine_ore_copper_3:MC_mine_ore_copper_3  = new MC_mine_ore_copper_3();
			mine_ore_copper_3.scaleX = mine_ore_copper_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_copper_1, "mine_ore_copper_1");
			dtm.addItemToRaster(mine_ore_copper_2, "mine_ore_copper_2");
			dtm.addItemToRaster(mine_ore_copper_3, "mine_ore_copper_3");	
			
			// COAL ---------------------------------------------------------------o
			var mine_ore_coal_1:MC_mine_ore_coal_1 = new MC_mine_ore_coal_1();
			mine_ore_coal_1.scaleX = mine_ore_coal_1.scaleY = AppData.deviceScale;		
													
			var mine_ore_coal_2:MC_mine_ore_coal_2  = new MC_mine_ore_coal_2();
			mine_ore_coal_2.scaleX = mine_ore_coal_2.scaleY = AppData.deviceScale;	
													
			var mine_ore_coal_3:MC_mine_ore_coal_3  = new MC_mine_ore_coal_3();
			mine_ore_coal_3.scaleX = mine_ore_coal_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_coal_1, "mine_ore_coal_1");
			dtm.addItemToRaster(mine_ore_coal_2, "mine_ore_coal_2");
			dtm.addItemToRaster(mine_ore_coal_3, "mine_ore_coal_3");	
			
			// IRON ---------------------------------------------------------------o
			var mine_ore_iron_1:MC_mine_ore_iron_1  = new MC_mine_ore_iron_1();
			mine_ore_iron_1.scaleX = mine_ore_iron_1.scaleY = AppData.deviceScale;		
													
			var mine_ore_iron_2:MC_mine_ore_iron_2  = new MC_mine_ore_iron_2();
			mine_ore_iron_2.scaleX = mine_ore_iron_2.scaleY = AppData.deviceScale;	
													
			var mine_ore_iron_3:MC_mine_ore_iron_3  = new MC_mine_ore_iron_3();
			mine_ore_iron_3.scaleX = mine_ore_iron_3.scaleY = AppData.deviceScale;		

			dtm.addItemToRaster(mine_ore_iron_1, "mine_ore_iron_1");
			dtm.addItemToRaster(mine_ore_iron_2, "mine_ore_iron_2");
			dtm.addItemToRaster(mine_ore_iron_3, "mine_ore_iron_3");	
						
			// GOLD---------------------------------------------------------------o
			var mine_ore_gold_1:MC_mine_ore_gold_1  = new MC_mine_ore_gold_1();
			mine_ore_gold_1.scaleX = mine_ore_gold_1.scaleY = AppData.deviceScale;		
													
			var mine_ore_gold_2:MC_mine_ore_gold_2  = new MC_mine_ore_gold_2();
			mine_ore_gold_2.scaleX = mine_ore_gold_2.scaleY = AppData.deviceScale;		
													
			var mine_ore_gold_3:MC_mine_ore_gold_3  = new MC_mine_ore_gold_3();
			mine_ore_gold_3.scaleX = mine_ore_gold_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_gold_1, "mine_ore_gold_1");
			dtm.addItemToRaster(mine_ore_gold_2, "mine_ore_gold_2");
			dtm.addItemToRaster(mine_ore_gold_3, "mine_ore_gold_3");	
									
			// MITHRIL ---------------------------------------------------------------o
			var mine_ore_mithril_1:MC_mine_ore_mithril_1  = new MC_mine_ore_mithril_1();
			mine_ore_mithril_1.scaleX = mine_ore_mithril_1.scaleY = AppData.deviceScale;	
													
			var mine_ore_mithril_2:MC_mine_ore_mithril_2  = new MC_mine_ore_mithril_2();
			mine_ore_mithril_2.scaleX = mine_ore_mithril_2.scaleY = AppData.deviceScale;	
													
			var mine_ore_mithril_3:MC_mine_ore_mithril_3 = new MC_mine_ore_mithril_3();
			mine_ore_mithril_3.scaleX = mine_ore_mithril_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_mithril_1, "mine_ore_mithril_1");
			dtm.addItemToRaster(mine_ore_mithril_2, "mine_ore_mithril_2");
			dtm.addItemToRaster(mine_ore_mithril_3, "mine_ore_mithril_3");	
												
			// ADAMANTITE---------------------------------------------------------------o
			var mine_ore_adamantite_1:MC_mine_ore_adamantite_1  = new MC_mine_ore_adamantite_1();
			mine_ore_adamantite_1.scaleX = mine_ore_adamantite_1.scaleY = AppData.deviceScale;	
													
			var mine_ore_adamantite_2:MC_mine_ore_adamantite_2  = new MC_mine_ore_adamantite_2();
			mine_ore_adamantite_2.scaleX = mine_ore_adamantite_2.scaleY = AppData.deviceScale;		
													
			var mine_ore_adamantite_3:MC_mine_ore_adamantite_3 = new MC_mine_ore_adamantite_3();
			mine_ore_adamantite_3.scaleX = mine_ore_adamantite_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_adamantite_1, "mine_ore_adamantite_1");
			dtm.addItemToRaster(mine_ore_adamantite_2, "mine_ore_adamantite_2");
			dtm.addItemToRaster(mine_ore_adamantite_3, "mine_ore_adamantite_3");	
			
															
			// OBSIDIAN ---------------------------------------------------------------o
			var mine_ore_obsidian_1:MC_mine_ore_obsidian_1  = new MC_mine_ore_obsidian_1();
			mine_ore_obsidian_1.scaleX = mine_ore_obsidian_1.scaleY = AppData.deviceScale;	
													
			var mine_ore_obsidian_2:MC_mine_ore_obsidian_2  = new MC_mine_ore_obsidian_2();
			mine_ore_obsidian_2.scaleX = mine_ore_obsidian_2.scaleY = AppData.deviceScale;		
													
			var mine_ore_obsidian_3:MC_mine_ore_obsidian_3 = new MC_mine_ore_obsidian_3();
			mine_ore_obsidian_3.scaleX = mine_ore_obsidian_3.scaleY = AppData.deviceScale;	

			dtm.addItemToRaster(mine_ore_obsidian_1, "mine_ore_obsidian_1");
			dtm.addItemToRaster(mine_ore_obsidian_2, "mine_ore_obsidian_2");
			dtm.addItemToRaster(mine_ore_obsidian_3, "mine_ore_obsidian_3");	
																		
			// dragonite ---------------------------------------------------------------o
			var mine_ore_dragonite_1:MC_mine_ore_dragonite_1  = new MC_mine_ore_dragonite_1();
			mine_ore_dragonite_1.scaleX = mine_ore_dragonite_1.scaleY = AppData.deviceScale;		
													
			var mine_ore_dragonite_2:MC_mine_ore_dragonite_2  = new MC_mine_ore_dragonite_2();
			mine_ore_dragonite_2.scaleX = mine_ore_dragonite_2.scaleY = AppData.deviceScale;		
													
			var mine_ore_dragonite_3:MC_mine_ore_dragonite_3 = new MC_mine_ore_dragonite_3();
			mine_ore_dragonite_3.scaleX = mine_ore_dragonite_3.scaleY = AppData.deviceScale;		

			dtm.addItemToRaster(mine_ore_dragonite_1, "mine_ore_dragonite_1");
			dtm.addItemToRaster(mine_ore_dragonite_2, "mine_ore_dragonite_2");
			dtm.addItemToRaster(mine_ore_dragonite_3, "mine_ore_dragonite_3");	
			
			
			var nextMineButton:MC_mineChangeButton = new MC_mineChangeButton();
			nextMineButton.scaleX = nextMineButton.scaleY = AppData.deviceScale;		
			dtm.addItemToRaster(nextMineButton, "nextMineButton");			
			
			
			var pickAxe:MC_pickAxe = new MC_pickAxe();
			pickAxe.scaleX = pickAxe.scaleY = AppData.deviceScale;	
			dtm.addItemToRaster(pickAxe, "pickAxe");		
					
			
			var toolBarItem:MC_toolbarItem = new MC_toolbarItem();
			toolBarItem.scaleX = toolBarItem.scaleY = AppData.deviceScale;	
			dtm.addItemToRaster(toolBarItem, "toolBarItem");		
			
			
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