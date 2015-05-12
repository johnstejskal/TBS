package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.controllers.PushController;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
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
	import staticData.dataObjects.PlayerData;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SharedObjectKeys;
	import staticData.SoundData;
	import staticData.SpriteSheets;
	import view.components.screens.LoginScreen;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.CustomCheckBox;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class SettingsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "SettingsPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _oCheckBox1:CustomCheckBox;
		private var _spContentArea:Sprite;
		private var _oCheckBox2:CustomCheckBox;
		private var _oCheckBox3:CustomCheckBox;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function SettingsPanel() 
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
			
			trace(this + "inited");
			var h:int;
			
			_core.oDebugPanel.setTrace("YAYA_PlayerData.facebook_ids:"+PlayerData.facebook_ids);
			//-----------------------o
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("cog")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-----------------------o
			//content Area
			_spContentArea = new Sprite();
			_spContentArea.y = _simTop.y + h;
			
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentSettings") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentSettings", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentSettings").getImage();
			_spContentArea.addChild(_simContent);
			
			
			
			trace("SoundData.isSFXMuted :" + SoundData.isSFXMuted);
			//checkBox 1-----------------------------------------------o
			var defaultSFXState:String;
			if (SoundData.isSFXMuted)
			defaultSFXState = CustomCheckBox.STATE_OFF;
			else
			defaultSFXState = CustomCheckBox.STATE_ON;
			
			trace(this + "defaultSFXState :" + defaultSFXState)
			
			_oCheckBox1 = new CustomCheckBox(1, _core.controlBus.soundController.toggleSoundFX, defaultSFXState );
			_oCheckBox1.x = 378;
			_oCheckBox1.y = 118;
			_spContentArea.addChild(_oCheckBox1)
			
			//checkBox 2------------------------------------------------o
			var defaultVibrationState:String;
			if (DeviceSettings.isVibrationMuted)
			defaultVibrationState = CustomCheckBox.STATE_OFF;
			else
			defaultVibrationState = CustomCheckBox.STATE_ON;
			
			trace(this+"defaultVibrationState :"+defaultVibrationState)
			
			_oCheckBox2 = new CustomCheckBox(2, toggleVibration, defaultVibrationState );
			_oCheckBox2.x = 378;
			_oCheckBox2.y = 193;
			_spContentArea.addChild(_oCheckBox2)
			
			//checkBox 3------------------------------------------------o
			trace(this+"defaultVibrationState :"+defaultVibrationState)
			
			_oCheckBox3 = new CustomCheckBox(3, togglePushNotifications, "stateOn" );
			_oCheckBox3.x = 378;
			_oCheckBox3.y = 275;
			_spContentArea.addChild(_oCheckBox3)
			
			
			this.addChild(_spContentArea);
			mc = null;
			

		}
		
		private function togglePushNotifications():void 
		{
			if (DeviceSettings.isPushNotificationMuted)
			{
				DeviceSettings.isPushNotificationMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_PUSH_MUTED, false)
				
				if(PushController.getInstance() != null)
				PushController.getInstance().resumeNotifications();
			}
			//disable push
			else
			{
				DeviceSettings.isPushNotificationMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_PUSH_MUTED, true)
				
				if(PushController.getInstance() != null)
				PushController.getInstance().muteNotifications();
			}
		}
		

		//================================================o
		//------ toggle vibration
		//================================================o		
		public function toggleVibration():void
		{
			//if vibration disabled, enable
			if (DeviceSettings.isVibrationMuted)
			{
				DeviceSettings.isVibrationMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_VIBRATION_MUTED, false)
			}
			//disable vibration
			else
			{
				DeviceSettings.isVibrationMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_VIBRATION_MUTED, true)
			}
		
		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}