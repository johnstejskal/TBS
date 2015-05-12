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
	public class Sign1 extends SceneryObject
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "sign1";

		//===================================o
		//-- Constructor
		//===================================o
		public function Sign1() 
		{
			//map attributes to super
			super.type = _type;
			super.init();
		}
	}


}