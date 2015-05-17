package view.components.screens
{
	import com.greensock.TweenMax;
	import com.thirdsense.animation.TexturePack;
	import flash.display.MovieClip;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import interfaces.iScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.AppData;
	import staticData.dataObjects.PickAxeVO;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.mining.ore.MineOre;
	import view.components.gameobjects.mining.PickAxe;
	import view.components.screens.mineSubScreens.MineScreen1;
	import view.components.screens.mineSubScreens.MineScreen2;
	import view.components.screens.mineSubScreens.MineScreen3;
	import view.components.screens.mineSubScreens.MineSubScreen;
	import view.components.ui.InventoryBar;

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class MineScreen extends SuperScreen implements iScreen
	{
		private var _oBg:Quad;
		private var _spMineSeriesHolder:Sprite;
		
		private var _oMineScreen1:MineScreen1;
		private var _oMineScreen2:MineScreen2;
		private var _oMineScreen3:MineScreen3;
		private var _nextBtn:DisplayObject;
		private var _prevBtn:DisplayObject;

		private var _currMineIndex:Number = 1;
		private var _this:MineScreen;
		private var _oCurrMineScreen:MineSubScreen;
		private var _oPickAxe:PickAxe;
		private var _isMining:Boolean = false;
		private var _oInventoryBar:InventoryBar;

		//==========================================o
		//------ Constructor 
		//==========================================o
		public function MineScreen():void 
		{
			
		}

		//==========================================o
		//------ Assets loaded callback 
		//==========================================o
		public override function loaded():void 
		{
		_this = this;
			DSpriteSheet_mining.init(init);
		}
		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{
			trace(this + "init()");

			_spMineSeriesHolder = new Sprite();
			
			_oMineScreen1 = new MineScreen1();
			_oMineScreen2 = new MineScreen2();
			_oMineScreen3 = new MineScreen3();
			
			_spMineSeriesHolder.addChild(_oMineScreen1);
			_oMineScreen2.x = AppData.deviceResX;
			_spMineSeriesHolder.addChild(_oMineScreen2);
			_oMineScreen3.x = AppData.deviceResX * 2;
			_spMineSeriesHolder.addChild(_oMineScreen3);
			
			this.addChild(_spMineSeriesHolder);
			
			_nextBtn = DSpriteSheet_mining.dtm.getAssetByUniqueAlias("nextMineButton");
			_nextBtn.x = 930;
			_nextBtn.y = 520;
			this.addChild(_nextBtn);
			
			_prevBtn = DSpriteSheet_mining.dtm.getAssetByUniqueAlias("nextMineButton");
			_prevBtn.x = 100;
			_prevBtn.y = 520;
			this.addChild(_prevBtn);
			
			
			_prevBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			_nextBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			
			
			
			_oCurrMineScreen = this["_oMineScreen" + _currMineIndex];
			_oCurrMineScreen.activate();
			addPickAxe();
			
			
			_oInventoryBar = new InventoryBar();
			this.addChild(_oInventoryBar);
			_oInventoryBar.pivotY = _oInventoryBar.height;
			
			_oInventoryBar.y = AppData.deviceResY;
			
			EventBus.getInstance().sigOnOreClicked = new Signal(MineOre, Boolean) //target Orge, Criteria Met
			EventBus.getInstance().sigOnOreClicked.add(evtOnOreClicked)
						
			EventBus.getInstance().sigOnOreMineSuccess = new Signal(MineOre) //target Orge
			EventBus.getInstance().sigOnOreMineSuccess.add(OnOreMineSuccess)
									
			EventBus.getInstance().sigOnOreMineFailed = new Signal(MineOre) //target Orge
			EventBus.getInstance().sigOnOreMineFailed.add(OnOreMineFailed)
												
			EventBus.getInstance().sigOnPickAxeBroken = new Signal()
			EventBus.getInstance().sigOnPickAxeBroken.add(OnPickAxeBroken)
			
			
		}
		
		private function OnPickAxeBroken():void 
		{
			 _isMining = false;
		}
		
		private function OnOreMineFailed(ore:MineOre):void 
		{
			 _isMining = false;
		}
		
		private function OnOreMineSuccess(ore:MineOre):void 
		{
			hidePickAxe();	
			_isMining = false;
		}
		
		private function showPickAxe():void 
		{
			TweenMax.to(_oPickAxe, .5, {alpha:1})
		}
				
		private function hidePickAxe():void 
		{
			TweenMax.to(_oPickAxe, 1, {alpha:0})
		}
		
		public function evtOnOreClicked(ore:MineOre, criteraMet:Boolean):void 
		{
			if (_isMining)
			return;
			
			trace("mining:" + ore.type + "swings required:" + ore.swingsRequired)
			if (criteraMet)
			{
				showPickAxe();
				_oPickAxe.x = ore.x + 100;
				_oPickAxe.y = ore.y;
				_oPickAxe.startMining(ore);
				_isMining = true;
			}
			else
			{
				trace(this+"Criteria Not Met, cannot Mine This Ore");
			}
			
			trace("_oPickAxe :" + _oPickAxe);
			
			
		}
		
		public function addPickAxe():void
		{
			if (_oPickAxe == null)
			{
				_oPickAxe = new PickAxe(PickAxeVO.type);
				_oPickAxe.x = _oPickAxe.y = 300;
				_oPickAxe.alpha = 0;
				_oCurrMineScreen.addChild(_oPickAxe);
			}
		}
		public function removePickAxe():void
		{
			if (_oPickAxe != null)
			{
				_oPickAxe.trash();
				_oPickAxe = null;
			}
		}
		//==========================================o
		//------ Event Handlers 
		//==========================================o		
		//==========================================o
		//------ Touch Handlers 
		//==========================================o
		private function onTouch(e:TouchEvent):void 
		{
			
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
                if(touch.phase == TouchPhase.BEGAN)
                {	

					if(e.target == _nextBtn)
					changeMine("right");
					else if(e.target == _prevBtn)
					changeMine("left");
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		private function changeMine(direction:String):void 
		{
			if (_isMining)
			return;
			
			if (direction == "right")
			{
				_currMineIndex ++;
			TweenMax.to(_spMineSeriesHolder, .1, { x:String( -AppData.deviceResX), onComplete:onChangeMineComplete})
			}
			else
			{ 
				_currMineIndex --;
				TweenMax.to(_spMineSeriesHolder, .1, { x:String(AppData.deviceResX), onComplete:onChangeMineComplete } )
			}	
	
		}
		
		private function onChangeMineComplete():void 
		{
			_oCurrMineScreen = this["_oMineScreen" + _currMineIndex];
			_oCurrMineScreen.addChild(_oPickAxe);
			
			//_oCurrMineScreen.activate();
		}



		//==========================================o
		//------ Public functions 
		//==========================================o
		
		//==========================================o
		//------ dispose/kill/terminate/
		//==========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			
			this.removeFromParent();
		}
		

		
		//==========================================o
		//------ Getters and Setters 
		//==========================================o			
		
	}
	
}