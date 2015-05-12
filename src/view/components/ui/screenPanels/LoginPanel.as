
package view.components.ui.screenPanels 
{

	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.social.facebook.FacebookFriend;
	import com.thirdsense.social.FacebookFPANE;
	import com.thirdsense.social.FacebookInterface;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.utils.setTimeout;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.FacebookService;
	import net.mediators.competitionServices.status.CompetitionServiceStatus;
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
	import staticData.dataObjects.PlayerData;
	import staticData.DeviceType;
	import staticData.LoadingLabel;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SharedObjectKeys;
	import staticData.SpriteSheets;
	import staticData.valueObjects.PlayerVO;
	import view.components.screens.LoginScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class LoginPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "LoginPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _simRegisterBtn:Image;
		private var _simEmailLoginBtn:Image;
		private var _simFBLoginBtn:Image;
		private var _tt:TrueTouch;
		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function LoginPanel() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_tt = new TrueTouch();
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
			var h:int;
			
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("about")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_loginPanelContent") as MovieClip;
			
			if(CompetitionServiceStatus.currentState == CompetitionServiceStatus.STATE_NOT_ACTIVE)
			mc.$txLabel.text = "Sign up and login to save your progress, buy Drop Shop stuff to enhance your game and submit scores to the leaderboard."
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_loginPanelContent", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_loginPanelContent").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//FB login button
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_facebookLoginBtn") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_facebookLoginBtn", null, 1, 1, null, 0)
			_simFBLoginBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_facebookLoginBtn").getImage();
			
			_simFBLoginBtn.x = 0;
			_simFBLoginBtn.y = _simContent.y + _simContent.height;
			
			this.addChild(_simFBLoginBtn);
			
			//--------o
			//email login
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "EMAIL LOGIN";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simEmailLoginBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simEmailLoginBtn.x = 0;
			_simEmailLoginBtn.y = _simFBLoginBtn.y + _simFBLoginBtn.height;
			this.addChild(_simEmailLoginBtn);
			
			//--------o
			//button Register
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleLightBlueBtn") as MovieClip;
			mc.$txLabel.text = "REGISTER";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn", null, 1, 1, null, 0)
			_simRegisterBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn").getImage();
			
			_simRegisterBtn.x = 0;
			_simRegisterBtn.y = _simEmailLoginBtn.y + _simEmailLoginBtn.height;
			
			this.addChild(_simRegisterBtn);
			
			
			
			
			mc = null;
			
			_simFBLoginBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			_simEmailLoginBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			_simRegisterBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
							case _simFBLoginBtn:
								_core.controlBus.appUIController.showLoadingScreen(LoadingLabel.LOADING, true, HexColours.NAVY_BLUE);

								if (FacebookFPANE.getSession())
								{
									var success:Boolean = FacebookFPANE.init(onFacebookInit)
									if (!success)
									{
										trace(this + "failed to init Failed");
									}
								}
								else
								{
									FacebookService.connectToFacebook(onFacebookConnect, null, true);	
								}
								if(PublicSettings.ENABLE_ANALYTICS)
								Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.LOGIN_SCREEN, AppSettings.LOGIN_WITH_FACEBOOK , 1);
								
							break;
							
							case _simEmailLoginBtn:
							EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_EMAIL_LOGIN, SuperScreen.TRANSITION_TYPE_RIGHT, null)
							break;
							
							case _simRegisterBtn:
							if(PublicSettings.ENABLE_ANALYTICS)
							Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.LOGIN_SCREEN, AppSettings.REGISTER_WITH_EMAIL_BUTTON , 1);
						
							EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)
							break;
						}

                }

                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		
		private function onFacebookConnect():void 
		{
			Services.checkForUser.execute(PlayerData.facebookID, null, true, true, function():void
			{
				trace(LoginPanel+"Server has found user with FB id:\n"+PlayerData.facebookID)
				//on success
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_LOGIN, SuperScreen.TRANSITION_TYPE_RIGHT, null)
					
			}, 
			//no user found for specified FB ID, possible id change.
			function():void
			{
				trace(LoginPanel + "No user found on Server with this FB id:\n" + PlayerData.facebookID)
				if (PlayerData.email != null)
				{
					Services.checkForUser.execute(null, PlayerData.email, true, true, function():void
					{
						trace(LoginPanel+"Server has found user with  email:\n"+PlayerData.email)
						//on success
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_LOGIN, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						StateMachine.pendingLoginCallback = updatePlayerProfile;
					}, 
					//no user found in Database for facebook id or email
					function():void
					{
						trace(LoginPanel+"No user found on Server with this FB id:\n"+PlayerData.facebookID+ " or email:"+PlayerData.email)
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)
					})
				}
				else 
				{
					EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)
				}
			
			})
		}
		
		private function updatePlayerProfile():void 
		{
			trace(this + "updatePlayerProfile()");
			var playerVO:PlayerVO = new PlayerVO();
			playerVO.facebook_id = PlayerData.facebookID;
			playerVO.firstName = PlayerData.firstName;
			playerVO.lastName = PlayerData.lastName;
			playerVO.email = PlayerData.email;
			playerVO.marketing_opt_in = PlayerData.marketing_opt_in;
			playerVO.password = PlayerData.password;
			playerVO.player_id = PlayerData.player_id;
			playerVO.postcode = PlayerData.postcode;
			playerVO.device_type =  DeviceType.deviceManufacturer;
				
			Services.updateProfile.execute(playerVO, true, true, null, null, false);
		}
		
		
/*		private function onFacebookConnect():void 
		{
			Services.checkForUser.execute(PlayerData.facebookID, PlayerData.email, true, true, function():void
			{
				trace(LoginPanel+"Server has found user with FB id:\n"+PlayerData.facebookID)
				//on success
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_LOGIN, SuperScreen.TRANSITION_TYPE_RIGHT, null)
					
			}, 
			function():void
			{
				trace(LoginPanel+"No user found on Server with this FB id:\n"+PlayerData.facebookID)
				//on fail	
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)	
			})
		}*/
		
		
		private function onFacebookInit():void 
		{
			trace(this+"onFacebookInit()");
		
			if (!FacebookFPANE.getSession())
			{
				trace(this+"getSession():"+FacebookFPANE.getSession());
				FacebookFPANE.login(onFaceBookLogin, ["email", "user_friends" ])
			}
			else
			{
				trace(this+"exisitng FB connection PlayerData.firstName"+PlayerData.firstName);
				FacebookFPANE.getFriendsList(onGetFriends)
				
				//TODO does this connect call need to be here if there is already a session detected?
				//FacebookService.connectToFacebook(onFacebookConnect, null, true);		
			}
			
		}
		
		private function onFaceBookLogin(success:Boolean):void 
		{
			trace("onFaceBookLogin:success:"+success);
			if (success)
			{
			   //login successful
			   FacebookFPANE.getFriendsList(onGetFriends)
			   
				PlayerData.facebookID = FacebookFPANE.getSession().userId;
				PlayerData.firstName = FacebookFPANE.getSession().firstName;
				PlayerData.lastName = FacebookFPANE.getSession().lastName;
				PlayerData.email = FacebookFPANE.getSession().email;
				
				trace("onFaceBookLogin: success!");
				
				Services.checkForUser.execute(PlayerData.facebookID, PlayerData.email, true, true, function():void
				{
					//TODO if facebook id does not equal 
					//#################
					trace(this+"Server has found user with FB id:\n"+PlayerData.facebookID)
					//on success
					EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_LOGIN, SuperScreen.TRANSITION_TYPE_RIGHT, null)
					
				}, 
				function():void
				{
					trace(this+"No user found on Server with this FB id:\n"+PlayerData.facebookID)
					//on fail	
					EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)	
				})
				
			}
			else
			{
				trace(" FB connection unsuccessful");
			}
		}
		
		private function onGetFriends(success:Boolean):void 
		{
			if (success)
			{
			   //onGetFriends successful
				PlayerData.facebook_ids = FacebookFriend.getAllFriendIDs();	
				SharedObjects.setProperty(SharedObjectKeys.FACE_BOOK_FRIENDS, PlayerData.facebook_ids);
			}
			else
			{
			  //onGetFriends unsuccessful
				
			}	

		}
		
		private function onFacebookClose():void 
		{
			//facebook closed, init new state
		}

		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			_tt.trash();
			_tt = null;
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}