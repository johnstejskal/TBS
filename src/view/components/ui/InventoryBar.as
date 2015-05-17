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
	import staticData.DeviceType;
	import staticData.GameData;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
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
			
			_backing = new Quad(AppData.deviceResX, 100, 0xCCCCCC);
			this.addChild(_backing);
			
			_dtm = new DMTBasic("inventoryBar", false);
			
			var item1:MC_toolbarItem = new MC_toolbarItem();
			item1.scaleX = item1.scaleY = AppData.deviceScale;		
			_dtm.addItemToRaster(item1, "item1");
			
			var item2:MC_toolbarItem = new MC_toolbarItem();
			item2.scaleX = item2.scaleY = AppData.deviceScale;		
			_dtm.addItemToRaster(item2, "item2");
						
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
			
			for (var i:int = 1; i < 3; i++) 
			{
/*				var item:InventoryBarItem = new InventoryBarItem();
				item.x = i * 100;
				this.addChild(item);*/
				var img:DisplayObject = _dtm.getAssetByUniqueAlias("item"+i);
				img.x = i * 100;
				this.addChild(img);		
				
				var ore:MovieClip = _dtm.getAssetByUniqueAlias("ore") as MovieClip;
				ore.currentFrame = i;
				ore.x = i * 100;
				this.addChild(ore);	
				
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
		
		
	}

}