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
	public class ActionObjSuper extends GameObject
	{
		private var _child:*;



		
		public static const TYPE_ENEMY:String ="typeEnemy";
		public static const TYPE_POWERUP:String ="typePowerUp";
		public var core:Core;
		public var type:String;
		

		
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function ActionObjSuper(child:* = null) 
		{
			core = Core.getInstance();
			if (child)_child = child;
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void 
		{
			trace(this + "inited act");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
		//-----------------------------o
		//-- Override Activate
		//-----------------------------o
		public override function activate():void
		{
			super.isActive = true;
			//this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		
		//-----------------------------o
		//-- Override Deactivate
		//-----------------------------o
		public override function deactivate():void
		{
			super.isActive = false;
			this.removeEventListeners();
			//this.x = 300; 
			this.y = -200; 	
			returnToPool();
		}
		
		//-----------------------------o
		//-- Override onUpdate
		//-----------------------------o
		public override function onUpdate(e:Event = null):void 
		{
			trace(this + "onUpdate act");
			
			if(AppData.isFreezePlay)
			return;
			
			if(!AppData.isBoosting)
			this.y -= AppData.currSpeed;
			else
			this.y -= AppData.currBoostSpeed;
			
		
			
			//TODO add collision box if required
			if (this.getBounds(core.refPlayScreen).intersects(core.refPlayer.getBounds(core.refPlayScreen)))
			{
				
			if (_child)
			_child.onCollision();
			else
			deactivate();
			}
				
			if (this.y <= -height)
			deactivate();
				
		}
		//-----------------------------o
		//-- Return to object pool
		//-----------------------------o
		
		public override function trash():void
		{
			if (!this.parent)
			return;
			
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			this.removeEventListeners();
			this.removeFromParent();			
		}
		
		public function returnToPool():void	
		{
			//ObjPool_Obstacle.addToPool(this);
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			//deactivate();

		}
		

		
		
	}

}