package view.components.gameobjects 
{

	import com.greensock.TweenLite;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Maths;
	import com.johnstejskal.StarlingUtil;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.ObjectPools.ObjPool_Misc;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.AppData;
	import staticData.HexColours;
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
	public class FuelGauge extends Sprite
	{
		static public const STATE_1:String = "state1";
		static public const STATE_2:String = "state2";
		
		private var _core:Core;

		private var _sim:Image;
		private var _simBacking:Image;
		private var _tf:TextField;
		private var flashInterval:uint;
		private var _this:FuelGauge;
		private var _isState2:Boolean = false;
		private var _currState:String = STATE_1;

		//=========================================o
		//-- Constructor
		//=========================================o
		public function FuelGauge() 
		{
			_core = Core.getInstance();
			_this = this;
			_sim = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_fuelGauge0000"));
			_simBacking = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_gaugeBacking0000"));
			_simBacking.pivotX = _simBacking.width;
			_simBacking.width = 440;

			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addChild(_sim);
			this.addChild(_simBacking);
			_simBacking.x = 440;
			this.pivotX = 440 / 2;
			this.scaleX = this.scaleY = AppData.offsetScaleX;
			
			_tf = new TextField(250, 40, "PIN DROP", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.WHITE);
			_tf.filter = BlurFilter.createDropShadow(2, 1, 0x000000, 0.2, 0, 0.5);
			_tf.hAlign = HAlign.LEFT; 
			_tf.vAlign = VAlign.CENTER;
			_tf.x = 0;
			_tf.y = -40;
			_tf.border = false;
			this.addChild(_tf);
						
		}
		
		public function doAntiGravityFuel():void
		{
		  _isState2 = true;
		  _tf.text = "DRIFT DROP";	
		}
		
		public function changeState(state:String):void 
		{
			if (state == STATE_1)
			{
			_tf.text = "PIN DROP";	
			}			
			else if (state == STATE_2)
			{
			_tf.text = "DRIFT DROP";	
			}
			
			_currState = state;
			
			update();

		}
				
		public function onUpdate(e:Event = null):void 
		{
			if(AppData.isFreezePlay)
			return;
		}
		
		public function update():void 
		{
			//_sim.width = ((Data.currBoostFuel / Data.maxBoostFuel) * 1)* 440;
			if(_currState == STATE_1)
			_simBacking.width = 440 - (((AppData.currBoostFuel / AppData.maxBoostFuel) * 1) * 440);
			else if(_currState == STATE_2)
			_simBacking.width = 440 - (((AppData.currDriftFuel / AppData.maxDriftFuel) * 1) * 440);
		}
		
		
		private function reset():void 
		{

		}
		

		
		
		//=========================================o
		//-- kill/dispose/destroy
		//=========================================o
		public  function trash():void
		{
			this.removeFromParent();
		}
		
		public function refill():void 
		{
			//_oFuelGauge.width = 1;
			//_oFuelGauge.visible = true;
			//_oFuelGauge.alpha = 1;
			//TweenLite.to(_sim, 2, {width:440});
			TweenLite.to(_simBacking, 2, {width:1});
		}
		
		public function flash():void 
		{
			//StarlingUtil.makeObjectFlash(this, 2, 50);
			makeFlash(2, 50);
		}
		


		//-----------------------------------------------o
		//-------- Make an object flash
		//-----------------------------------------------o
		private function makeFlash(time:Number = 1, interval:Number = 500):void
		{
			flashInterval = setInterval(flash, interval);

			TweenLite.delayedCall(time, function():void{  clearInterval(flashInterval);  _this.visible = true; })
			
			function flash():void
			{
				if (_this == null)
				return;
				
				if (!_this.visible)
				_this.visible = true;
				else
				_this.visible = false;
			}
		}

		public function stopFlashing():void
		{
			clearInterval(flashInterval);
			this.visible = true;
		}


		
		
	}

}