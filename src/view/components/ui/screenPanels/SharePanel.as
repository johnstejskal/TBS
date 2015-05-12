package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.social.FacebookFPANE;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.FacebookService;
	import net.mediators.competitionServices.status.CompetitionServiceStatus;
	import net.mediators.userServices.status.UserServiceStatus;
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
	import staticData.AppSettings;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.PlayerData;
	import staticData.DeviceType;
	import staticData.HeaderLabels;
	import staticData.LoadingLabel;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.valueObjects.PlayerVO;
	import staticData.valueObjects.PrizeVO;
	import view.components.screens.LoginScreen;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShareMsgScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	//=======================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//=======================================o
	
	public class SharePanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "SharePanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simContent:Image;
		private var _simShareEmail:Image;
		private var _simShareFB:Image;
		private var _tt:TrueTouch;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function SharePanel() 
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
			_tt = new TrueTouch();
			
			trace(this + "inited");
			var h:int;
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("share")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentShare") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentShare", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentShare").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//share FB btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_facebookPanelBtn") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_facebookPanelBtn", null, 1, 1, null, 0)
			_simShareFB = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_facebookPanelBtn").getImage();
			_simShareFB.x = 0;
			_simShareFB.y = _simContent.y + _simContent.height;
			this.addChild(_simShareFB);
						
			//--------o
			//share email btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "EMAIL INVITE";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simShareEmail = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simShareEmail.x = 0;
			_simShareEmail.y = _simShareFB.y + _simShareFB.height;
			this.addChild(_simShareEmail);
			
			mc = null;
			_simShareFB.addEventListener(TouchEvent.TOUCH, onTouch)
			_simShareEmail.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
					
					switch(e.target)
					{
						case _simShareEmail:
						
						StateMachine.allowDeviceDectivate = false;
						StateMachine.allowDeviceActivate = false;	
							
						var name:String = "";
						if (PlayerData.firstName != null)
						name = PlayerData.firstName;
						
						if(CompetitionServiceStatus.currentState == CompetitionServiceStatus.STATE_IS_ACTIVE)
						Util.openURL("mailto:?subject=Here’s something saucy for you...&body="+HeaderLabels.EMAIL_SHARE_COMP_ON)	
						else
						Util.openURL("mailto:?subject=Here’s something saucy for you...&body="+HeaderLabels.EMAIL_SHARE_COMP_OFF)	
						
						PlayerData.timesShared ++;
						_core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_SHARED, null, PlayerData.timesShared)
						
						if(PublicSettings.ENABLE_ANALYTICS)
						Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHARE_SCREEN, AppSettings.EMAIL_SHARE_BUTTON, 1);
						break;
						
						
						//====================================o
						
						case _simShareFB:
						
						postToWall();

						break;
						
					}
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		private function postToWall():void
		{
			trace(this + "postToWall()");
			FacebookFPANE.init(function():void	{
				FacebookService.postToWall(onPostSuccess, onPostFail);
			})
		}
		
		private function onPostFail():void 
		{
			trace(this + "onPostFail")
			_core.controlBus.appUIController.showNotification("FB PROBS", "Could not share right now, try again later", "OK", null, null, null, 1)
			EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_SHARE)
		}
		
		private function onPostSuccess():void 
		{
			trace(this + "onPostSuccess")
			EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_SHARE)
						
			PlayerData.timesShared ++;
			_core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_SHARED, null, PlayerData.timesShared)
			
			if(PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHARE_SCREEN, AppSettings.FACEBOOK_SHARE_BUTTON, 1);
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