package view.components.gameobjects.terrainTiles 
{



	import starling.core.Starling;
	import starling.utils.deg2rad;
	import staticData.settings.PublicSettings;

	//===================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//===================================o
	public class TileOrangeA extends TerrainTile
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "orangeA";
		private var _environment:String = "desert";		

		//===================================o
		//-- Constructor
		//===================================o
		public function TileOrangeA() 
		{
			trace(this + "Constructed");
			
			//map attributes to super
			super.type = _type;
			super.environment = _environment;			
			super.init();
		}
	}


}