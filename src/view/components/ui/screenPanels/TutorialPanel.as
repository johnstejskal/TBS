package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import staticData.AppFonts;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.screens.panels.subPanels.InfoPanel1;
	import view.components.screens.panels.subPanels.InfoPanel2;
	import view.components.screens.panels.subPanels.InfoPanel3;
	import view.components.screens.panels.subPanels.InfoPanel4;
	import view.components.screens.panels.subPanels.tutorial.TutePanel1;
	import view.components.screens.panels.subPanels.tutorial.TutePanel2;
	import view.components.screens.panels.subPanels.tutorial.TutePanel3;
	import view.components.screens.panels.subPanels.tutorial.TutePanel4;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TutorialPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "TutorialPanel";
		static public const STATE_TUTORIAL_1:String = "state1";
		static public const STATE_TUTORIAL_2:String = "state2";
		static public const STATE_TUTORIAL_3:String = "state3";
		static public const STATE_TUTORIAL_4:String = "state4";
		static public const STATE_PLAY_GAME:String = "statePlay";


		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _currentPanelObj:*;
		private var _nextState:String;
		private var _currentState:String;
		private var _simNextBtn:Image;
		
		private var _oInfoPanel1:TutePanel1;
		private var _oInfoPanel2:TutePanel2;
		private var _oInfoPanel3:TutePanel3;
		private var _oInfoPanel4:TutePanel4;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function TutorialPanel() 
		{
			
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			changeState(STATE_TUTORIAL_1)
		}
		
		//=======================================o
		//-- Change State
		//=======================================o		
		public function changeState(newState:String):void 
		{
			
			if (newState == _currentState)
			return;
			
			_currentState = newState;
			
			if (_currentPanelObj != null)
			_currentPanelObj["trash"]();
			
			
			trace(this + "changeState(" + newState + ")");
			switch(newState)
			{
				case STATE_TUTORIAL_1:
				_oInfoPanel1 = new TutePanel1(this);
				_currentPanelObj = _oInfoPanel1;
				this.addChild(_oInfoPanel1)
				_nextState = STATE_TUTORIAL_2;
				break;
								
				case STATE_TUTORIAL_2:
				_oInfoPanel2 = new TutePanel2(this);
				_currentPanelObj = _oInfoPanel2;
				this.addChild(_oInfoPanel2)
				_nextState = STATE_TUTORIAL_3;
				break;
												
				case STATE_TUTORIAL_3:
				_oInfoPanel3 = new TutePanel3(this);
				_currentPanelObj = _oInfoPanel3;
				this.addChild(_oInfoPanel3)
				_nextState = STATE_TUTORIAL_4;
				break;		
				
				case STATE_TUTORIAL_4:
				_oInfoPanel4 = new TutePanel4(this);
				_currentPanelObj = _oInfoPanel4;
				this.addChild(_oInfoPanel4)
				_nextState = STATE_PLAY_GAME;
				break;
								
				case STATE_PLAY_GAME:
				_core.refPlayScreen.endTutorial(false);
				trash();
				break;
				
			}
			
		}
			
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			if (_currentPanelObj != null)
			_currentPanelObj["trash"]();
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			
		}
		
		
		//=========================================o
		//------ Getters and Setters
		//=========================================o		
		public function get nextState():String 
		{
			return _nextState;
		}
		
		public function set nextState(value:String):void 
		{
			_nextState = value;
		}
		
		
	}

}