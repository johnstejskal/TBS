package ManagerClasses
{
	//import com.lookaflyingdonkey.nativeExtensions.NewRelic;
	import air.net.URLMonitor;

	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.Util;
	import com.milkmangames.nativeextensions.CoreMobile;

	import com.thirdsense.data.LPLocalData;
	import com.thirdsense.settings.Profiles;

	import com.thirdsense.utils.StringTools;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import net.AppServices;
	import net.RemoteServices;
	import singleton.Core;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.textures.Texture;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.StoreLocationData;
	import staticData.HeaderLabels;
	import staticData.LocalData;
	import staticData.Constants;
	import staticData.AppData;
	import staticData.DeviceType;
	import staticData.LocalData;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import staticData.valueObjects.AchievementVO;
	import staticData.XMLData;

	
	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	
	public class Config
	{
		private var _core:Core;
		private var _stage:Stage;
		private var loader:Loader;
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function Config()
		{
			trace(this + "constructed");
			_core = Core.getInstance();
			_stage = _core.main.stage;
			_core.nativeStage = _core.main.stage;
			
			//SET SPRITE SHEET CLASS LOCATION WITHIN AssetsManager
			AssetsManager.SPRITE_SHEET_CLASS = SpriteSheets;
			
			AppData.badWordsSource = new XMLData.BadWords;
			var str:String = AppData.badWordsSource.toString();
			
			AppData.badWords = str.split(",")

			setup();
		}
		
		private function setup():void
		{
			trace(this + "setup()");
			_core.animationJuggler = new Juggler();
			
			if (PublicSettings.DEBUG_RELEASE)
				PublicSettings.DEVICE_RELEASE = true;
			
			if (PublicSettings.DEVICE_RELEASE)
			{
				if (DeviceSettings.KEEP_DEVICE_AWAKE)
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

				Multitouch.inputMode = DeviceSettings.TOUCH_INPUT_MODE;
				
				AppData.deviceResX = _stage.fullScreenWidth;
				AppData.deviceResY = _stage.fullScreenHeight;
			}
			else
			{
				AppData.deviceResX = _stage.stageWidth;
				AppData.deviceResY = _stage.stageHeight;
			}
			
			if (PublicSettings.DEBUG_RELEASE)
			{
				AppData.deviceResX = _stage.stageWidth;
				AppData.deviceResY = _stage.stageHeight;
			}
			else
			{
				
			}
			
			AppData.baseResX = Constants.BASE_RES_X;
			AppData.baseResY = Constants.BASE_RES_Y;
			
			AppData.deviceScaleX = AppData.deviceResX / AppData.baseResX;
			AppData.deviceScaleY = AppData.deviceResY / AppData.baseResY;
			AppData.deviceScale = AppData.deviceScaleX; 
			AppData.offsetScaleX = AppData.deviceResX / Constants.LAYOUT_RES_X;
			AppData.offsetScaleY = AppData.deviceResY / Constants.LAYOUT_RES_Y;
			
			
			DeviceType.setDeviceType(AppData.deviceResX, AppData.deviceResY);
			
			if(CoreMobile.isSupported())
			{
				// call this once at app start up, then CoreMobile will be available for use from then on.
				//AppData.isCoreMobileSupported = true;
				//CoreMobile.create();
				//CoreMobile.mobile.registerForNotifications();
				//NativeApplicationRaterUtil.init();
				
			}
			else {
				trace("Core Mobile only works on iOS or Android.");
			}
			
			
			MobileSoftKeys.init();

			//======================================o
			//-- start remote services for launchpad
			//======================================o
			RemoteServices.init();
			
			//======================================o
			//-- Retreive Local Saved Data	
			//======================================o
			//SharedObjects.init();
			
			//if(!PublicSettings.ENABLE_LOCAL_STORAGE)	
			//SharedObjects.deleteAll();
			
			
			//SharedObjects.registerData();
			
/*			if (!PublicSettings.DEBUG_RELEASE)
			{
				FacebookFPANE.init();
			}*/
			
			//======================================o
			//-- Init Push Notif
			//======================================o	
			
			
			
			//======================================o
			//-- Set Language Specific Data
			//======================================o

			//var labels:Object = JSON.parse(new XMLData["Labels_"+PublicSettings.LOCATION]());
			//HeaderLabels.populate(labels);

			
		}

	
	}

}