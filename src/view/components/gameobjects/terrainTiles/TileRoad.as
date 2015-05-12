package view.components.gameobjects.terrainTiles 
{

	import ManagerClasses.AssetsManager;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_scenery;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.gameobjects.scenery.SceneryRock1;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TileRoad extends GameObject
	{
		private var _core:Core;

		private var _img:DisplayObject;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function TileRoad() 
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			//trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_img = DSpriteSheet_scenery.dtm.getAssetByUniqueAlias("tile_road");
			this.addChild(_img);
			
			//this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		

		
/*		override public function onUpdate(e:Event = null):void  
		{
			
		}*/
		
		override public function trash():void
		{
			//trace(this+" trash()")
			
		}
		
		
	}

}