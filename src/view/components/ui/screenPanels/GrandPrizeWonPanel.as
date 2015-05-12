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
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
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
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	//================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//================================o
	
	public class GrandPrizeWonPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "GrandPrizeWonPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simButton:Image;
		private var _simContent:Image;
		private var _tt:TrueTouch;
		private var _quTermsHit:Quad;
		private var invoker:StageWebView;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function GrandPrizeWonPanel() 
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
			
			//-------o
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("grandPrize")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentGrandPrize") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentGrandPrize", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentGrandPrize").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//-------o
			_quTermsHit = new Quad(228, 41, 0x00ff00);
			_quTermsHit.x = _simContent.x + 182; 
			_quTermsHit.y = _simContent.y + 163; 
			_quTermsHit.alpha = 0;
			this.addChild(_quTermsHit)
			_quTermsHit.addEventListener(TouchEvent.TOUCH, onTouch)
			
			//--------o
			//button Footer
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "PLAY";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simButton.x = 0;
			_simButton.y = _simContent.y + _simContent.height;
			
			this.addChild(_simButton);
			mc = null;
			
			_simButton.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
						case _simButton:
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_GAME);
						break;
						
						case _quTermsHit:
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						invoker = tBrowser1.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange, false, 0, true);
						
						break;	
					}
					
                }
 
            }
		}
		
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