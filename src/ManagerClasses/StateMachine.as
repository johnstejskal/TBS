package ManagerClasses 
{

	import adobe.utils.CustomActions;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.StringFunctions;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.thirdsense.controllers.PushController;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.social.facebook.FacebookFriend;
	import com.thirdsense.social.FacebookInterface;
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.security.SignatureStatus;
	import flash.sensors.Geolocation;
	import flash.system.System;
	import ManagerClasses.controllers.*;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_action;
	import ManagerClasses.ObjectPools.ObjPool_Coin;
	import ManagerClasses.ObjectPools.ObjPool_Misc;
	import ManagerClasses.ObjectPools.ObjPool_Obstacle;
	import net.AppServices;
	import net.FacebookService;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import staticData.AppData;
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.PrizeData;
	import staticData.dataObjects.ShopData;
	import staticData.HexColours;
	import staticData.LocalData;
	import staticData.NotificationLabel;
	import staticData.HeaderLabels;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.SharedObjectKeys;
	import staticData.SoundData;
	import staticData.Sounds;
	import staticData.SpriteSheets;
	import staticData.valueObjects.PrizeVO;
	import staticData.valueObjects.ShopItemVO;
	import staticData.valueObjects.StoreVO;
	import staticData.valueObjects.ValueObject;
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	import view.components.gameobjects.Background;
	import view.components.screens.MineScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.MenuIcon;
	import view.components.ui.SlideOutMenu;
	import view.StarlingStage;

	import view.components.screens.HomeScreen;
	import staticData.Constants;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import singleton.Core;


	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	
	 //---------------------------o
	 // This state machine is in charge of listeneing to events from the EventBus
	 // and dispatching state changes, 
	 // the only components it should be aware of are the core screen states, 
	 //
	public class StateMachine 
	{
		
		//STATES

		//App Setup State: initializes Starling Stage
		public static const STATE_SETUP:String = "setup"		
		//App has been Deactivated
		public static const STATE_DEACTIVATE:String = "deactivate"	
		
		//main App States
		public static const STATE_HOME:String = "home";
		public static const STATE_GAME:String = "game";
		public static const STATE_SHOP:String = "shop";
		public static const STATE_MINE:String = "mine";
		public static const STATE_SETTINGS:String = "settings";

	
		
		//-----------------------------------------o
		//-- State Name & State Object references
		//-----------------------------------------o
		public static var currentAppState:String;
		public static var prevAppState:String;
		static public var nextAppState:String;
		
		public static var currentScreenObject:SuperScreen;
		static private var currentGameState:String;
		
		//-----------------------------------------o
		//-- Main Starling stage
		//-----------------------------------------o		
		public static var oStarlingStage:StarlingStage;
		
		//-----------------------------------------o
		//-- Screen Components
		//-----------------------------------------o
		
		public static var _oHomeScreen:HomeScreen;

		static private var _core:Core;
		static private var _oMineScreen:MineScreen;

		static public var allowDeviceDectivate:Boolean = true;
		static public var allowDeviceActivate:Boolean = true;

		public static var _levelToLoad:String = "level1";
		static public var forceState:Boolean = false;

		public function StateMachine() 
		{

		}
		
		public static function init():void
		{
			trace(StateMachine + "init()");
							
		}
		
		//---------------------------------------o
		//-- Bind core app signals Signals to the EventBus
		//---------------------------------------o
		static public function setup():void 
		{
			trace(StateMachine + " setup()");
			
/*			_core = Core.getInstance();
			_core.controlBus = new ControlBus;
			
			_core.controlBus.appUIController = new AppUIController(oStarlingStage);
			
			_core.controlBus.mapsController = new MapsController();
			
			_core.controlBus.achievementController = new AchievementController();
			_core.controlBus.achievementController.init();			
			
			_core.controlBus.inventoryController = new InventoryController();
			_core.controlBus.inventoryController.init();
			
			_core.controlBus.shopItemController = new ShopItemController();
			_core.controlBus.shopItemController.init();

			_core.controlBus.geolocationController = new GeolocationController();
			_core.controlBus.geolocationController.init();
												
			_core.controlBus.soundController = new SoundController();
			_core.controlBus.soundController.init();
			
			
			EventBus.getInstance().sigOnDeactivate = new Signal();
			EventBus.getInstance().sigOnDeactivate.add(evtOnDeactivate);
						
			EventBus.getInstance().sigOnDeviceActivate = new Signal();
			EventBus.getInstance().sigOnDeviceActivate.add(evtOnDeviceActivate);
			
			EventBus.getInstance().sigStarlingStageReady = new Signal();
			EventBus.getInstance().sigStarlingStageReady.addOnce(evtStarlingStageReady);
						
			EventBus.getInstance().sigScreenChangeRequested = new Signal(String);
			EventBus.getInstance().sigScreenChangeRequested.add(evtScreenChangeRequested);
				
			EventBus.getInstance().sigSubScreenChangeRequested = new Signal(String, String, ValueObject); //State, Direction, VO
			EventBus.getInstance().sigSubScreenChangeRequested.add(evtSubScreenChangeRequested);
					
			EventBus.getInstance().sigPlayClicked = new Signal(Boolean); //force Start
			EventBus.getInstance().sigPlayClicked.add(evtOnStartClicked)
												
			EventBus.getInstance().sigSlideMenuAction = new Signal(String);
			EventBus.getInstance().sigSlideMenuAction.add(evtSlideMenuAction);
												
			EventBus.getInstance().sigBackButtonClicked = new Signal();
			EventBus.getInstance().sigBackButtonClicked.add(evtBackButtonClicked);
			
			trace("===================================== SETUP FINISHED");

			checkForConnection();*/
			
			goToInitialState();
			
		}		
		
		static private function goToInitialState():void 
		{
			changeScreenState(PublicSettings.INITIAL_APP_STATE);
		}
		
		//=================================================o
		//-- Check for connection before procceeding
		//=================================================o
		static private function checkForConnection():void 
		{
/*			trace(StateMachine + "checkForConnection()");
			if (CoreMobile.isSupported())
			{
				//Network detected
				if (NativeUtil.checkNetworkAvailable())
				{
					//check if competition is active
					Services.getCompStatus.execute(true, false, checkForMasterPrizeList, null, function():void {
					
						//competition closed	
						_core.controlBus.appUIController.removeLoadingScreen(0);
						changeScreenState(STATE_APP_CLOSED)
						_core.controlBus.appUIController.setNotificationOverlays();
						
					});
					
				}
				//No network detected Aeroplane mode initializing
				else
				{
				
					UserServiceStatus.currentState = UserServiceStatus.STATE_LOGGED_OUT;	
					_core.controlBus.appUIController.showNotification(NotificationLabel.AEROPLANE_MODE, NotificationLabel.AEROPLANE_MODE_SUB, "PLAY ANYWAY", function():void {
						AppData.isGuest = true;
						showAgeGate();
						
					}, "RETRY", checkForConnection)
				}	
			}
			else
			{
				trace(StateMachine + "You are not on a mobile device");
				
				//check if competition is active
				if (PublicSettings.DEBUG_RELEASE == true)
				Services.getCompStatus.execute(true, false, checkForMasterPrizeList, null, function():void {
					
						//competition closed	
						_core.controlBus.appUIController.removeLoadingScreen(0);
						changeScreenState(STATE_APP_CLOSED)
						_core.controlBus.appUIController.setNotificationOverlays();
				});
					
				
			}	*/
			
			
		}
		
		
		//=================================================o
		//-- Check for Local Data and restore account data
		//=================================================o
		static private function checkUserLogin():void 
		{
/*			trace(StateMachine +"checkUserLogin ()");

			if (LocalData.email != null && LocalData.password != null)
			{
				trace(StateMachine + "checkUserLogin():Local Data Found!");
				
				Services.login.execute(LocalData.email, LocalData.password, true, false, function():void
				{
				
					PushNotificationUtil.initialize();
					
					if (DeviceSettings.isPushNotificationMuted)
					PushController.getInstance().muteNotifications();
					
					Services.loadPlayerData.execute(true, true, function():void
					{
					   changeScreenState(PublicSettings.INITIAL_GAME_STATE)();
							
					}, function():void 
					{
						//if load data from server fails, look for local save data
						if (LocalData.playerDataObj != null)
						{
							ApplicationController.restorePlayerData(showAgeGate)
						}	
					})
					
				}, 
				//on fail
				function():void 
				{
				    changeScreenState(PublicSettings.INITIAL_GAME_STATE);
				});
					
			}
			//There is no login local data, continue to app as new/unlogged user
			else
			{
				changeScreenState(PublicSettings.INITIAL_GAME_STATE);
				
			}*/
		}	
		
		
		
		
		//==========================================================o
		//----------------------------------------------------------o
		//----------------------------------------------------------o
		//----------------------------------------------------------o
		//----------------------------------------------------------o
		//----------------------------------------------------------o
		// Custom Event Callbacks via Signals
		//----------------------------------------------------------o
		
		static private function evtOnDeviceActivate():void 
		{
			
			trace(StateMachine + "evtOnDeviceActivate()");

			_core.starling.start();
			
			if (currentAppState == null)
			return;
			

		}

		static private function evtOnDeactivate():void 
		{
			
			//FacebookFPANE.deactivateApp();
			
			if (AppData.isCoreMobileSupported)
			{
				CoreMobile.mobile.cancelAllLocalNotifications();
			}
			
			if (PublicSettings.ENABLE_LOCAL_NOTIFICATIONS)
			scheduleNotifications();
			
			if (!allowDeviceDectivate)
			{
				_core.controlBus.soundController.disableMusic();	
				allowDeviceDectivate = true;
				return;
			}
			
			_core.controlBus.soundController.disableMusic();	
			
			if (currentAppState == STATE_GAME)
			{
				//evtOnTogglePause(true);
			}
			else
			{
				//android exit
				//NativeApplication.nativeApplication.exit();
			}
			
			_core.starling.stop();
			
			
		}
		
		static private function scheduleNotifications():void 
		{
			//------ Set local notifications
/*			if (AppData.isCoreMobileSupported)
			{
				AppData.pendingNotificationID = "1";
				CoreMobile.mobile.scheduleLocalNotification(1, CoreMobile.futureTimeSeconds(CoreMobile.WEEK * 2), LocalNotification.comeBack_title , LocalNotification.comeBack_message);
				 
				var dateOfNotification:Date = new Date(int(LocalNotification.notification2.year), int(LocalNotification.notification2.month), int(LocalNotification.notification2.day), int(LocalNotification.notification2.hour), int(LocalNotification.notification2.minute));
				var todaysDate:Date = new Date();
				
				var notifDateInSec:int = dateOfNotification.getTime() /1000;
				var todaysDateInSec:int = todaysDate.getTime() / 1000;
				
				//noficication date not yet reached, 
				if (notifDateInSec > todaysDateInSec)
				{
					if (ShopData.santaSuitAvailable)
					{
						var secsTillNotif:Number = (notifDateInSec - todaysDateInSec) ;
						CoreMobile.mobile.scheduleLocalNotification(2, CoreMobile.futureTimeSeconds(secsTillNotif), LocalNotification.newSuit_title, LocalNotification.newSuit_message);
						
						SharedObjects.setProperty(SharedObjectKeys.IS_NOTIFICATION_VIEWED_SUIT, true)
						LocalData.isNotificationViewed_suit = true;
					}
				}
				//notification date is passed
				else
				{
					
				}
			}*/
		}
		
		//==========================================================o
		//-- Custom Event : Stage Ready 
		//-- fires when the setup state manager 
		//--recives an iscompleted callbak from the StarlingStage
		//==========================================================o
		static public function evtStarlingStageReady():void
		{
			trace(StateMachine + "evtStarlingStageReady()")
			setup();
		}
		
		//==========================================================o
		//-- Custom Event :  Screen Change request
		//==========================================================o
		static public function evtScreenChangeRequested(newState:String):void
		{
			trace(StateMachine + "evtStateChangeRequested()" + newState)
			changeScreenState(newState);
			
		}
			


		//==========================================================o
		//-- Custom Event :  Menu Button Clicked
		//==========================================================o
		static private function evtSlideMenuAction(newState:String):void 
		{
/*			trace(StateMachine + "evtSlideMenuAction(" + newState + ")");
			trace(StateMachine + "_core.controlBus.appUIController.currSlideMenuState"+_core.controlBus.appUIController.currSlideMenuState);
			//if slide menu is closed
			if (_core.controlBus.appUIController.currSlideMenuState == SlideOutMenu.STATE_CLOSE)
			{
			currentScreenObject.deactivate();
			}
			//if slide menu is open
			else
			{

			}
			_core.controlBus.appUIController.changeSlideMenuStatus(newState);*/
			
		}
				
		//==========================================================o
		//-- Custom Event :  Screen Change request
		//==========================================================o
		static private function evtBackButtonClicked():void 
		{
			trace(StateMachine + "evtBackButtonClicked()")
			
			if (currentScreenObject.currMenuLevel == 1)
			changeScreenState(STATE_HOME);
			else
			currentScreenObject.changeSubScreen(currentScreenObject.prevSubScreenState, null, SuperScreen.TRANSITION_TYPE_LEFT);
		}
			

		
		//==========================================================o
		//==========================================================o	
	   /* 
		*-----------------------------------------------------------o
		*
		*    ***Finite State Machine Switch***
		* As3 Signals are used for dispatching 
		* state altering events 
		* 
		*-----------------------------------------------------------o
		*/
		//==========================================================o
		//==========================================================o
		
		protected static function changeScreenState(newState:String, subState:String = null, vo:ValueObject = null, forcePlay:Boolean = false, isRestaringGame:Boolean = false):void
		{

			trace(StateMachine + "changeScreenState(" + newState + ")");
			switch(newState)
			{
								

				
				//------------------------------------------------------------------------------------o
				case STATE_MINE:
					
					
					SoundAS.stopAll();
					
					//_core.controlBus.gameHUDController = new HUDController();
					//_core.controlBus.mapsController = new MapsController();
					
					_oMineScreen = new MineScreen();
					
					//if (!Core.getInstance().starling.isStarted)
					//Core.getInstance().starling.start();
					
					currentAppState = newState;
					currentScreenObject = _oMineScreen;
					
				break;
				

			}
			
			stateLoaded();
			
			
		}
		

		//==========================================================o
		//- State Loaded Callback From AssetStateMachine
		//==========================================================o
		static public function stateLoaded():void 
		{
			trace(StateMachine + "stateLoaded():" + currentAppState + " has loaded");
			
/*			if (currentScreenObject.showTitleBar)
			_core.controlBus.appUIController.addTitlebar(currentScreenObject.displayName, currentScreenObject.showBackButton);
			else
			_core.controlBus.appUIController.removeTitleBar();
			
			if (currentScreenObject.showMenuIcon)
			_core.controlBus.appUIController.showMenuButton(currentScreenObject.menuIconState);
			
			if (currentScreenObject.showLoadingScreen)
			_core.controlBus.appUIController.showLoadingScreen("LOADING", false, HexColours.NAVY_BLUE);
						
			if (currentScreenObject.enableTimeOutPopup)
			_core.controlBus.appUIController.setTimeOutPopup();
				
			

			if (_quDummyFill != null)
			{
			_quDummyFill.removeFromParent();
			_quDummyFill = null;
			}
			//--------------o
*/
			if (currentScreenObject)
			{
				currentScreenObject["loaded"]();
				
				oStarlingStage.addChildAt(currentScreenObject, 0);
			
				//if (!currentScreenObject.manualRemoveDim)
				//_core.controlBus.appUIController.removeFillOverlay();
			}
			
			
		}
		

		


		
	}

}