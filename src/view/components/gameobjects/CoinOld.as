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
	
	public class CoinOld extends Sprite
	{
		
		private var _collisionArea:Quad;
		
		private var _quFill:Quad;
		private var _core:Core;
		private var _disX:Number;
		private var _disY:Number;
		private var _disTot:Number;
		private var _isCollected:Boolean = false;
		private var _isActive:Boolean = false;
		private var _smcIdle:MovieClip;
		private var _isInCollRange:Boolean;


		//=========================================o
		//-- Constructor
		//=========================================o
		public function CoinOld()
		{
			TweenPlugin.activate([DynamicPropsPlugin]);
			_core = Core.getInstance();
			
			_smcIdle = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_coin"), 25);
			_smcIdle.pivotX = _smcIdle.width / 2;
			_smcIdle.pivotY = _smcIdle.height / 2;
			_smcIdle.loop = true;
			_smcIdle.pause();
			this.addChild(_smcIdle)
			_core.animationJuggler.add(_smcIdle);
			
			this.scaleX = this.scaleY = AppData.deviceScaleX;

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
		public function onUpdate(e:Event = null):void
		{
			if(AppData.isFreezePlay || _isCollected)
			return;
			
			this.y -= AppData.currSpeed
			
			if (!_isInCollRange)
			{
				if (this.y < AppData.deviceResY / 2)
				_isInCollRange = true;
			}
			
			//------------------------------------o
			// -- Coin magnet is ACTIVE, use distance collision and coin magnet
			//------------------------------------o	
			if (_core.controlBus.powerupController.isCoinMagnet)
			{
			
				_disX = _core.refPlayer.x - this.x
				_disY = _core.refPlayer.y - this.y

				//get total distance as one number
				_disTot = Math.sqrt(_disX * _disX + _disY * _disY);
				
			
				if (_disTot < AppData.deviceScaleX*300)
				{
					if (_isCollected)
					return;
					
					_isCollected = true;

					TweenMax.to(this, .5, { dynamicProps: { x:getPosX, y:getPosY }, repeat:0, ease:Cubic.easeInOut, onComplete:function():void { onCoinCollect(); return; }} );
					function getPosX():Number {
						return _core.refPlayer.x;
					}	
									
					function getPosY():Number {
							return _core.refPlayer.y+90;
					}	
				}
			}
			//------------------------------------o
			// -- Coin magnet is NOT ACTIVE, use box collision
			//------------------------------------o
			else
			{
				if (_isInCollRange)
				{
				  if (this.getBounds(_core.refPlayScreen).intersects(_core.refPlayer.getBounds(_core.refPlayScreen)))
				  {
					 onCoinCollect(); 
					 return;
				  }
				}
			}
			
			//if coin leaves screen trash it
			if (this.y <= -height)
			deactivate();	
			
		}

		//=========================================o
		//-- Override Activate
		//=========================================o
		public function activate():void
		{
			_isInCollRange = false;
			_isCollected = false;
			_isActive = true;
			_smcIdle.play();
			if(!this.hasEventListener(Event.ENTER_FRAME))
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		
		//=========================================o
		//-- Override Deactivate
		//=========================================o
		public function deactivate():void
		{
			_isInCollRange = false
			_isActive = false;
			_smcIdle.currentFrame = 0;
			_smcIdle.pause();
			this.y = -200;
 			returnToObjPool();
		}
		
		//=========================================o
		//-- On Coin Collect
		//=========================================o		
		private function onCoinCollect():void
		{
			_isCollected = true;
			
			if(_core.controlBus.powerupController.isCoinDouble)
			AppData.currDiveCoins += (CoinDoubleVO.CURRENT_LEVEL+1) * 13;
			else
			AppData.currDiveCoins += 13;
			
			SoundAS.playFx("coin"+Maths.rn(1,3));
			
			_core.controlBus.gameHUDController.updateCoins();
			
			TweenLite.to(this, .2, {x: 10, y:10, onComplete:deactivate})

		}
		
		//=========================================o
		//-- Return to Object Pool
		//=========================================o	
		public function returnToObjPool():void
		{
			this.removeEventListeners();
			ObjPool_Coin.addToPool(this);
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			//deactivate();
			this.removeFromParent();

		}
		
		//=========================================o
		//-- kill/dispose/destroy
		//=========================================o
		public function trash():void
		{
			ArrayUtil.removeItemFromArray(AppData.arrActionObjects, this);
			deactivate();
			this.removeEventListeners();
			this.removeFromParent();
		}


		
		
	}

}