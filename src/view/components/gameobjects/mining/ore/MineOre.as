package view.components.gameobjects.mining.ore {
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import starling.display.DisplayObject;


	
	//==================================================================o
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==================================================================o
	public class MineOre extends Ore
	{
		public var type:String;



		private var _img:DisplayObject;
		

		//============================================o
		//-- Constructor  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		//============================================o
		public function MineOre() 
		{
			_core = Core.getInstance();
			
		}
		
		public function init(e:Event = null ):void 
		{

			_img = DSpriteSheet_mining.dtm.getAssetByUniqueAlias(type);
			this.addChild(_img);
			
			
		}

		override public function trash():void
		{
			
			//trace(this+" trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		

		
		
	}

}