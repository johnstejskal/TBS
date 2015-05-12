package view.components.gameobjects.superClass 
{

	import com.johnstejskal.ArrayUtil;
	import ManagerClasses.ObjectPools.ObjPool_Obstacle;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.valueObjects.obstacles.VO_Enemy1;
	import staticData.valueObjects.obstacles.VO_Enemy2;

	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class EnemySuper extends Sprite
	{
		
		//------------------- Animation States -----------------------------o
		public static const STATE_IDLE:String = "idle";		
		public static const STATE_ACTION:String = "action";
		static public const STATE_DIE:String = "die";
		
		static public const FLOCK_TYPE_RANGED:String = "ranged";
		static public const FLOCK_TYPE_MELEE:String = "melee";		
		static public const FLOCK_TYPE_COWARD:String = "coward";
		
		
		static public const E1:String = "e1";
		static public const E2:String = "e2";
		static public const E3:String = "e3";
		static public const E4:String = "e4";
		static public const E5:String = "e5";
		
		static public const MOVE_TYPE_STATIC:String = "moveTypeStatic";
		static public const MOVE_TYPE_WOBBLE:String = "moveTypeWobble";
		static public const MOVE_TYPE_FLYINOUT:String = "moveTypeFlyInOut";
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function EnemySuper() 
		{

			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void 
		{
			trace(this + "inited Enem");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//super.activate() addsEventListener Event.onUpdate
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		public function getColour():uint
		{
			var colour:uint;
			if (type == E1)
			colour = VO_Enemy1.COLOUR;
			else if (type == E2)
			colour = VO_Enemy2.COLOUR;
			
			return colour;
		}

		
		public  function onUpdate(e:Event = null):void 
		{
			//trace(this + " onUpdate enm");
			
			if(AppData.isFreezePlay || !super.isActive)
			return;
			
			if(!AppData.isBoosting)
			this.y -= AppData.currSpeed;
			else
			this.y -= AppData.currBoostSpeed;
			
			
			//TODO add collision box if required
/*				if (this.getBounds(super.core.refPlayScreen).intersects(super.core.refPlayer.getBounds(super.core.refPlayScreen)))
				{
				super.returnToPool();
				}*/
				
				if (this.y <= -height)
				returnToPool();
				
		}
		private function returnToPool():void	
		{
			ObjPool_Obstacle.addToPool(this);
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			deactivate();

		}
		
	}

}