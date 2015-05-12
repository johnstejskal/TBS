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
	public class PotHole extends Obstacle
	{
		//private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "potHole";
		private var _vectors:Array = [new Point(-18, -31), //TL
									  new Point(34, -18),  //TR
									  new Point(-36, 14), //BL 
									  new Point(18, 26)] //BR

		//===================================o
		//-- Constructor
		//===================================o
		public function PotHole() 
		{
			//map attributes to super
			super.type = _type;
			super.vectors = _vectors;
			super.init();
			//super();
		}
	}


}