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
	public class DitchLong extends Obstacle
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "ditchLong";
		private var _vectors:Array = [new Point(80, -225), //TL
									  new Point(126, -213),  //TR
									  new Point(-25, -6), //BL 
									  new Point(18, 4)] //BR

		//===================================o
		//-- Constructor
		//===================================o
		public function DitchLong() 
		{
			//map attributes to super
			super.type = _type;
			super.vectors = _vectors;
			super.init();
			
		}
	}


}