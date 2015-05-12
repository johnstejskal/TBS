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
	public class SceneryTree2 extends SceneryObject
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "tree2";

		//===================================o
		//-- Constructor
		//===================================o
		public function SceneryTree2() 
		{
			trace(this + "Constructed");
			
			//map attributes to super
			super.type = _type;
			super.init();
		}
	}


}