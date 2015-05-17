package view.components.ui 
{
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;


	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class InventoryBarItem extends Sprite
	{
		private var _img:DisplayObject;


		//=======================================o
		//-- Constructor <><><><><><><><><><><><>
		//=======================================o
		public function InventoryBarItem() 
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
			
			_img = DSpriteSheet_mining.dtm.getAssetByUniqueAlias("toolBarItem");
			this.addChild(_img);			

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
		
		
		
	}

}