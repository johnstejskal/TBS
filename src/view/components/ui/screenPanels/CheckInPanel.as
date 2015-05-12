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
	import com.thirdsense.net.Analytics;
	import com.thirdsense.social.FacebookFPANE;
	import feathers.controls.ButtonGroup;
	import flash.text.SoftKeyboardType;
	import ManagerClasses.AssetsManager;
	import net.mediators.userServices.status.UserServiceStatus;
	import staticData.AppSettings;
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.ShopData;
	import staticData.Sounds;
	import staticData.valueObjects.ShopItemVO;
	import staticData.valueObjects.StoreVO;
	import treefortress.sound.SoundAS;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;

	import ManagerClasses.StateMachine;
	import net.Services;
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
	import staticData.NativeModalInputGroups;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class CheckInPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "CheckInPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _ffInput:FormField;
		private var _simSubmitBtn:Image;
		private var _tt:TrueTouch;
		private var _code:String = "mcrich";
		private var _spEmail:FormField;
		private var _initComplete:Function;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function CheckInPanel(initComplete:Function = null) 
		{
			trace(this + "Constructed");
			_initComplete = initComplete;
			_core = Core.getInstance();
			
		//	if (stage) init(null);
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			init();
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event = null):void 
		{
			trace(this + "inited");
			
			_tt = new TrueTouch();
			
			var h:int;
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("checkIn")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			var ref:String = "TA_contentCheckIn";
			if(UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_OUT)
			ref = "TA_contentCheckInLoggedOut";
			
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, ref) as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, ref, null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, ref).getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//button Footer
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			
			if (UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_IN)
			mc.$txLabel.text = "CHECK IN";
			else
			mc.$txLabel.text = "SIGN UP";
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simSubmitBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simSubmitBtn.x = 0;
			_simSubmitBtn.y = _simContent.y + _simContent.height;
			
			this.addChild(_simSubmitBtn);
			mc = null;
			
			
			_simSubmitBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			
			if (_initComplete)
			_initComplete();
			
		}

		private function updateHeaderImage(frame:String):void
		{
			var framelabel:String = "questionMark";
			if (frame != null)
			framelabel = frame;
			
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, "TA_shortHeader");
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop(framelabel)
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);	
		}
		
		//=======================================o
		//-- On Touch Event handler
		//=======================================o
		private function onTouch(e:TouchEvent):void 
		{
			
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
				
                if(touch.phase == TouchPhase.BEGAN)
                {	
					_tt.mapTouch(touch);
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					if (!_tt.checkTouch(touch))
					return;
					
					if (e.target == _simSubmitBtn)
					{
						if (UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_IN)
						_core.controlBus.geolocationController.updateGeolocation(onGeoUpdated, onGeoFailed, onGeoMuted);
						else
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_LOGIN)
						
					}
                }
 
            }
			
		}
		
		//==================================================o
		//-- geo location updated, check if in store proximity;
		//==================================================o
		private function onGeoUpdated():void 
		{
			trace(this + "onGeoUpdated()");
			
			
			var storeVO:StoreVO = _core.controlBus.geolocationController.getNearestStoreVO();
			_core.controlBus.geolocationController.resetUserCoordinates();
		
			if (storeVO != null)
			{
			trace("storeVO.DISTANCE FROM USER :"+storeVO.DISTANCE_FROM_USER)
			checkIn(storeVO);
			}
			else
			{
			_core.controlBus.appUIController.showNotification("WHERE ARE YOU?", "Here’s how to check in… \n1. Make sure you are in a Macca’s® restaurant. \n2. Make sure your location services are turned on \n3. Make sure you have a net connection \n4. Standing on one foot sometimes helps too", "GOT IT", null, null, null, 1);
					if (PublicSettings.ENABLE_ANALYTICS)
					Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.CHECK_IN_SCREEN, AppSettings.CHECK_IN_FAIL_LOCATION, 1);	
			}
		}
		
		private function onGeoMuted():void 
		{
			trace(this + "onMuted");
			_core.controlBus.appUIController.removeLoadingScreen();
			_core.controlBus.appUIController.showNotification("WHERE ARE YOU?", "Go turn on your GPS then come back", "OK", function():void {
				EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);	
			}, null, null, 1)  
			
		}
		
		private function onGeoFailed():void 
		{
			trace(this+"onGeoFailed")
			_core.controlBus.appUIController.removeLoadingScreen();
			EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);
			
		}
		
		private function checkIn(storeVO:StoreVO):void 
		{
			Services.checkIn.execute(storeVO, true, true, onCheckInComplete);
		}
		
		private function onCheckInComplete(storeVO:StoreVO = null):void 
		{
			trace(this+"onCheckInComplete :");
			_core.controlBus.appUIController.showNotification("YOU CHECKED IN", "You’ve just got 2000 game coins for checking in at: \n"+storeVO.TITLE +" Why not celebrate with a few Chicken McNuggets® on the side.", "GOT IT", null, null, null, 1);
			_core.controlBus.inventoryController.addMoney(2000, true)
			SoundAS.playFx(Sounds.SFX_CASH_REGISTER);
			FacebookFPANE.logAppEvent("CheckedIn");
			
			if (PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.CHECK_IN_SCREEN, AppSettings.CHECK_IN_SUCCESSFUL, 1);	
						
		}
		
		private function onFail():void 
		{
			
		}
		
		private function onSuccess(amount:Number):void 
		{
			trace(this + "---------------------code redeemed");
			//SoundAS.playFx(Sounds.SFX_CASH_REGISTER, 1);	


		}


		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			_tt.trash();
			_tt = null;
			
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}