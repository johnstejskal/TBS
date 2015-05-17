package view.components.gameobjects.mining {
	import com.greensock.TweenMax;
	import com.johnstejskal.Maths;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import singleton.EventBus;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	import staticData.dataObjects.PickAxeVO;
	import staticData.Metal;
	import view.components.gameobjects.mining.ore.MineOre;
	import view.components.gameobjects.mining.ore.Ore;
	import view.components.gameobjects.superClass.GameObject;
	import view.components.screens.mineSubScreens.MineSubScreen;


	
	//==================================================================o
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==================================================================o
	public class PickAxe extends Sprite
	{

		public var _variation:int;



		private var _img:DisplayObject;
		private var _metalType:String;
		private var _currOreTarget:MineOre;
		private var _currSwings:int;
		private var _strengthGrade:Number;
		private var _swingSpeed:Number;
		private var _pullBackSpeed:Number;
		private var _percChanceToMine:Number;
		

		//============================================o
		//-- Constructor  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		//============================================o
		public function PickAxe(metalType:String) 
		{
			
			trace(this+ "constructed");
			_metalType = metalType;
			
			if (metalType == Metal.TYPE_BRONZE)
			_strengthGrade = 1;
			else if (metalType == Metal.TYPE_IRON)
			_strengthGrade = 1;
			else if (metalType == Metal.TYPE_STEEL)
			_strengthGrade = 1;			
			else if (metalType == Metal.TYPE_MYTHRIL)
			_strengthGrade = 2;				
			else if (metalType == Metal.TYPE_ADAMANTITE)
			_strengthGrade = 2;					
			else if (metalType == Metal.TYPE_OBSIDIAN)
			_strengthGrade = 3;					
			else if (metalType == Metal.TYPE_DRAGONITE)
			_strengthGrade = 4;	
			
			_swingSpeed = .2;
			_pullBackSpeed = 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null ):void 
		{
			
			trace(this+"init()")
			this.removeEventListeners();
			_img = DSpriteSheet_mining.dtm.getAssetByUniqueAlias("pickAxe");
			this.addChild(_img);
		
		}
		
		
		public function startMining(ore:MineOre):void
		{
			
			_percChanceToMine = getChanceToMine(ore);
			
			ore.strengthGrade; _strengthGrade
			readyAxe();
			_currSwings = 0;
			_currOreTarget = ore;
		}
		
		private function getChanceToMine(ore:MineOre):Number 
		{
			var chance:Number = 0;
			switch(_metalType)
			{
				case Metal.TYPE_BRONZE:
					
					if (ore.strengthGrade == 1)
					chance = .2;
					else if (ore.strengthGrade == 2)
					chance = .1;
					else if (ore.strengthGrade == 3)
					chance = .1;	
					else if (ore.strengthGrade > 3)
					chance = .05;						
					
				break;
			}
			
			return chance;
		}
		
		private function readyAxe():void 
		{
			TweenMax.to(this, _pullBackSpeed, {rotation:deg2rad(45), onComplete:doHit})
		}
		
		private function doHit():void
		{
			TweenMax.to(this, _swingSpeed, { rotation:deg2rad( -75), onComplete:function():void {
			
				_currSwings ++;
				var rn:Number = Math.random();
				trace("rn:"+rn);
				trace("_percChanceToMine:"+_percChanceToMine);
				if (rn < _percChanceToMine)
				{
					_currOreTarget.doDepleteOre();
					EventBus.getInstance().sigOnOreMineSuccess.dispatch(_currOreTarget);
				}
				else
				readyAxe();
				
			}})
		}
		
		 public function trash():void
		{
			
			//trace(this+" trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		

		
		
	}

}