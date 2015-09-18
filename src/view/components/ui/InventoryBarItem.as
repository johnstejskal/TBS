package view.components.ui 
{
	import com.xtdstudios.DMT.DMTBasic;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import staticData.valueObjects.OreVO;


	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class InventoryBarItem extends Sprite
	{
		private var _dmt:DMTBasic;
		private var _imgOre:MovieClip;
		private var _imgBacking:DisplayObject;
		private var _vo:OreVO;


		//=======================================o
		//-- Constructor <><><><><><><><><><><><>
		//=======================================o
		public function InventoryBarItem(vo:OreVO = null, dmt:DMTBasic = null) 
		{
			trace(this + "Constructed");
			_dmt = dmt;
			_vo = vo;
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
			
			_imgBacking = _dmt.getAssetByUniqueAlias("itemBacking");
			this.addChild(_imgBacking);			
			
			_imgOre = _dmt.getAssetByUniqueAlias("ore") as MovieClip;
			this.addChild(_imgOre);		
			
			_imgOre.currentFrame = 1;

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
		
		public function get vo():OreVO 
		{
			return _vo;
		}
		
		
		
	}

}