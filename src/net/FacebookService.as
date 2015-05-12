package net 
{

	import com.johnstejskal.SharedObjects;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.milkmangames.nativeextensions.events.GVShareEvent;
	import com.milkmangames.nativeextensions.GoViral;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.social.facebook.FacebookFriend;
	import com.thirdsense.social.FacebookFPANE;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.display.BitmapData;
	import ManagerClasses.StateMachine;
	import net.mediators.competitionServices.status.CompetitionServiceStatus;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.PlayerData;
	import staticData.HeaderLabels;
	import staticData.HexColours;
	import staticData.LoadingLabel;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class FacebookService 
	{
		static private var _onSuccess:Function;
		static private var _onFail:Function;
		static private var _core:Core = Core.getInstance();
		static private var _callLogin:Boolean;
		static private var _callShare:Boolean;
		static private var _onPostToWallFail:Function;
		static private var _onPostToWallSuccess:Function;
		
		public function FacebookService() 
		{
			
		}
		
		//=================================================o
		//-- Check if previous user had facebook connected
		//=================================================o
		static public function connectToFacebook(onSuccess:Function = null, onFail:Function = null, callLogin:Boolean = false, callShare:Boolean = false):void 	
		{
			trace(FacebookService+"connectToFacebook()");
			_onSuccess = onSuccess;
			_onFail = onFail;
			_callLogin = callLogin;
			_callShare = callShare;

			_core.controlBus.appUIController.showLoadingScreen(LoadingLabel.LOADING , true, HexColours.NAVY_BLUE);
			
			StateMachine.allowDeviceActivate = false;
			StateMachine.allowDeviceDectivate = false;
			
			var success:Boolean = FacebookFPANE.init(onFacebookInit)
							
			if (!success)
			{
				trace(FacebookService+"Could not initiate FB");
				
			}
			
		}	
			
		//=================================================o
		//-- Facebook init
		//=================================================o
		private static function onFacebookInit():void 
		{
			trace(FacebookService+"onFacebookInit()");
			
			//if session exists
			if (FacebookFPANE.getSession())
			{ 
				trace(FacebookService + "session exists");
				FacebookFPANE.getFriendsList(onGetFriends)
			}
			//user hasnt activated this app
			else
			{
				trace(FacebookService + "no session exists");
				
				if (_callLogin)
				{
					trace(FacebookService + "no session exists, calling login");
					FacebookFPANE.login(onFaceBookLogin, ["email", "user_friends" ])
				}
				else
				{
					trace(FacebookService + "no session exists, calling fail");
					_core.controlBus.appUIController.removeLoadingScreen();
					if(_onFail != null)	
					_onFail();
				}
			}
		}
		
		
		public static function reconnectSession():void
		{
			
			if (FacebookFPANE.getSession())
			{ 
				trace(FacebookService + "session exists");
				FacebookFPANE.getFriendsList(onGetFriends)
			}
			else
			{
				
			}
		}
		
		//=================================================o
		//-- Facebook Login response handler, success or fail
		//=================================================o
		private static function onFaceBookLogin(success:Boolean):void 
		{

			trace(FacebookService + "onFaceBookLogin:success:" + success);
			
			if (success)
			{
			    //login successful
			    FacebookFPANE.getFriendsList(onGetFriends)
				PlayerData.facebookID = FacebookFPANE.getSession().userId
				PlayerData.firstName = FacebookFPANE.getSession().firstName;
				PlayerData.lastName = FacebookFPANE.getSession().lastName;
				PlayerData.email = FacebookFPANE.getSession().email;		
				trace(FacebookService + "onFaceBookLogin: success!");
				
			}
			else
			{
				_core.controlBus.appUIController.removeLoadingScreen();
				//todo if user cancelled
				if (!FacebookFPANE.isCancelledByUser)
				{
					_core.controlBus.appUIController.showNotification("WHOOPS", "Something went wrong, please try again later", "OK", null, null, null, 1)
				}
				else
				{
					FacebookFPANE.isCancelledByUser = false;
					if(_onFail != null)	
					_onFail();	
				}
				trace(FacebookService+" FB connection unsuccessful");
			}
		}
				

		//===================================================o
		public static function checkPermissions(callback:Function = null):void 
		{
			trace(FacebookService + "checkPermissions" );
			_core.controlBus.appUIController.showLoadingScreen(LoadingLabel.LOADING , true, HexColours.NAVY_BLUE);
			
			if (callback != null)
			_onSuccess = callback;
			
			FacebookFPANE.getPermissions( onCheckFPCurrentPermissions );
		}
		
		
		private static function onCheckFPCurrentPermissions(success:Boolean, data:Object):void 
		{
			trace( "onCheckFPCurrentPermissions" );
			trace( JSON.stringify(data) );
			
			if ( success )
			{
				var match:Boolean = false;
				
				var jsonString:String = JSON.stringify(data.data)
				
				trace("jsonString :" + jsonString);
				if (jsonString.indexOf("publish_actions") != -1)
				match = true;
				
				
				for ( var str:String in data.data[0] )
				{
					trace("data.data[0].permission:" + data.data[0]);
					if ( str == "publish_actions" || data.data[0][str] == 1 )
					{
						match = true;
					}
				}
				
				if ( match )
				{
						trace(FacebookService+ "publish_actions found. Completing login" );
						if (_onSuccess != null)
								_onSuccess();
						}
				else
				{
					// request permission
					trace(FacebookService+ "publish_actions not found. Requesting permission from user" );
					StateMachine.allowDeviceDectivate = false;
					StateMachine.allowDeviceActivate = false;
					FacebookFPANE.requestPermissions( ["publish_actions"], onRequestAdditionalPermissions );
				}
			}
			else
			{
				_core.controlBus.appUIController.showNotification("WHOOPS", "Something went wrong, please try again later", "OK", null, null, null, 1)
				
				if (_onFail != null)
				_onFail();
			}
		}
		
		
		private static function onRequestAdditionalPermissions( success:Boolean, data:Object ):void 
		{
			trace( "onRequestAdditionalPermissions :: Success - " + success );
			trace( JSON.stringify(data) );
			
			//this.onFacebookFPANELogin( success );
			if (success)
			{
				if (_onSuccess != null)
				_onSuccess();
			}
			else
			{
				_core.controlBus.appUIController.removeLoadingScreen();
				if (_onFail != null)
				_onFail();
				
			}
			
		}
		

		
		//======================================================p
		
		
		//=================================================o
		//-- get friends
		//=================================================o
		private static function onGetFriends(success:Boolean):void 
		{
			trace(FacebookService+" onGetFriends:"+success);
			if (success)
			{
			   //onGetFriends successful
				PlayerData.facebook_ids = FacebookFriend.getAllFriendIDs();	
				trace("12345: PlayerData.facebook_ids" + PlayerData.facebook_ids);
			}
			else
			{
			  //onGetFriends unsuccessful
			}	
			
			
			
			if (_onSuccess != null)
			_onSuccess();
		}

		
		//=================================================o
		//-- Check if previous user had facebook connected
		//=================================================o
		static public function postToWall(onSuccess:Function = null, onFail:Function = null):void 	
		{
			
			StateMachine.allowDeviceDectivate = false;
			StateMachine.allowDeviceActivate = false;
			
			if(CompetitionServiceStatus.currentState == CompetitionServiceStatus.STATE_IS_ACTIVE)
			FacebookFPANE.openDialog("https://s3.amazonaws.com/3rdsense.static/images/fbpic.png", HeaderLabels.FB_SHARE_POST_NAME, HeaderLabels.FB_SHARE_POST_LINK, HeaderLabels.FB_SHARE_CAPTION, HeaderLabels.FB_SHARE_DESCRIPTION_COMP_ON, "", onShareComplete)
			else
			FacebookFPANE.openDialog("https://s3.amazonaws.com/3rdsense.static/images/fbpic.png", HeaderLabels.FB_SHARE_POST_NAME, HeaderLabels.FB_SHARE_POST_LINK, HeaderLabels.FB_SHARE_CAPTION, HeaderLabels.FB_SHARE_DESCRIPTION_COMP_OFF, "", onShareComplete)
			
			_onPostToWallSuccess = onSuccess;
			_onPostToWallFail = onFail;
			return;


		}
		

		static private function onShareComplete(data:Object):void 
		{
			trace(FacebookService + "onShareComplete(),data:" + data);
			
			_core.controlBus.appUIController.removeLoadingScreen();
			
			if (data.cancel)
			{
				trace(FacebookService + "cancelled by user");
			}
			else if (data.params)
			{
				trace(FacebookService + "success");
				Core.getInstance().controlBus.appUIController.showNotification("SUCCESS!", "You deeeed it. Pat yourself on the back, unless you’re in public. You don’t want to look arrogant or anything.", "OK", function():void {
								
					if (StateMachine.currentAppState == StateMachine.STATE_GAME_LANDING)
					_core.controlBus.appUIController.showMenuButton("stateDefault", true);
					
				}, null, null, 1);
				
				if (_onPostToWallSuccess != null)
				{
					trace(FacebookService + "calling _onPostToWallSuccess");
					_onPostToWallSuccess();
					_onPostToWallSuccess = null;
				}				
				
			}

		}
			
		
		//=================================================o
		//-- Check if previous user had facebook connected
		//=================================================o
		static public function postImage(bitmap:BitmapData, message:String, onSuccess:Function = null, onFail:Function = null):void 	
		{
			Core.getInstance().oDebugPanel.setTrace(FacebookService+"postImage()");
			_core.controlBus.appUIController.showLoadingScreen(LoadingLabel.LOADING , true, HexColours.NAVY_BLUE);
			var success:Boolean = FacebookFPANE.uploadLocalImage(bitmap, message, onPostImageComplete, false)
			if (!success)
			{
				_core.controlBus.appUIController.removeLoadingScreen();
				
				if (StateMachine.currentAppState == StateMachine.STATE_GAME_LANDING)
				_core.controlBus.appUIController.showMenuButton();
			}	
		}
		
		static private function onPostImageComplete(success:Boolean):void 
		{
			trace("FacebookServices onPostImageComplete() success:"+success);
			_core.controlBus.appUIController.removeLoadingScreen();
			
			if (success)
			{
			Core.getInstance().controlBus.appUIController.showNotification("SUCCESS!", "You deeeed it. Pat yourself on the back, unless you’re in public. You don’t want to look arrogant or anything.", "OK", function():void {
					if (StateMachine.currentAppState == StateMachine.STATE_GAME_LANDING)
					_core.controlBus.appUIController.showMenuButton("stateDefault",true);
			}, null, null, 1);
			PlayerData.timesShared ++;
			_core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_SHARED, null, PlayerData.timesShared)
			}else
			{
			_core.controlBus.appUIController.showNotification("FB PROBS", "Could not share right now, try again later", "OK", function():void {
					if (StateMachine.currentAppState == StateMachine.STATE_GAME_LANDING)
					_core.controlBus.appUIController.showMenuButton("stateDefault",true);
				}, null, null, 1)
			}
			//not firing , moved code to FacebookFPANE
		}
		
		
	}

}