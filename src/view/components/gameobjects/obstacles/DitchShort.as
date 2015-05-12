package view.components.gameobjects.obstacles 
{



	import flash.geom.Point;
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
	public class DitchShort extends Obstacle
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "ditchShort";
		private var _vectors:Array = [new Point(-20, -44), //TL
									  new Point(50, -30),  //TR
									  new Point(-58, 42), //BL 
									  new Point(8, 60)] //BR

		//===================================o
		//-- Constructor
		//===================================o
		public function DitchShort() 
		{
			//map attributes to super
			super.type = _type;
			super.vectors = _vectors;
			super.init();
			//super();
		}
	}


}