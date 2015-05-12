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
	public class SpeedHump extends Obstacle
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "speedHump";
		private var _vectors:Array = null;/* [new Point( -15, -30), //TL
									  new Point(33, -19),  //TR
									  new Point(-40, 12), //BL 
									  new Point(14, 26)] //BR*/

		//===================================o
		//-- Constructor
		//===================================o
		public function SpeedHump() 
		{
			//map attributes to super
			super.type = _type;
			super.vectors = _vectors;
			super.init();
			//super();
		}
	}


}