package view.components.gameobjects 
{

	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Maths;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.dataObjects.ShopData;
	import staticData.SpriteSheets;
	import staticData.valueObjects.powerUps.CoinMagnetVO;
	import staticData.valueObjects.powerUps.HeadGearVO;
	import staticData.valueObjects.powerUps.SlowDownVO;
	import view.components.gameobjects.superClass.ActionObjSuper;
	import view.components.gameobjects.superClass.GameObject;
	import view.components.gameobjects.superClass.EnemySuper;

	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class MysteryBox extends ActionObjSuper
	{
		
		private var _collisionArea:Quad;
		
		//images
		private var _quFill:Quad;
		private var _core:Core;
		
		private var _smcBox:MovieClip;
		private var _isColliding:Boolean = false;
		private var _powerUpType:String;


		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function MysteryBox() 
		{
			//super(this);
			
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);

			var graphic:String = "TA_mysteryBox";
			 trace("is santa equipped:"+_core.controlBus.inventoryController.checkIfItemEqiuippedByRef("santaSuit"));
			if (_core.controlBus.inventoryController.checkIfItemEqiuippedByRef("santaSuit"))
			{
			graphic = "TA_xmasBox";
			}
			
			_smcBox = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures(graphic), 6);
			_smcBox.pause();
			_smcBox.loop = true;
			_smcBox.scaleX = _smcBox.scaleY = AppData.deviceScaleX;
			_smcBox.x = -_smcBox.width / 2;
			_smcBox.y = -_smcBox.height / 2;
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		
		
		public override function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_core.animationJuggler.add(_smcBox)
			addChild(_smcBox);	
			_smcBox.play();
			

		}
		
		private function setType(array:Array):void 
		{
			
		}
		
		public override function onUpdate(e:Event = null):void 
		{
			if(AppData.isFreezePlay)
			return;
			
			this.y -= AppData.currSpeed
			this.rotation += .001;
			
			if (this.getBounds(core.refPlayScreen).intersects(core.refPlayer.quCollisionArea.getBounds(core.refPlayScreen)))
			{
				core.controlBus.powerupController.doPower();
				trash();

			}
				
			if (this.y <= -height)
			trash();
				
		}
		
		
		public function onCollision():void
		{
			if (_isColliding)
			return;
			
			_isColliding = true;

		}
		

		


		
		
	}

}