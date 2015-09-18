package ManagerClasses.controllers
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.Maths;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.controllers.PushController;
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.StageText;
	import ManagerClasses.StateMachine;
	import ManagerClasses.supers.SuperController;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.AppData;
	import staticData.dataObjects.PlayerData;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.Sounds;
	import staticData.valueObjects.AchievementVO;
	import staticData.valueObjects.PrizeVO;
	import staticData.valueObjects.PrizeVO;
	import staticData.valueObjects.ShopItemVO;
	import treefortress.sound.SoundAS;
	import view.components.screens.LoadingScreen;
	import view.components.ui.FormField;
	import view.components.ui.MenuIcon;
	import view.components.ui.nativeDisplay.ProgressBar;
	import view.components.ui.NotificationPanel;
	import view.components.ui.screenPanels.SettingsPanel;

	import view.components.ui.SlideOutMenu;
	import view.components.ui.TitleBar;
	import view.StarlingStage;
	
	//==============================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//==============================================o
	public class AppUIController extends SuperController
	{
		
		private const _stage:Main = Core.getInstance().main;
		private var _oMenuIcon:MenuIcon;
		private var _root:StarlingStage;
		private var _quDimScreen:Quad;
		private var _oSlideOutMenu:SlideOutMenu;
		private var _currSlideMenuState:String = SlideOutMenu.STATE_CLOSE;
		static private var _oloadingScreen:LoadingScreen;
		private var _oNotificationPanel:NotificationPanel;
		private var _currPanelObject:*;
		private var _oTitleBar:TitleBar;
		private var _isNavSliding:Boolean = false;
		private var _isNotificationActive:Boolean = false;
		private var _arrInfoPopups:Array;
		private var _arrInfoPopupIds:Array;
		private var _prevInfoPanelIndex:int = 0;
		private var _isInfoPanelActive:Boolean = false;
		private var _prevInfoPanelId:int;
		private var _isLoading:Boolean = false;
		private var _currPanelIndex:Number = 0;
		private var _oProgressBar:ProgressBar;
		
		//==============================================o
		//------ Constructor
		//==============================================o			
		public function AppUIController(root:StarlingStage)
		{
			trace("AppUIController constructed");
			_root = root;
		}

		public function repopulateInfoIndexArray():void
		{
			trace(this + "repopulateInfoIndexArray()");

		}
		
		//=======================================o
		//-- add a Title bar to a screen 
		//-- this is added in the controller so it doesnt trash with screens
		//=======================================o
		
		public function addTitlebar(label:String, enableBackButton:Boolean = true, isTransparent:Boolean = false, hexColour:uint = HexColours.RED):void
		{
			trace(this + "addTitlebar()");
			if (_oTitleBar != null)
			_oTitleBar.trash();
			
			_oTitleBar = new TitleBar();
			_oTitleBar.label = label;
			_oTitleBar.hexColour = hexColour
			_oTitleBar.enableBackButton = enableBackButton;
			_oTitleBar.y = 0;
			_root.addChild(_oTitleBar);
			
			if (_oMenuIcon != null)
			_root.setChildIndex(_oMenuIcon, _root.numChildren - 1);
						
			if (_quDimScreen != null)
			_root.setChildIndex(_quDimScreen, _root.numChildren - 1);
			
			if (_isNotificationActive)
			{
				if (_oNotificationPanel != null)
				{
					_root.setChildIndex(_oNotificationPanel, _root.numChildren - 1)
				}
			}
			
			trace("enableBackButton :" + enableBackButton);
		
		}
		
		//=======================================o
		//-- remove the Title bar to a screen 
		//=======================================o
		public function removeTitleBar():void
		{
			if (_oTitleBar)
				_oTitleBar.trash();
			_oTitleBar = null;
		}
				
		//=======================================o
		//-- remove the Title bar to a screen 
		//=======================================o
		public function hideTitleBar():void
		{
			if (_oTitleBar)
			{
				_oTitleBar.visible = false;
				_oTitleBar.touchable = false;
			}
			
		}
		
		//==============================================o
		//------ Add Fill to darken screen
		//==============================================o		
		public function addFillOverlay(fadeSpeed:Number = .3, opacity:Number = .5, callback:Function = null, aboveMenuBar:Boolean = true, hexColour:uint = HexColours.BLACK, touchCallback:Function = null):void
		{
			trace(this + "addFillOverlay() _isNotificationActive"+_isNotificationActive);
			

		
		}
		
		//==============================================o
		//------ remove Fill
		//==============================================o		
		public function removeFillOverlay(duration:Number = .3):void
		{

		}
		
		//==============================================o
		//------ Add Slide Out menu
		//==============================================o		
		public function addSlideOutMenu():void
		{
			_oSlideOutMenu = new SlideOutMenu();
			_oSlideOutMenu.x = AppData.deviceResX;
			_root.addChild(_oSlideOutMenu);
		}
		
		//==============================================o
		//------ Remove Slide Out menu
		//==============================================o		
		public function removeSlideOutMenu():void
		{
			_oSlideOutMenu.trash();
			_oSlideOutMenu = null;
			System.gc();
		}
		
		
		//==============================================o
		//------ Updated Slide Menu List
		//==============================================o	
		public function changeSlideMenuState(newState:Array):void
		{
			
		}
		
		
		//==============================================o
		//------ Change Slide Out menu Open/Close Status
		//==============================================o	
		public function changeSlideMenuStatus(newState:String):void
		{
			
			if (_isNavSliding)
			return;
			
			var speed:Number = PublicSettings.SLIDE_MENU_IN_SPEED;
			if (!_oSlideOutMenu)
			{
				core.controlBus.appUIController.addSlideOutMenu();
			}
			
			var menuIconPress:Boolean = false;
			if (newState == null)
				menuIconPress = true;
			
			
			var xPos:int;
			if (newState == SlideOutMenu.STATE_CLOSE)
			{
				xPos = 0;
				speed = PublicSettings.SLIDE_MENU_OUT_SPEED;
			}
			else if (newState == SlideOutMenu.STATE_OPEN)
			{
				xPos = -_oSlideOutMenu.componentWidth;
				xPos = -_oSlideOutMenu.width;
				
			}
			else
				//No state Specified,Call has come from the menuIcon,  toggle based on current state
			{
				if (_currSlideMenuState == SlideOutMenu.STATE_CLOSE)
				{
					newState = SlideOutMenu.STATE_OPEN;
					xPos = _oSlideOutMenu.componentWidth;
					xPos = -_oSlideOutMenu.width;
					
					
					addFillOverlay(1, .5, null, true, HexColours.BLACK, touchCallback);
					
					if(StateMachine.currentScreenObject != null)
					StateMachine.currentScreenObject.deactivate();
					
				}
				else if (_currSlideMenuState == SlideOutMenu.STATE_OPEN)
				{
					speed = PublicSettings.SLIDE_MENU_OUT_SPEED;
					newState = SlideOutMenu.STATE_CLOSE;
					xPos = 0;
					
				}

			}
			
			_isNavSliding = true;
			
			TweenLite.to(_root, speed, {x: xPos, ease: Cubic.easeInOut, onComplete: function():void
			{
					_currSlideMenuState = newState;
					
					
					if (_currSlideMenuState == SlideOutMenu.STATE_CLOSE)
					{
						removeFillOverlay();
						removeSlideOutMenu();
						
						if(StateMachine.currentScreenObject != null)
						StateMachine.currentScreenObject.activate();
					}
					
					_isNavSliding = false;
				
			}})
			
			function touchCallback():void
			{
				 EventBus.getInstance().sigSlideMenuAction.dispatch(SlideOutMenu.STATE_CLOSE);
			}
		
		}
		
		//==============================================o
		//------ Show a inter-state loading screen
		//==============================================o
		public function showLoadingScreen(label:String = null, showProgress:Boolean = false, hexColour:uint = HexColours.BLACK):void
		{
			
			trace(this + "showLoadingScreen()"+ _root);
			hideStageText();
		
			if (_oloadingScreen != null && label != null)
			{
				_oloadingScreen.updateLabel(label);
				return;
			}
			
			
			hideMenuButton();
			
			_oloadingScreen = new LoadingScreen(label, showProgress, hexColour);
			

			_root.addChild(_oloadingScreen)
			
			_isLoading = true;
		}
		
		//==============================================o
		//------ hide the inter-state loading screen
		//==============================================o
		public function removeLoadingScreen(fadeTime:Number = 0):void
		{
		
			_isLoading = false;
			
		
		}
		
		//=======================================o
		//-- Show Pause Screen
		//=======================================o	
		public function showPauseScreen():void
		{
			trace(this + "showPauseScreen()");

		}
		
		//=======================================o
		//-- Remove Pause Screen
		//=======================================o	
		public function removePauseScreen():void
		{
			trace(this + "removePauseScreen()");

		}
		
		
		//==============================================o
		//------ show a generic notification panel
		//==============================================o
		public function showNotification(title:String, subTitle:String, btn1label:String = "YES", btn1Callback:Function = null, btn2label:String = "NO", btn2Callback:Function = null, buttonCount:int = 2):void
		{
			trace(this + "showNotification()"+subTitle);
			

			
		
		}

				


		//=======================================o
		//-- show the achievement panel
		//=======================================o		
		public function showAchievementPanel(vo:AchievementVO):void 
		{


		}
		
		//=======================================o
		//-- hide the achievement panel 
		//=======================================o		
		public function hideAchievementPanel(nextVO:AchievementVO = null):void 
		{
			trace(this+"hideAchievementPanel()");
		}
		
		public function hideMenuButton():void 
		{
			trace(this+"hideMenuButton()");
			if (_oMenuIcon != null)
			{
				_oMenuIcon.visible = false;
			}
		}
		
		public function removeMenuButton():void 
		{
			trace(this+"removeMenuButton()");
			if (_oMenuIcon != null)
			{
				_oMenuIcon.trash();
				_oMenuIcon = null;
			}
		}
		
		public function lockApp():void 
		{
			addFillOverlay(0, 1, null, true);
			if (_oNotificationPanel.parent != null)
			_oNotificationPanel.trash();
		
		}
		
		//=======================================o
		//-- Show all Stage Text
		//=======================================o			
		public function showStageText():void
		{
			//trace(this+"showStageText()")
			for (var i:int = 0; i < AppData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppData.arrStageTextInstanes[i]);
				trace("st.stage :"+ff.stageText.stage)
				if (!ff.stageText.stage)
				{
				ff.stageText.stage = Starling.current.nativeStage;
				ff.stageText.visible = true;
				}
				else
				{
				ff.stageText.visible = true;
				ff.active = true;
				}

			}
			
		}

		//=======================================o
		//-- Hide all Stage Text
		//=======================================o	
		public function hideStageText():void
		{
			trace(this+"hideStageText()")
			for (var i:int = 0; i < AppData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppData.arrStageTextInstanes[i]);
				ff.stageText.visible = false;	
				ff.active = false;
			}
		}	
		
		//=======================================o
		//-- Kill aa Stage Text
		//=======================================o	
		public function removeStageText():void
		{
			trace(this+"removeStageText()")
			for (var i:int = 0; i < AppData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppData.arrStageTextInstanes[i]);
				ff.stageText.stage = null;
				ff.stageText.dispose();
			}
			
			AppData.arrStageTextInstanes.length = 0;
			AppData.arrStageTextInstanes = [];
			trace(this+"removeStageText(), Data.arrStageTextInstanes.length is:"+AppData.arrStageTextInstanes.length)
		
		}
		
		public function showProgressBar(discipline:String):void 
		{
			
			if (_oProgressBar != null)
			{
				_oProgressBar = null;
			}
			_oProgressBar = new ProgressBar(discipline);
			core.nativeStage.addChild(_oProgressBar);
		}
		

		
		//=======================================o
		//-- Getters and Setters
		//=======================================o				
		

	
	}

}