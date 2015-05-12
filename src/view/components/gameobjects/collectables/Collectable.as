package view.components.gameobjects.collectables 
{

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
	import view.components.gameobjects.scenery.SceneryRock1;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class Collectable extends GameObject
	{
		public var type:String;
		static public const TYPE_COIN:String = "coin";
		static public const TYPE_NITRO:String = "nitro";
		static public const TYPE_MAGNET:String = "magnet";
		private var _core:Core;

		private var _img:DisplayObject;
		private var _angle:Number;
		private var _isInCollRange:Boolean = false;
		private var _disX:Number;
		private var _disY:Number;
		private var _disTot:Number;
		private var _isCollected:Boolean = false;
		private var _this:Collectable;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Collectable() 
		{
			TweenPlugin.activate([DynamicPropsPlugin]);
			//trace(this + "Constructed");
			_core = Core.getInstance();
			_this = this;
			//if (stage) init(null);
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null ):void 
		{
			//trace(this + "inited");
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_img = DSpriteSheet_action.dtm.getAssetByUniqueAlias(type);
			this.addChild(_img);
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		

		
		override public function onUpdate(e:Event = null):void  
		{
			if (_isCollected)
			return;		
			
			//----------------------o
			// -- Collision 
			//----------------------o
			//Collision system triangulates vectors within a polygon
			if (vectors != null)
			{
				for (var i:int = 0; i < 4; i++) 
				{
					if (_core.refPlayer.pointInPolygon(new Point(vectors[i].x, vectors[i].y)))
					{
					onCollect();
					return;
					}
				}
			}
			else
			{
				if (_core.refPlayer.pointInPolygon(new Point(this.x, this.y)))
				{
				onCollect();
				return;
				}
			}

			//back up collision incase the first method fails
			if (this.getBounds(_core.refPlayScreen).intersects(_core.refPlayer.collisionArea.getBounds(_core.refPlayScreen)))
			{
			  onCollect(); 
			  return;
			}
			
			var isCoinMagnet:Boolean = true;
			
			//------------------------------------o
			// -- Coin magnet is ACTIVE, use distance collision and coin magnet
			//------------------------------------o	
			//if (_core.controlBus.powerupController.isCoinMagnet)
			if (type == TYPE_COIN)
			{
				if (_core.refPlayer.isMagnet)
				{
					_disX = _core.refPlayer.x - (this.x)
					_disY = _core.refPlayer.y - (this.y)

					//get total distance as one number
					_disTot = Math.sqrt(_disX * _disX + _disY * _disY);
					
					if (_disTot < AppData.deviceScaleX*300)
					{
						_isCollected = true;

						TweenMax.to(this, .5, { dynamicProps: { x:getPosX, y:getPosY }, repeat:0, ease:Power1.easeInOut, onComplete:function():void { onCollect(); return; }} );
						function getPosX():Number {
							return _core.refPlayer.x;
						}	
										
						function getPosY():Number {
								return _core.refPlayer.y;
						}	
					}
				}
			}
			
			

			//---------------------------------------o
			//move object down the road			
			//---------------------------------------o
			_angle = Math.atan2(destinationY-this.y,destinationX-this.x)
			this.x += (Math.cos(_angle) *  GameData.currentSpeed);
			this.y += (Math.sin(_angle) *  GameData.currentSpeed);
			
			if (int(this.x) <= int(destinationX))
			{
			trash();
			}
		}
		
		private function onCollect():void 
		{
			_core.refPlayScreen.onItemCollected(type);
			_isCollected = true;
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