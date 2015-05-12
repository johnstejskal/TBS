package view.components.gameobjects.cars 
{

	import com.greensock.easing.Linear;
	import com.greensock.easing.Power1;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_action;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.Constants;
	import staticData.GameData;
	import staticData.settings.PublicSettings;
	import staticData.valueObjects.powerUps.CoinMagnetVO;
	import staticData.valueObjects.powerUps.NitroVO;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class Car extends GameObject
	{
		public var type:String;
		
		private var _core:Core;
		private var _img:DisplayObject;
		private var _angle:Number;
		private var _mcCarBody:MovieClip;
		private var _upgradeLevel:int;
		private var _mcSmokeL:MovieClip;
		private var _mcSmokeR:MovieClip;

		private var _ptFrontRight:Point;
		private var _ptFrontLeft:Point;
		private var _ptBackRight:Point;
		private var _ptBackLeft:Point;
		private var _pointTL:DisplayObject;
		private var _pointTR:DisplayObject;
		private var _pointBL:DisplayObject;
		private var _pointBR:DisplayObject;
		private var _holder:Sprite;
		private var _preNitroSpeed:int;
		private var _isBooting:Boolean = false;
		private var _isMagnet:Boolean = false;
		private var _mcNitroFlameL:MovieClip;
		private var _mcNitroFlameR:MovieClip;
		private var _isJumping:Boolean = false;
		private var _this:Car;
		private var _isGrounded:Boolean = true;
		private var _shadowRoad:DisplayObject;
		private var _shadowAir:DisplayObject;
		
		
		public var score:Number = 0;
		public var targetSpeed:Number = 20;		
		
		public var vertices:Array;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Car(upgradeLevel:int) 
		{
			
			_upgradeLevel = upgradeLevel;
			trace(this + "Constructed");
			_core = Core.getInstance();
			_core.refPlayer = this;
			_this = this;
			if (stage)
			init()
			else
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init():void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			_holder = new Sprite();
			_mcCarBody = DSpriteSheet_action.dtm.getAssetByUniqueAlias("car") as MovieClip;
			_holder.addChildAt(_mcCarBody, 0);
			_core.animationJuggler.add(_mcCarBody);
			_mcCarBody.loop = true;
			_mcCarBody.play(); 
			
			_shadowRoad = DSpriteSheet_action.dtm.getAssetByUniqueAlias("carShadowRoad");
			_shadowRoad.x = 34;
			_shadowRoad.y = 36;
			_holder.addChildAt(_shadowRoad, 0);
			
			_shadowAir = DSpriteSheet_action.dtm.getAssetByUniqueAlias("carShadowAir");

			
			
			_mcSmokeL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("smokeTrail") as MovieClip;
			_mcSmokeL.fps = 35;
			_mcSmokeL.x = -55;
			_mcSmokeL.y = 57;
			_mcSmokeL.scaleX = 1.5;
			_mcSmokeL.scaleY = 2;
			_holder.addChildAt(_mcSmokeL, 0);
			_core.animationJuggler.add(_mcSmokeL);
			_mcSmokeL.loop = false;
			_mcSmokeL.stop();
			_mcSmokeL.visible = false;
			
			_mcSmokeR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("smokeTrail") as MovieClip;
			_mcSmokeR.fps = 20;
			_mcSmokeR.x = 20;
			_mcSmokeR.y = 75;
			_mcSmokeR.scaleX = 1.5;
			_mcSmokeR.scaleY = 2;
			_holder.addChildAt(_mcSmokeR, 0);
			_core.animationJuggler.add(_mcSmokeR);
			_mcSmokeR.loop = false;
			_mcSmokeR.stop();
			_mcSmokeR.visible = false;
			

			
			collisionArea = new Quad(83, 80, 0xff00ff);
			collisionArea.pivotX = collisionArea.width / 2;
			collisionArea.pivotY = collisionArea.height / 2;
			collisionArea.x = 0;
			collisionArea.y = 20;
			collisionArea.visible = false;
			_holder.addChild(collisionArea);
			
			
			_mcNitroFlameL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("nitroFlame") as MovieClip;
			_mcNitroFlameL.fps = 25;
			_mcNitroFlameL.x = _mcCarBody.x -57;
			_mcNitroFlameL.y = _mcCarBody.y + 95;

			_holder.addChild(_mcNitroFlameL);
			_core.animationJuggler.add(_mcNitroFlameL);
			_mcNitroFlameL.loop = true;
			_mcNitroFlameL.stop();
			_mcNitroFlameL.visible = false;
						
			_mcNitroFlameR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("nitroFlame") as MovieClip;
			_mcNitroFlameR.fps = 25;
			_mcNitroFlameR.x = _mcCarBody.x -2;
			_mcNitroFlameR.y = _mcCarBody.y + 110.2;

			_holder.addChild(_mcNitroFlameR);
			_core.animationJuggler.add(_mcNitroFlameR);
			_mcNitroFlameR.loop = true;
			_mcNitroFlameR.stop();
			_mcNitroFlameR.visible = false;
			this.addChild(_holder);
			
			_ptFrontLeft = new Point(this.x+19, this.y-53);
			_ptFrontRight = new Point(this.x + 71, this.y -39);
			_ptBackLeft = new Point(this.x - 35, this.y + 65);
			_ptBackRight = new Point(this.x + 14, this.y+70);
			
			vertices = new Array(_ptFrontRight, _ptFrontLeft, _ptBackRight, _ptBackLeft);
			
			
			if (PublicSettings.SHOW_COLLISION_POINTS)
			{
				//if (vectors)
			//	{
					 _pointTL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointTL.x = _ptFrontLeft.x; _pointTL.y = _ptFrontLeft.y;
					 _pointTR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointTR.x =_ptFrontRight.x; _pointTR.y = _ptFrontRight.y;
					 _pointBL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointBL.x = _ptBackLeft.x; _pointBL.y = _ptBackLeft.y;
					 _pointBR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointBR.x = _ptBackRight.x; _pointBR.y = _ptBackRight.y;
					 
					 this.addChild(_pointTL);
					 this.addChild(_pointTR);
					 this.addChild(_pointBL);
					 this.addChild(_pointBR);
				//}
			}
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		
		override public function onUpdate(e:Event = null):void  
		{
			
			if (!GameData.isGameInPlay)
			return;
			
			_ptFrontLeft = new Point(this.x+19, this.y-53);
			_ptFrontRight = new Point(this.x + 71, this.y -39);
			_ptBackLeft = new Point(this.x - 35, this.y + 65);
			_ptBackRight = new Point(this.x + 14, this.y + 70);
			
/*			 _pointTL.x = _ptFrontLeft.x; _pointTL.y = _ptFrontLeft.y;;
			 _pointTR.x =_ptFrontRight.x; _pointTR.y = _ptFrontRight.y;
			 _pointBL.x = _ptBackLeft.x; _pointBL.y = _ptBackLeft.y;
			 _pointBR.x = _ptBackRight.x; _pointBR.y = _ptBackRight.y;*/
			 vertices = [_ptFrontRight, _ptFrontLeft, _ptBackRight, _ptBackLeft];
		}
		
		private function reset():void 
		{
			
		}
		
		public function startMovingCar():void
		{
			_shadowAir.x = this.x + 30;
			_shadowAir.y = this.y+ 30;
			_shadowAir.alpha = 1;	
			this.parent.addChildAt(_shadowAir, this.parent.getChildIndex(this) - 1);	
			speed = GameData.currentSpeed;
			TweenLite.to(this, .5, { speed:PublicSettings.BASE_GAME_SPEED, onUpdate:updateSpeed, ease:Linear.easeNone, onComplete:function():void {
			
			//base speed reached	
			}});
		}
		public function showSkidSmoke():void
		{
			_mcSmokeL.visible = true;
			_mcSmokeR.visible = true;
			_mcSmokeL.currentFrame = 0;
			_mcSmokeR.currentFrame = 0;
			_mcSmokeL.play();
			_mcSmokeR.play();
			
		}
		
		override public function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		public function doRotation(direction:String):void 
		{
			showSkidSmoke();
			if (direction == "left")
			{
				TweenMax.to(this, .1, { rotation:String(deg2rad( -4)), onComplete:resetRot } )
			}
			else
			{
				TweenMax.to(this, .1, { rotation:String(deg2rad( 4)), onComplete:resetRot } )	
			}
		}

		public function pointInPolygon(p:Point):Boolean
		{
			
			//_ptFrontLeft.x = this.x + 19; _ptFrontLeft.y = this.y - 53;
			//_ptFrontRight.x = this.x + 71; _ptFrontRight.y = this.y -39;
			//_ptBackLeft.x = this.x - 35; _ptBackLeft.y = this.y + 65;
			//_ptBackRight.x = this.x + 14; _ptBackRight.y = this.y + 70;
			
		//	vertices = [_ptFrontRight, _ptFrontLeft, _ptBackRight, _ptBackLeft];
			
			//Loop through vertices, check if point is left of each line.
			//If it is, check if it line intersects with horizontal ray from point p
			var n:int = vertices.length;
			var j:int;
			var v1:Point, v2:Point;
			var count:int;
			for (var i:int = 0; i < n; i++)
			{
				j = i + 1 == n ? 0: i + 1;
				v1 = vertices[i];
				v2 = vertices[j];
				//does point lay to the left of the line?
				if (isLeft(p,v1,v2))
				{
					if ((p.y > v1.y && p.y <= v2.y) || (p.y > v2.y && p.y <= v1.y))
					{
						count++;
					}
				}
			}
			if (count % 2 == 0)
			{
				return false;
			}else
			{
				return true;
			}
		}	
		
		public function isLeft(p:Point, v1:Point, v2:Point):Boolean
		{
			if (v1.x == v2.x)
			{
				if (p.x <= v1.x)
				{
					return true;
				}else
				{
					return false;
				}
			}else
			{
				var m:Number = (v2.y - v1.y) / (v2.x - v1.x);
				var x2:Number = (p.y - v1.y) / m + v1.x;
				if (p.x <= x2)
				{
					return true;
				}else
				{
					return false;
				}
			}
		}
		
		public function doSlide():void 
		{
			if (GameData.isSliding)
			return;
			
			GameData.currLaneChangeSpeed = 1;
			GameData.isSliding = true;
			
			var _this:Car = this;
			TweenMax.to(_holder, 0.4, { rotation:String(deg2rad( -2)), x:"-20", y:"0", ease:Linear.easeNone, onComplete:function():void{
				
				TweenMax.to(_holder, 0.4, { rotation:String(deg2rad( 2)), x:"40", y:"0", ease:Linear.easeNone, onComplete:function():void{
				
				   TweenMax.to(_holder, 0.4, { rotation:String(deg2rad( -2)), x:"-40", y:"0", ease:Linear.easeNone, onComplete:function():void{
				
					   	TweenMax.to(_holder, 0.4, { rotation:String(deg2rad( 2)), x:"40", y:"0", ease:Linear.easeNone, onComplete:function():void{
				
							TweenMax.to(_holder, 0.4, { rotation:String(deg2rad( 0)), x:"-20", y:"0", ease:Linear.easeNone, onComplete:endSlide})
				
						}})
					}})
		
				}});
			
			}})
		}
		
		public function doNitro():void 
		{
			if (_isBooting)
			return;
			TweenMax.killDelayedCallsTo(endNitro);
			_isBooting = true;
			
			_mcNitroFlameL.alpha = 0;
			_mcNitroFlameR.alpha = 0;
			_mcNitroFlameL.visible = true;
			_mcNitroFlameR.visible = true;
			TweenLite.to(_mcNitroFlameL, .1, {alpha:1})
			TweenLite.to(_mcNitroFlameR, .1, {alpha:1})
			
			_mcNitroFlameL.play();
			_mcNitroFlameR.play();
			
			_preNitroSpeed = GameData.currentSpeed;
			//GameData.currentSpeed = PublicSettings.NITRO_SPEED;
			TweenMax.delayedCall(NitroVO.CURRENT_LEVEL * 4, endNitro);
			speed = GameData.currentSpeed;
			TweenLite.to(this, 1, {speed:PublicSettings.NITRO_SPEED, onUpdate:updateSpeed, ease:Linear.easeNone});
		}
		

		public function updateSpeed(){

		GameData.currentSpeed = int(speed);
		}
		
		public function doMagnet():void 
		{
			_isMagnet = true;
			TweenMax.delayedCall(CoinMagnetVO.CURRENT_LEVEL * 4, endMagnet);
		}
		
		public function doJump():void 
		{
			var speedPerc:Number = GameData.currentSpeed / PublicSettings.MAX_SPEED;
			var moveX:Number = speedPerc * 100;
			var moveY:Number = speedPerc * 300;
			var ascendTime:Number = speedPerc * 1;
			_isGrounded = false;
			
			TweenMax.to(_shadowRoad, .1, { alpha:0 } )

			
			_shadowAir.x = this.x + 30;
			_shadowAir.y = this.y+ 30;
			_shadowAir.alpha = 1;		
			
			TweenMax.to(_shadowRoad, .1, { alpha:0 } )
			TweenMax.to(_shadowAir, ascendTime, { scaleX:.8, scaleY:.8 } )
			TweenMax.to(_holder, .1, { rotation:String(deg2rad( -4))} )
			
			TweenMax.to(this, ascendTime , { x:String(-moveX), y:String(-moveY), ease:Power1.easeInOut, onComplete:doAirTime})
			
		}
		
		private function doAirTime():void 
		{	
			var speedPerc:Number = GameData.currentSpeed / PublicSettings.MAX_SPEED;
			var hangTime:Number = speedPerc * .1
			var descendTime:Number = speedPerc * .5;
			var moveX:Number = speedPerc * 100;
			var moveY:Number = speedPerc * 300;
			
			TweenMax.to(_shadowAir, descendTime, { delay:hangTime, scaleX:1, scaleY:1 } )
			TweenMax.to(_this, descendTime, {delay:hangTime, x:String(moveX), y:String(moveY), ease:Power1.easeIn, onComplete:function():void 
			{
					showSkidSmoke();
					TweenMax.to(_holder, .1, { rotation:deg2rad(0) } )
					TweenMax.to(_shadowRoad, .2, { alpha:1 } )
					TweenMax.to(_shadowAir, .1, { alpha:0 } )
					
					TweenMax.to(_this, .1, { x:"-10", y:"-10", ease:Power1.easeIn, onComplete:function():void
					{
						TweenMax.to(_this, .1, { x:"10", y:"10", ease:Power1.easeIn, onComplete:function():void
						{
							
							_isGrounded = true;
						}})
					}})
				
				
			}})
		}
		
		private function endMagnet():void 
		{
			_isMagnet = false;
		}
		
		private function endNitro():void 
		{
			
			TweenLite.to(_mcNitroFlameR, .1, { alpha:0})
			TweenLite.to(_mcNitroFlameL, .1, { alpha:0, onComplete:function():void {
				_mcNitroFlameL.visible = false;
				_mcNitroFlameR.visible = false;		
				_mcNitroFlameL.stop();
				_mcNitroFlameR.stop();
			}})
			

			
			//GameData.currentSpeed = _preNitroSpeed;
			TweenLite.to(this, 1, {speed:_preNitroSpeed, onUpdate:updateSpeed, ease:Linear.easeNone, onComplete:function():void{_isBooting = false;}});
		}
		
		private function endSlide():void 
		{
			resetRot();
			GameData.isSliding = false;
			GameData.currLaneChangeSpeed = 0.4;
		}
				
		private function resetRot():void 
		{
			TweenMax.to(this, .1, { delay:.2, rotation:deg2rad(0)} )	
		}
		
		public function get isMagnet():Boolean 
		{
			return _isMagnet;
		}
		
		public function set isMagnet(value:Boolean):void 
		{
			_isMagnet = value;
		}
		
		public function get isGrounded():Boolean 
		{
			return _isGrounded;
		}
		
	}

}