package view.components.ui.screenPanels 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
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
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.AppSettings;
	import staticData.dataObjects.PlayerData;
	import staticData.DeviceType;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SharedObjectKeys;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import view.components.screens.SuperScreen;
	import view.components.ui.CustomCheckBox;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	
	public class TermsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "TermsPanel";

		private var _core:Core;
		
		private var _simTop:Image;

		private var _tt:TrueTouch;
		private var _quHitArea1:Quad;
		private var _quHitArea2:Quad;
		private var invoker:StageWebView;
		private var _simBtn1:Image;
		private var _simBtn2:Image;
		private var cb:CustomCheckBox;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function TermsPanel() 
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
			
			var mc:MovieClip;
			//-----------------o
			
			
			var ref:String = "TA_contentTerms";
			if (CompetitionServiceStatus.currentState ==  CompetitionServiceStatus.STATE_NOT_ACTIVE)
			ref = "TA_contentTermsCompOff";
			
			//content
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, ref) as MovieClip;

			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, ref, null, 1, 1, null, 0)
			var simContent:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, ref).getImage();
			simContent.y = 0
			this.addChild(simContent);
			
			//----------------o
			
			//Button
			//----------------o
			//Agree To Terms btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "CONTINUE";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simBtn1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simBtn1.name = "_simBtn1";
			_simBtn1.x = 0;
			_simBtn1.y = simContent.y + simContent.height;
			this.addChild(_simBtn1);
						
			//-----------------o
			//No thanks btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleWhiteBtn") as MovieClip;
			mc.$txLabel.text = "NO THANKS";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleWhiteBtn", null, 1, 1, null, 0)
			_simBtn2 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleWhiteBtn").getImage();
			_simBtn2.name = "_simBtn2";
			_simBtn2.x = 0;
			_simBtn2.y = _simBtn1.y + _simBtn1.height;
			this.addChild(_simBtn2);
			
			mc = null;
			

			
			cb = new CustomCheckBox(1, function():void {
				SharedObjects.setProperty(SharedObjectKeys.TERMS_AGREED_A, true);
			});
			cb.isRequired = true;
			cb.x = 51;
			cb.y = simContent.height - 70;
			addChild(cb);
			
			
			_quHitArea1 = new Quad(110, 50, 0xff00ff);
			_quHitArea1.x = 225;
			_quHitArea1.y =  215;
			_quHitArea1.alpha = 0;
			this.addChild(_quHitArea1);	
						
			_quHitArea2 = new Quad(115, 50, 0xff00ff);
			_quHitArea2.x = 442;
			_quHitArea2.y =  215;
			_quHitArea2.alpha = 0;
			this.addChild(_quHitArea2);	
			
			
			mc = null; 
			 
			 _simBtn1.addEventListener(TouchEvent.TOUCH, onTouch);
			 _simBtn2.addEventListener(TouchEvent.TOUCH, onTouch);
			 _quHitArea1.addEventListener(TouchEvent.TOUCH, onTouch);
			 _quHitArea2.addEventListener(TouchEvent.TOUCH, onTouch);
			
		}
		
		private function redrawContent():void
		{
			
			var mc:MovieClip;
			//-----------------o
			var ref:String = "TA_contentTerms";
			if (CompetitionServiceStatus.currentState ==  CompetitionServiceStatus.STATE_NOT_ACTIVE)
			ref = "TA_contentTermsCompOff";

			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, ref)
			//content
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, ref) as MovieClip;
			mc.$mcTerms.gotoAndStop(2);
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, ref, null, 1, 1, null, 0)
			var simContent:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, ref).getImage();
			simContent.y = 0
			this.addChild(simContent);	
			
			this.setChildIndex(cb, this.numChildren - 1)
			this.setChildIndex(_quHitArea2, this.numChildren - 1)
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
						case _simBtn1:
							cb.check();
							
							if (cb.isValid)
							{
									
								if(PublicSettings.ENABLE_ANALYTICS)
								Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.TERMS_SCREEN, AppSettings.AGREE_NEW_TERMS, 1);	
							
								PlayerData.hasAgreedAppTerms_1 = true;
								Services.savePlayerData.execute(false, false)
								EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME)
							}
							else
							{
								redrawContent();
							}
							break;	
												
						//----						
						//--------------------------------o
						case _simBtn2:
							
							if(PublicSettings.ENABLE_ANALYTICS)
							Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.TERMS_SCREEN, AppSettings.DISAGREE_TO_TERMS, 1);	
							
							if (UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_IN)
							{
								Services.logout.execute(function():void 
									{
									_core.controlBus.appUIController.showNotification("LOGGED OUT", "You have been logged out", "OK", function():void {
									EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME)	
									}, null, null, 1 )	
								})
							}
							else
							{
								EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME)	
							}
							
								
						break;	
												
						//--------------------------------o
						
						case _quHitArea1:
							if(PublicSettings.ENABLE_ANALYTICS)
							Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.TERMS_SCREEN, AppSettings.PRIVACY_INFO_LINK, 1);	
							
							var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.privacyPolicy);
							invoker = tBrowser1.invoke();
							invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange, false, 0, true);
						break;													
						//--------------------------------o
						
						case _quHitArea2:
							if(PublicSettings.ENABLE_ANALYTICS)
							Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.TERMS_SCREEN, AppSettings.TERMS_AND_CONDITIONS_LINK, 1);	
							
							var tBrowser2:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
							invoker = tBrowser2.invoke();
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