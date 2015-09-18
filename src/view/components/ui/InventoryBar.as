package view.components.ui 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.xtdstudios.DMT.DMTBasic;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_GenericUI;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.dataObjects.ResourceData;
	import staticData.DeviceType;
	import staticData.GameData;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.gameobjects.mining.ore.MineOre;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class InventoryBar extends Sprite
	{
		private var _tf:TextField;
		private var _img:DisplayObject;
		private var _backing:Quad;
		private var _dtm:DMTBasic;
		private var _arrItems:Array;

		//=======================================o
		//-- Constructor <><><><><><><><><><><><>
		//=======================================o
		public function InventoryBar() 
		{
			trace(this + "Constructed");
			
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		//=======================================o
		//-- init \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
		//=======================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_arrItems = new Array();
			_backing = new Quad(AppData.deviceResX, 100, 0xCCCCCC);
			this.addChild(_backing);
			
			_dtm = new DMTBasic("inventoryBar", false);
			
			
			//add required assets to DTM to pass to InventortBarItems
			var itemBacking:MC_toolbarItem = new MC_toolbarItem();
			itemBacking.scaleX = itemBacking.scaleY = AppData.deviceScale;		
			_dtm.addItemToRaster(itemBacking, "itemBacking");
			
			var ore:MC_oreIcon = new MC_oreIcon();
			ore.scaleX = ore.scaleY = AppData.deviceScale;
			_dtm.addItemToRaster(ore, "ore");
									
			
			
			_dtm.addEventListener("complete", onProcessComplete);
			_dtm.process( true, 1, PublicSettings.FLASH_IDE_COMPILE);				


		}
		
		private function onProcessComplete(e:*):void 
		{
			loaded();
			
			
		}
		
		private function loaded():void 
		{
			
			//TODO  create array of Ore VO's from jSON and pass into loop
			for (var i:int = 0; i < ResourceData.arrOreMasterList.length; i++) 
			{
				var item:InventoryBarItem = new InventoryBarItem(ResourceData.arrOreMasterList[i],_dtm);
				item.x = i * 100;
				this.addChild(item);
				_arrItems.push(item);
			}	
		}

		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public  function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();

		}
		
		public function update():void 
		{
			_tf.text = String(GameData.currDistance);
		}
		
		public function addOre(ore:MineOre):void 
		{
			
		}
		
		public function getSlotForResource(ore:MineOre):void 
		{
			for (var i:int = 0; i < _arrItems.length; i++) 
			{
				if (InventoryBarItem(_arrItems[i]).vo.ref == ore.type)
				{
					trace("SLOT FOUND");
				}
			}
		}
		
		
	}

}