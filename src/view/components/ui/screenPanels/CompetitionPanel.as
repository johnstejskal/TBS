package view.components.ui.screenPanels 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.mediators.userServices.status.UserServiceStatus;
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
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.AppSettings;
	import staticData.DeviceType;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	
	public class CompetitionPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "CompetitionPanel";

		private var _core:Core;
		
		private var _simTop:Image;
		private var _simButton:Image;

		private var _tt:TrueTouch;
		private var _quHitArea1:Quad;
		private var _quHitArea2:Quad;
		private var invoker:StageWebView;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function CompetitionPanel() 
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
			_tt = new TrueTouch();
			
			var h:int;
			
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("competition")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-----------------o
			
			//content
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentCompetition") as MovieClip;
			
			if (PublicSettings.PLATFORM != "IOS")
			mc.$mcDisclaimer.visible = false;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentCompetition", null, 1, 1, null, 0)
			var simContent:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentCompetition").getImage();
			simContent.y = _simTop.y + h;
			this.addChild(simContent);
			
			//----------------o
			
			//Button
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			
			
			mc.$txLabel.text = "TERMS & CONDITIONS";

			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simButton.x = 0;
			_simButton.y = simContent.y + simContent.height;
			
			
			this.addChild(_simButton);
			
			mc = null; 
			 
			 _simButton.addEventListener(TouchEvent.TOUCH, onTouch);

			
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
						//--------------------------------o
						case _simButton:
							if(PublicSettings.ENABLE_ANALYTICS)
							Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.COMPETITION_SCREEN, AppSettings.TERMS_AND_CONDITIONS_LINK, 1);	
							
							var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
							invoker = tBrowser1.invoke();
							invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange, false, 0, true);
						break;	
												
						//--------------------------------o
						
					}

                }

            }
		}
		
		//=========================================o
		//-invover status event handler - used for webview sub link clicks
		//=========================================o
		private function onLocationChange(e:LocationChangeEvent):void 
		{
			StateMachine.allowDeviceActivate = false;
			
			invoker.stop();
			
			var targ:String = String(e.location);
			if(targ == Urls.mcDonaldsWebsite)
			Util.openURL(targ)
			
			invoker.stop();

		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			if (invoker != null)
			{
				if (invoker.hasEventListener(LocationChangeEvent.LOCATION_CHANGING))
				invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange)
			}	
			_tt.trash();
			_tt = null;
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}