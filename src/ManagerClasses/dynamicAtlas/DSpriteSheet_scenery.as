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
	public class DSpriteSheet_scenery 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "action";
		static public var _onComplete:Function;

		public function DSpriteSheet_scenery() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			_onComplete = complete;
			trace(DSpriteSheet_action + "init()");
			dtm = new DMTBasic(ref, false);
				
			var tile_road:MC_tile_road = new MC_tile_road();
			tile_road.scaleX = tile_road.scaleY = AppData.offsetScaleX;			
							
			var tile_terrain_orangeA:MC_tile_terrain_orangeA = new MC_tile_terrain_orangeA();
			tile_terrain_orangeA.scaleX = tile_terrain_orangeA.scaleY = AppData.offsetScaleX;			
											
			var tile_terrain_orangeB:MC_tile_terrain_orangeB = new MC_tile_terrain_orangeB();
			tile_terrain_orangeB.scaleX = tile_terrain_orangeB.scaleY = AppData.offsetScaleX;			
											
			var tile_terrain_greenA:MC_tile_terrain_greenA = new MC_tile_terrain_greenA();
			tile_terrain_greenA.scaleX = tile_terrain_greenA.scaleY = AppData.offsetScaleX;			
											
			var tile_terrain_greenB:MC_tile_terrain_greenB = new MC_tile_terrain_greenB();
			tile_terrain_greenB.scaleX = tile_terrain_greenB.scaleY = AppData.offsetScaleX;			
							
			var sceneryRock1:MC_sceneryRock1 = new MC_sceneryRock1();
			sceneryRock1.scaleX = sceneryRock1.scaleY = AppData.offsetScaleX;	
									
			var sceneryRock2:MC_sceneryRock2 = new MC_sceneryRock2();
			sceneryRock2.scaleX = sceneryRock2.scaleY = AppData.offsetScaleX;	
												
			var desertShrub:MC_desertShrub = new MC_desertShrub();
			desertShrub.scaleX = desertShrub.scaleY = AppData.offsetScaleX;	
															
			var desertGrass:MC_desertGrass = new MC_desertGrass();
			desertGrass.scaleX = desertGrass.scaleY = AppData.offsetScaleX;	
																		
			var tree1:MC_tree1 = new MC_tree1();
			tree1.scaleX = tree1.scaleY = AppData.offsetScaleX;	
																					
			var tree2:MC_tree2 = new MC_tree2();
			tree2.scaleX = tree2.scaleY = AppData.offsetScaleX;	
																		
			var sign1:MC_sign1 = new MC_sign1();
			sign1.scaleX = sign1.scaleY = AppData.offsetScaleX;	
																					
			
			dtm.addItemToRaster(tree1, "tree1");
			dtm.addItemToRaster(tree2, "tree2");
			dtm.addItemToRaster(sign1, "sign1");
			dtm.addItemToRaster(desertGrass, "desertGrass");
			dtm.addItemToRaster(desertShrub, "desertShrub");
			dtm.addItemToRaster(sceneryRock1, "sceneryRock1");
			dtm.addItemToRaster(sceneryRock2, "sceneryRock2");
			dtm.addItemToRaster(tile_road, "tile_road");
			dtm.addItemToRaster(tile_terrain_orangeA, "tile_terrain_orangeA");
			dtm.addItemToRaster(tile_terrain_orangeB, "tile_terrain_orangeB");			
			dtm.addItemToRaster(tile_terrain_greenA, "tile_terrain_greenA");
			dtm.addItemToRaster(tile_terrain_greenB, "tile_terrain_greenB");
			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process( true, 1, PublicSettings.FLASH_IDE_COMPILE);	
			
			tile_road = null;

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