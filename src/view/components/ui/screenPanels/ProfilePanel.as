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
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import ManagerClasses.supers.SuperController;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import staticData.valueObjects.PrizeVO;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ProfileScreen;
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
	
	public class ProfilePanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "ProfilePanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simContent:Image;
		private var _tt:TrueTouch;
		private var _simUpdateBtn:Image;
		private var _simLogOutBtn:Image;
		private var _quHitArea:Quad;
		private var invoker:StageWebView;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function ProfilePanel() 
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
			
			//-------o
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("carl")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)
			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentProfileHome") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentProfileHome", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentProfileHome").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//update profile btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "UPDATE MY PROFILE";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simUpdateBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simUpdateBtn.name = "_simUpdateBtn";
			_simUpdateBtn.x = 0;
			_simUpdateBtn.y = _simContent.y + _simContent.height;
			this.addChild(_simUpdateBtn);
						
			//--------o
			//Logout btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleLightBlueBtn") as MovieClip;
			mc.$txLabel.text = "LOG OUT";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn", null, 1, 1, null, 0)
			_simLogOutBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn").getImage();
			_simLogOutBtn.name = "_simLogOutBtn";
			_simLogOutBtn.x = 0;
			_simLogOutBtn.y = _simUpdateBtn.y + _simUpdateBtn.height;
			this.addChild(_simLogOutBtn);
			
			mc = null;
			
			_quHitArea = new Quad(220, 50, 0xff00ff);
			_quHitArea.x = 180;
			_quHitArea.name = "_quHitArea";
			_quHitArea.y = _simContent.y + 135;
			_quHitArea.alpha = 0;
			this.addChild(_quHitArea);	
			
			_quHitArea.addEventListener(TouchEvent.TOUCH, onTouch);
			_simUpdateBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			_simLogOutBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
					
					switch(DisplayObject(e.target).name)
					{
						case "_simUpdateBtn":
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(ProfileScreen.STATE_UPDATE, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						break;
												
						case "_simLogOutBtn":
						
						if(PublicSettings.ENABLE_ANALYTICS)
						Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.PROFILE_SCREEN, AppSettings.LOG_OUT_BUTTON, 1);	
						
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_LOG_OUT);
						break;
						
						case "_quHitArea":
							trace("hit");
							var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.privacyPolicy);
							invoker = tBrowser1.invoke();
							invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange, false, 0, true);
						break;	
						
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
			_tt.trash();
			_tt = null;
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}