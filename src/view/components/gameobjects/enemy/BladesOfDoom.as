package view.components.gameobjects.enemy 
{


	import ManagerClasses.ObjectPools.ObjPool_Obstacle;
	import starling.core.Starling;
	import starling.utils.deg2rad;
	import view.components.gameobjects.superClass.Enemy;

	//===================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//===================================o
	public class BladesOfDoom extends Enemy
	{

		private var _objectPoolRef:Class = ObjPool_Obstacle;
		private var _type:String = "bladesOfDoom";
		private var _obstacleName:String = "bladesOfDoom";
		private var _flockType:String = Enemy.FLOCK_TYPE_SPINNER;
		private var _collisionWidth:Number = 40;
		private var _collisionHeight:Number = 40;
		private var _weight:Number = 1.5;
		private var _fps:int = 25;
		private var _rotationRate:Number = .01; //rotation rate in radians


		//===================================o
		//-- Constructor
		//===================================o
		public function BladesOfDoom() 
		{
			trace(this + "Constructed");
			
			//map attributes to super
			super.objectPoolRef = _objectPoolRef;
			super.type = _type;
			super.obstacleName = _obstacleName;
			super.flockType = _flockType;
			super.collisionWidth = _collisionWidth;
			super.collisionHeight = _collisionHeight;
			super.weight = _weight;
			super.fps = _fps;
			super.rotationRate = _rotationRate
			super.init();
		}
	}


}