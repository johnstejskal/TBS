package view.components.gameobjects.collectables 
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
	public class CoinStack extends Collectable
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "coinStack";
		private var _vectors:Array = null

		//===================================o
		//-- Constructor
		//===================================o
		public function CoinStack() 
		{
			//map attributes to super
			super.type = _type;
			super.vectors = _vectors;
			super.init();
	
		}
	}


}