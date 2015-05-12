package view.components.gameobjects 
{

	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.plugins.DynamicPropsPlugin;
	import com.greensock.TweenMax;
	import com.johnstejskal.Maths;
	import ManagerClasses.ObjectPools.ObjPool_Coin;
	import ManagerClasses.ObjectPools.ObjPool_Misc;
	import staticData.Inventory;
	import staticData.Sounds;
	import staticData.valueObjects.powerUps.CoinDoubleVO;
	import treefortress.sound.SoundAS;

	import com.johnstejskal.ArrayUtil;
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
	import staticData.SpriteSheets;
	import view.components.gameobjects.superClass.ActionObjSuper;
	import view.components.gameobjects.superClass.GameObject;
	import view.components.gameobjects.superClass.EnemySuper;
	
	//=========================================o
	/**
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	//=========================================o
	
	public class ImpactBlast extends GameObject
	{
		
		private var _collisionArea:Quad;
		
		private var _quFill:Quad;
		private var _core:Core;
		private var _disX:Number;
		private var _disY:Number;
		private var _disTot:Number;
		private var _isCollected:Boolean = false;

		private var _smcIdle:MovieClip;
		private var _isInCollRange:Boolean;
		private var _simBlast1:Image;
		private var _simBlast2:Image;
		private var _simBlast3:Image;
		private var _simBlast4:Image;
		private var _baseScale:Number;


		//=========================================o
		//-- Constructor
		//=========================================o
		public function ImpactBlast()
		{
			TweenPlugin.activate([DynamicPropsPlugin]);
			_core = Core.getInstance();
			
			_simBlast1 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_blast10000"));
			_simBlast1.pivotX = _simBlast1.width / 2;
			_simBlast1.pivotY = _simBlast1.height / 2;
			this.addChild(_simBlast1)
			
			_simBlast2 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_blast20000"));
			_simBlast2.pivotX = _simBlast2.width / 2;
			_simBlast2.pivotY = _simBlast2.height / 2;
			this.addChild(_simBlast2)	
						
			_simBlast3 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_blast30000"));
			_simBlast3.pivotX = _simBlast3.width / 2;
			_simBlast3.pivotY = _simBlast3.height / 2;
			this.addChild(_simBlast3)	
									
			_simBlast4 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_blast40000"));
			_simBlast4.pivotX = _simBlast4.width / 2;
			_simBlast4.pivotY = _simBlast4.height / 2;
			this.addChild(_simBlast4)	
			
			
			_simBlast1.scaleX = _simBlast1.scaleY = .1;
			_simBlast2.scaleX = _simBlast2.scaleY = .1;
			_simBlast3.scaleX = _simBlast3.scaleY = .1;
			_simBlast4.scaleX = _simBlast4.scaleY = .1;
			
			_baseScale = Math.abs(this.scaleX - AppData.deviceScaleX);

		}
		
		//=========================================o
		//-- init
		//=========================================o		
		public function init():void 
		{

			
		}

		//=========================================o
		//  On UPDATE Overrides ActionObjSuper
		//=========================================o	
		public override function onUpdate(e:Event = null):void
		{
			if(AppData.isFreezePlay || _isCollected)
			return;
			
			this.y -= AppData.currSpeed/2
			

		}

		//=========================================o
		//-- Override Activate
		//=========================================o
		public override function activate():void
		{
			isActive = true;
			AppData.arrActionObjects.push(this);
						
			_simBlast1.rotation = 0.1;
			_simBlast2.rotation = 0.2;
			_simBlast3.rotation = 0.3;
			_simBlast4.rotation = 0.4;
			TweenLite.to(_simBlast1, .1, {scaleX:1, scaleY:1})
			TweenLite.to(_simBlast2, .1, {delay:.05,scaleX:1, scaleY:1})
			TweenLite.to(_simBlast3, .1, {delay:.1,scaleX:1, scaleY:1})
			TweenLite.to(_simBlast4, .1, { delay:.15, scaleX:1, scaleY:1 } )
			TweenLite.to(this, .1, { delay:.16, alpha:0, onComplete:deactivate } )
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		
		//=========================================o
		//-- Override Deactivate
		//=========================================o
		public override function deactivate():void
		{
			isActive = false;
			
			_simBlast1.scaleX = _simBlast1.scaleY = .1;
			_simBlast2.scaleX = _simBlast2.scaleY = .1;
			_simBlast3.scaleX = _simBlast3.scaleY = .1;
			_simBlast4.scaleX = _simBlast4.scaleY = .1;
			this.alpha = 1;
			
 			returnToObjPool();
		}
		

		
		//=========================================o
		//-- Return to Object Pool
		//=========================================o	
		public function returnToObjPool():void
		{
			this.removeEventListeners();
			ObjPool_Misc.addToPool(this);
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			this.removeFromParent();

		}
		
		//=========================================o
		//-- kill/dispose/destroy
		//=========================================o
		public override function trash():void
		{
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			deactivate();
			this.removeEventListeners();
			this.removeFromParent();
		}


		
		
	}

}