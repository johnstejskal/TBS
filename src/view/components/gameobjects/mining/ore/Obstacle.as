package view.components.gameobjects.mining.ore {

	import com.greensock.easing.Cubic;
	import com.greensock.easing.Power1;
	import com.greensock.plugins.DynamicPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
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
	import staticData.GameData;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.scenery.SceneryRock1;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	//==================================================================o
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==================================================================o
	public class Obstacle extends GameObject
	{
		public var type:String;
		static public const TYPE_OIL_SLICK:String = "oilSlick";
		static public const TYPE_SPEED_HUMP:String = "speedHump";
		private var _core:Core;


		private var _img:DisplayObject;
		
		private var _pointTL:DisplayObject;
		private var _pointTR:DisplayObject;
		private var _pointBL:DisplayObject;
		private var _pointBR:DisplayObject;
		
		private var _angle:Number;
		private var _isInCollRange:Boolean = false;
		private var _disX:Number;
		private var _disY:Number;
		private var _disTot:Number;
		private var _isCollected:Boolean = false;
		private var _hasCollided:Boolean = false;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Obstacle() 
		{
			_core = Core.getInstance();
			
		}
		
		public function init(e:Event = null ):void 
		{

			_img = DSpriteSheet_action.dtm.getAssetByUniqueAlias(type);
			this.addChild(_img);
			
			
			if (PublicSettings.SHOW_COLLISION_POINTS)
			{
				if (vectors)
				{
					 _pointTL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointTL.x = vectors[0].x; _pointTL.y = vectors[0].y;
					 _pointTR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointTR.x = vectors[1].x; _pointTR.y = vectors[1].y;
					 _pointBL = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointBL.x = vectors[2].x; _pointBL.y = vectors[2].y;
					 _pointBR = DSpriteSheet_action.dtm.getAssetByUniqueAlias("point");
					 _pointBR.x = vectors[3].x; _pointBR.y = vectors[3].y;
					 
					 this.addChild(_pointTL);
					 this.addChild(_pointTR);
					 this.addChild(_pointBL);
					 this.addChild(_pointBR);
				}
			}
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}

		
		override public function onUpdate(e:Event = null):void  
		{
			
			if (!GameData.isGameInPlay)
			return;
			
			if (!_isInCollRange)
			{
				//if (this.y < -720)
				_isInCollRange = true;

			}
			
			if (!_hasCollided)
			{
				//if obstacle has polygonal shape
				if (vectors != null)
				{
					
					//check all obstacle vectors against car
					for (var i:int = 0; i < 4; i++) 
					{
						if (_core.refPlayer.pointInPolygon(new Point(this.x + vectors[i].x, this.y + vectors[i].y)))
						{
							_hasCollided = true;
							_core.refPlayScreen.doCollision(type);
						}
					}
				}
				//simple single point collision
				else
				{
					if (_core.refPlayer.pointInPolygon(new Point(this.x, this.y)))
					{
						trace("HIT HIT HIT");
						_hasCollided = true;
						_core.refPlayScreen.doCollision(type);
					}
				}
				
			}
			
			//move object
			angle = Math.atan2(destinationY-this.y,destinationX-this.x)
			this.x += (Math.cos(angle) *  GameData.currentSpeed);
			this.y += (Math.sin(angle) *  GameData.currentSpeed);
			
			if (int(this.x) <= int(destinationX))
			{
				trash();
			}

		}
		
		private function onCrash():void 
		{
			trash();
		}
		
		override public function trash():void
		{
			
			//trace(this+" trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		

		
		
	}

}