package view.components.gameobjects.superClass 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Maths;
	import flash.geom.Point;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.ObjectPools.ObjPool_Obstacle;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.settings.PublicSettings;
	import staticData.Sounds;
	import staticData.SpriteSheets;
	import staticData.valueObjects.obstacles.VO_Enemy1;
	import staticData.valueObjects.obstacles.VO_Enemy2;
	import treefortress.sound.SoundAS;

	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Enemy extends Sprite
	{
		
		public static const FLOCK_TYPE_STATIC:String = "flockTypeStatic";
		public static const FLOCK_TYPE_FLOAT:String = "flockTypeFloat";
		public static const FLOCK_TYPE_FLY:String = "flockTypeFly";
		public static const FLOCK_TYPE_WOBBLE:String = "flockTypeWobble";
		public static const FLOCK_TYPE_HOMING:String = "flockTypeWobble";
		public static const FLOCK_TYPE_SPINNER:String = "flockTypeSpinner";
		
		//Enemy Action states when they become agro
		public static const ACTION_TYPE_CHASE:String = "ActionTypeChase";
		public static const ACTION_TYPE_POP:String = "ActionTypePop";

		
		
		
		var radians:Number = 180/Math.PI;
		
		private var _quFill:Quad;
		public var _quCollisionBox:Quad;
		
		//animation states
		private var _smcIdle:MovieClip;
		private var _isAgro:Boolean = false;
		private var _simToast:Image;
		private var _hasCollided:Boolean;

		public var core:Core;
		public var type:String;
		public var isActive:Boolean;
		
		public var objectPoolRef:Class;
		public var flockType:String;
		public var rotationRate:Number = 0;
		public var obstacleName:String;
		public var collisionWidth:int;
		public var collisionHeight:int;
		public var isInCollRange:Boolean;
		public var loops:Boolean = true;
		
		public var agroRange:int = 0;
		public var actionType:String;
		
		public var weight:Number;
		public var fps:int;
		
		private var _this:Enemy
		private var _isFollow:Boolean = false;
		

		//================================o
		//-- Constructor
		//================================o
		public function Enemy() 
		{
			core = Core.getInstance();
			
		}
		
		public function init():void 
		{
			_this = this;
			
			_quCollisionBox = new Quad(collisionWidth, collisionHeight, 0x000000);
			_quCollisionBox.pivotX = _quCollisionBox.width / 2;
			_quCollisionBox.pivotY = _quCollisionBox.height / 2;
			
			if(PublicSettings.SHOW_COLLISION_BOX)
			_quCollisionBox.visible = true;
			else
			_quCollisionBox.visible = false;
			
			this.addChild(_quCollisionBox);	
				

			//_smcIdle = MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_"+obstacleName), 12);
			_smcIdle = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_"+obstacleName), fps);
			_smcIdle.pivotX = _smcIdle.width / 2;
			_smcIdle.pivotY = _smcIdle.height / 2;
			_smcIdle.loop = loops;
			_smcIdle.pause();
			this.addChild(_smcIdle)
			
			this.scaleX = this.scaleY = AppData.deviceScaleX;
		}
		
		//================================o
		//-- Override Activate
		//================================o
		public function activate():void
		{
			isActive = true;
			_hasCollided = false;
			
			if (type != "toaster")
			{
				_smcIdle.play();
			}
			else 
			{
				_simToast = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_toast0000"));
				_simToast.pivotX = _simToast.width / 2;
				_simToast.pivotY = _simToast.height / 2;
				this.addChildAt(_simToast, 0);		
			}
			
			isInCollRange = false;
			if(!this.hasEventListener(Event.ENTER_FRAME))
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
			if (type == "toast"){
			_simToast.removeFromParent();
			_simToast.x = _simToast.y = 0;
			}
			
			//----------------------------------o
			//-- flocking behaviour
			switch(flockType)
			{
				//---------------------------------o
				case FLOCK_TYPE_STATIC:
				break;
				//---------------------------------o
				case FLOCK_TYPE_WOBBLE:
				TweenMax.to(this, 1, { delay:Maths.randomFloat(0,.2), x:"100", rotation:-.1,  yoyo:true, repeat: -1, ease:Linear.easeNone } )
				break;		
				//---------------------------------o
				case FLOCK_TYPE_FLOAT:
				var dist:String = "100"
				if (this.x > AppData.deviceResX / 2)
				dist = "-100";
				TweenMax.to(this, 3, { x:dist, rotation:-.1,  yoyo:true, repeat: -1, ease:Cubic.easeInOut } )
				break;
				//---------------------------------o
				case FLOCK_TYPE_FLY:
				if (this.x > AppData.deviceResX / 2)
				{
				this.x = AppData.deviceResX + 100;	
				TweenMax.to(this, 3, {delay:Maths.randomFloat(.1, .3), x: -100, ease:Linear.easeNone } )
				}else 
				{
				this.scaleX = -1;
				this.x = - 100;	
				TweenMax.to(this, 3, {delay:Maths.randomFloat(.1, .3), x: AppData.deviceResX + 100, ease:Linear.easeNone } )
				}
				break;
				//---------------------------------o
				case FLOCK_TYPE_SPINNER:
				TweenMax.to(this, 1, { delay:.1, rotation:"10", ease:Cubic.easeInOut } )
				break;				

			}
			//---------------------------------o
			core.animationJuggler.add(_smcIdle);
		}
		
		//================================o
		//-- Override Deactivate
		//================================o
		public function deactivate():void
		{

			_isAgro = false
			isActive = false;
			_smcIdle.pause();
			_smcIdle.currentFrame = 0;
			this.y = -200; 
			isInCollRange = false
			core.animationJuggler.remove(_smcIdle);
			returnToPool();
			

			
		}
		
		//================================o
		//-- Override onUpdate
		//================================o
		public function onUpdate(e:Event = null):void 
		{
			
			if(AppData.isFreezePlay || !isActive)
			return;
			
			this.y -= weight* AppData.currSpeed;

			if (!isInCollRange)
			{
				if (this.y < AppData.deviceResY / 2)
				isInCollRange = true;
			}
			
			if (rotationRate != 0)
			rotation += rotationRate;
			
			if (isInCollRange && !_hasCollided)
			{
				//TODO add collision box if required
				if (this._quCollisionBox.getBounds(core.refPlayScreen).intersects(core.refPlayScreen.oPlayer.quCollisionArea.getBounds(core.refPlayScreen)))
				{
					if(!core.refPlayScreen.oPlayer.isRecovering)
					returnToPool();
					EventBus.getInstance().sigCollision.dispatch(type);
					
					AppData.currDiveMobsKill ++;
					SoundAS.playFx(Sounds.SFX_IMPACT);
					
					if(obstacleName == "bladesOfDoom")
					SoundAS.playFx(Sounds.SFX_BLADE);
					else if (obstacleName == "gymCactus")
					SoundAS.playFx(Sounds.SFX_CACTUS);
					else if (obstacleName == "screamingGoat")
					SoundAS.playFx(Sounds.SFX_GOAT);	
					else if (obstacleName == "ironingBoard")
					SoundAS.playFx(Sounds.SFX_METAL_HIT);						
					else if (obstacleName == "hipsterDuck")
					SoundAS.playFx(Sounds.SFX_DUCK);
					else if (obstacleName == "hairDryer")
					SoundAS.playFx(Sounds.SFX_ZAP);		
					else if (obstacleName == "echidna")
					SoundAS.playFx(Sounds.SFX_ECHIDNA);		
					
					_hasCollided = true;
					return;
				}
			}
			
			//===================================o
			// if is in agro and mob agro range has been set
			if (this.agroRange != 0)
			{
				if (!_isAgro)
				{

					if(Maths.checkIfWhithinRadius(this, new Point(core.refPlayer.x, core.refPlayer.y), agroRange))
					{
						_isAgro = true;
						doAction();
					}
				}
			}
				
			if (this.y <= -height)
			deactivate();
			
		
		}
		
		private function doAction():void 
		{
			_smcIdle.play();
			core.refPlayScreen.addBread(this.x, this.y);
			
/*			_simToast.x = 0;
			_simToast.y = 0;
			TweenLite.to(_simToast, .2, { y: "-50", onComplete:function():void {
				
				_simToast.removeFromParent();
				core.refPlayScreen.addBread(_this.x, this.y - 50);
				//doFollow();
				
				
				
			}})*/


		}
		


		//================================o
		//-- Return to object pool
		//================================o		
		public function trash():void
		{
			if (!this.parent)
			return;
			
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			this.removeEventListeners();
			this.removeFromParent();			
		}
		
		//================================o
		//-- Return to object pool
		//================================o
		public function returnToPool():void	
		{
			this.removeEventListeners();
			ObjPool_Obstacle.addToPool(this);
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			this.removeFromParent();

		}
		
		public function get hasCollided():Boolean 
		{
			return _hasCollided;
		}
		
		public function set hasCollided(value:Boolean):void 
		{
			_hasCollided = value;
		}
		

		
		
	}

}