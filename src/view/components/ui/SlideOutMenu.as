package view.components.ui
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.sensors.Geolocation;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.DeviceType;
	import staticData.DynamicAtlasValues;
	import staticData.HeaderLabels;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;

	
	//================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//================================o
	
	public class SlideOutMenu extends Sprite
	{

		static public const STATE_OPEN:String = "stateOpen";
		static public const STATE_CLOSE:String = "stateClose";
		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgBacking:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		private var _type:String;
		private var _imgButton1:Image;
		private var _sspMenuHolder:Sprite;
		private var _isMenuOpen:Boolean = false;
		private var _componentWidth:Number;
		private var _arrNavList:Array;
		
		//================================o
		//-- Constructor
		//================================o
		public function SlideOutMenu()
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		//================================o
		//-- Init
		//================================o		
		private function init(e:Event):void
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			//-----------------------------------------------------------------o
			//---- formulate nav list
/*			_arrNavList = new Array();
			_arrNavList.push([HeaderLabels.SLIDER_HOME, StateMachine.STATE_HOME]);
			_arrNavList.push([HeaderLabels.SLIDER_PLAY, StateMachine.STATE_GAME]);
			
			_arrNavList.push([HeaderLabels.SLIDER_COMPETITION, StateMachine.STATE_COMPETITION]);
			
			_arrNavList.push([HeaderLabels.SLIDER_SHOP, StateMachine.STATE_SHOP]);
			
			_arrNavList.push([HeaderLabels.SLIDER_CHECK_IN, StateMachine.STATE_CHECK_IN]);
			
			_arrNavList.push([HeaderLabels.SLIDER_ACHIEVEMENT, StateMachine.STATE_ACHIEVEMENT]);
			
			if(!AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_LEADERBOARD, StateMachine.STATE_LEADERBOARDS]);
			
			if(!AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_SHARE, StateMachine.STATE_SHARE]);
			
			if((Geolocation.isSupported || PublicSettings.DEBUG_RELEASE) && !AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_FIND_A_STORE, StateMachine.STATE_FIND_STORE]);
			
			if(!AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_REDEEM, StateMachine.STATE_REDEEM]);
			
			_arrNavList.push([HeaderLabels.SLIDER_ABOUT, StateMachine.STATE_ABOUT]);
			
			_arrNavList.push([HeaderLabels.SLIDER_SETTINGS, StateMachine.STATE_SETTINGS]);
			*/
			
			//Player login condition
/*			if(UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_OUT && !AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_LOGIN, StateMachine.STATE_LOGIN]);
			else if(UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_IN && !AppData.isGuest)
			_arrNavList.push([HeaderLabels.SLIDER_PROFILE, StateMachine.STATE_PROFILE]);*/
		
			//-----------------------------------------------------------------o
			
/*			_sspMenuHolder = new Sprite();
			this.scaleX = this.scaleY = AppData.deviceScaleX;
			
			var w:int;
			if (DeviceType.type == DeviceType.IPAD)
			{
			w = 560;
			this.scaleX = this.scaleY = AppData.deviceScaleX - .2;
			}
			else if (DeviceType.type == DeviceType.IPHONE_5)
			w = 560;
			else if (DeviceType.type == DeviceType.IPHONE_4)
			w = 560;
			else
			{
			w = AppData.deviceScaleX * 560;
			}
			
			//_quFill = new Quad(w, 2000, HexColours.NAVY_BLUE);
			_quFill = new Quad(555, 2000, HexColours.NAVY_BLUE);
			
			_sspMenuHolder.addChild(_quFill);
			this.addChild(_sspMenuHolder);

			// Create Button list
			var itemVGap:int = 2; //vertical spacing
			var topSpace:int = 50;
			if (DeviceType.type == DeviceType.IPAD)
			topSpace = 20;
			//Create nav list
			for (var i:int = 0; i < _arrNavList.length; i++)
			{
				var menuItem:SlideMenuItem = new SlideMenuItem(_arrNavList[i][0], _arrNavList[i][1], i)
				menuItem.x = 20;
				menuItem.y = (76 * i) + topSpace;
				_sspMenuHolder.addChild(menuItem);
				
			}
			
			_componentWidth = _sspMenuHolder.width;
			_sspMenuHolder.x = 0*/
		
		}
		
		//================================o
		//-- dispose/kill
		//================================o		
		public function trash():void
		{
			trace(this + " trash()")
			this.removeFromParent();
			TexturePack.deleteTexturePack(DynamicAtlasValues.SLIDE_MENU_DA)
		
		}
		//================================o
		//-- Getters and Setters
		//================================o		
		public function get componentWidth():Number
		{
			return _componentWidth;
		}
	
	}

}