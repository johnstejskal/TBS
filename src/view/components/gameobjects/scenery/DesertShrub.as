package view.components.gameobjects.scenery 
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
	public class DesertShrub extends SceneryObject
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "desertShrub";

		//===================================o
		//-- Constructor
		//===================================o
		public function DesertShrub() 
		{
			//map attributes to super
			super.type = _type;
			super.init();
		}
	}


}