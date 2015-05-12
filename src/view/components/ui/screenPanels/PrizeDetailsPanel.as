
package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.StarlingUtil;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import com.thirdsense.ui.starling.ScrollControl;
	import com.thirdsense.ui.starling.ScrollType;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.Services;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
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
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.Sounds;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import staticData.valueObjects.PrizeVO;
	import treefortress.sound.SoundAS;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class PrizeDetailsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "PrizeDetailsPanel";

		private var _core:Core;
		private var _titleText:String = "";
		private var _subText:String = "";
		private var _btn1Text:String = "";
		private var _btn2Text:String = "";
		private var _buttonCount:int = 2;
		private var _simBtn1:Image;
		private var _simBtn2:Image;
		
		private var _fnBtn1Callback:Function;
		private var _fnBtn2Callback:Function;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _vo:PrizeVO;
		private var _txTimeLabel:TextField;
		private var _countdown:CountdownTimer;
		private var targetDate:Date;
		private var _isCountDownRequired:Boolean = false;
		private var _simPrizeImage:Image;
		private var _txTerms:TextField;
		private var _quTermsHit:Quad;
		private var _tt:TrueTouch;
		private var _isMystery:Boolean;
		private var invoker:StageWebView;
		private var _sc:ScrollControl;
		private var _spSlider:Sprite;
		private var _isScrollMoving:Boolean = false;
		private var simContent:Image;
		//=======================================o
		//-- Constructor
		//=======================================o
		public function PrizeDetailsPanel(vo:PrizeVO) 
		{
			_vo = vo;
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

			
			if (_vo.is_mystery && !_vo.is_redeemed && !_vo.is_claimed && !_vo.is_expired)
			{
				_isMystery = true;
			}
			
			_tt = new TrueTouch();
			var spTop:Sprite = new Sprite();
			var currentDate:Date = new Date();
			var day:int = currentDate.getDay();

			//top colour
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_colourTop") as MovieClip;
			mc.gotoAndStop(day+1);
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_colourTop", null, day+1, day+1, null, 0)
			var simTopColour:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_colourTop").getImage();
			spTop.addChild(simTopColour);
			
			//-----------------o
			//bottomColour
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_colourBottom") as MovieClip;
			if (_isMystery)
			{
				mc.$txName.text = "MYSTERY PRIZE";
			}
			else
			{
				mc.$txName.text = _vo.name;	
			}
			
			mc.gotoAndStop(day+1);
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_colourBottom", null, day+1, day+1, null, 0)
			var simBottomColour:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_colourBottom").getImage();
			simBottomColour.y = simTopColour.y + simTopColour.height;
			spTop.addChild(simBottomColour);
			
			//----------------o
			//featurePrizeImage
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_prizeIconFeature") as MovieClip;
			
			if (_isMystery)
			{
				mc.gotoAndStop(13);
			}
			else
			{
				mc.gotoAndStop(_vo.prize_id);
			}

			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_prizeIconFeature", null, mc.currentFrame, mc.currentFrame, null, 0)
			_simPrizeImage = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_prizeIconFeature").getImage();
			_simPrizeImage.x = 290; _simPrizeImage.y = 85;
			spTop.addChild(_simPrizeImage);
			
			this.addChild(spTop);

			//-------o
			//featurePrizeImage
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentPrize1") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentPrize1", null, 1, 1, null, 0)
			simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentPrize1").getImage();
			simContent.x = 0; simContent.y = 340;
			this.addChild(simContent);
		     
			//-------o
			//redeem Button
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_swipeRedeemFooter") as MovieClip;
			mc.$txLabel.text = "SWIPE TO REDEEM"
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_swipeRedeemFooter", null, 1, 1, null, 0)
			_simFooter = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_swipeRedeemFooter").getImage();
			_simFooter.x = 0;
			_simFooter.y = simContent.y + simContent.height;
			
			_spSlider = new Sprite();
			_spSlider.addChild(_simFooter);

			this.addChild(_spSlider);
		
			if (_vo.type == "1")
			{
				 _txTerms = new TextField(simContent.width, 100, "Redeemable after 10:30am at participating restaurants. Limit of 1 voucher per person per day. Not to be used in conjunction with any other offer or as part of an Extra Value Meal. Full Terms & Conditions.", AppFonts.FONT_FUTURA_NORMAL, 16, HexColours.WHITE);
				 _txTerms.touchable = false;
				 _txTerms.hAlign = HAlign.CENTER;
				 _txTerms.vAlign = VAlign.TOP;
				 _txTerms.x = 0;
				 _txTerms.y = _simFooter.y + _simFooter.height + 10;
				 this.addChild(_txTerms);
				
				 _quTermsHit = new Quad(_txTerms.width, _txTerms.height, 0x00ff00);
				 _quTermsHit.x = _txTerms.x; 
				 _quTermsHit.y = _txTerms.y; 
				 _quTermsHit.alpha = 0;
				 this.addChild(_quTermsHit)
				 _quTermsHit.addEventListener(TouchEvent.TOUCH, onTouch)
			}
			mc = null; 
			
			
			if (!_vo.is_expired)
			{
				 _txTimeLabel = new TextField(550, 100, "", AppFonts.FONT_FUTURA_CONDENSED, 75, HexColours.GREY);
				 _txTimeLabel.touchable = false;
				 _txTimeLabel.hAlign = HAlign.CENTER;
				 _txTimeLabel.x = 4;
				 _txTimeLabel.y = 425;
				 addChild(_txTimeLabel);
			 
				 //if item has been redeemed, but not yet claimed
				if (_vo.is_redeemed)
				{
					targetDate = DateUtil.parseDateTimeString(_vo.expiry);
					_adjustExpiryForTimezone();
					_isCountDownRequired = true;
				}	
				//if the prize has not yet been redeemed
				else if (!_vo.is_redeemed)
				{
					targetDate = DateUtil.parseDateTimeString(_vo.expiry)
					_adjustExpiryForTimezone();
					_isCountDownRequired = true;
				}
				 
				if (_isCountDownRequired)
				{
				_countdown = new CountdownTimer(targetDate);
				_countdown.addEventListener(CountdownEvent.COUNTDOWN_UPDATE, onCountdownUpdate, false, 0, true);
				_countdown.addEventListener(CountdownEvent.COUNTDOWN_COMPLETE, onCountdownComplete, false, 0, true); 
				}
				
			}
			
			TweenMax.to(_simPrizeImage, 1.5, { y:"-20", yoyo:true, repeat: -1, ease:Linear.easeNone } )
			_spSlider.clipRect = new Rectangle(0, _simFooter.y, simContent.width, _simFooter.height);
			
			_spSlider.x = 0;
			
			_sc = new ScrollControl();	
			_sc.onRelease = onScrollRelease;
			_sc.onMove = onScrollMove;
			_sc.pixel_sensitivity = 1;
			_sc.velocityFactorX = 3;
			Delegate.callLater(50, function():void
			{
				initScroll();
			})
			
			if (PublicSettings.ALLOW_TOUCH_REDEEM)
			{
				//_simFooter.addEventListener(TouchEvent.TOUCH, onTouch)
			}
		}
		
		private function _adjustExpiryForTimezone():void {
		  // Convert timezones
		  var date:Date = new Date();
		  var offset:Number = date.getTimezoneOffset();
		  offset = 660 + offset;
		  offset *= -1;
		  targetDate.setTime(targetDate.getTime() + (offset * 60 * 1000));
		}
		
		private function onScrollRelease():void 
		{
			trace("onScrollRelease");
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
		private function resetScrollPos():void 
		{
			if (!_isScrollMoving)
			{
			_sc.kill();
			
			if(this.hasEventListener(Event.ENTER_FRAME))
			this.removeEventListener(Event.ENTER_FRAME, onUpdate);
			
				TweenLite.to(_simFooter, .2, { x: 0, onComplete:function():void {
					initScroll();
				}});
			}
		}
		
		private function initScroll():void 
		{
			var rectWidth:int = 580;
			//if smaller then 640
			if (AppData.offsetScaleX < 1)
			{
				_sc.offsetX = 0
				rectWidth = AppData.offsetScaleX * 580;
			}
			else if(AppData.offsetScaleX > 1)
			{
				_sc.offsetX = (AppData.deviceResX - this.width) / 2;
				rectWidth = AppData.deviceScaleX * 580;

			}
			else
			{
				rectWidth = 580;
			}
			
			_sc.offsetX = (AppData.deviceResX - this.width)/2;
			_sc.init(_simFooter, ScrollType.HORIZONTAL, new Rectangle(_sc.offsetX, 0, rectWidth, AppData.deviceScaleX*1200))
			if(!this.hasEventListener(Event.ENTER_FRAME))
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		
		
		private function onUpdate(e:Event):void 
		{
			
			
			if (_isScrollMoving)
			{
				if (_sc.vx == 0)
				_isScrollMoving = false;
				if(_simFooter.x < 250)
				resetScrollPos();
				else if (_simFooter.x > 579)
				{
					
				if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, onUpdate);	
				
				_sc.disable();
				//redeem();
				_core.controlBus.geolocationController.updateGeolocation(onGeoUpdated, onGeoFailed, onGeoMuted);
				}
			}
			
		}
		
		private function onScrollMove():void 
		{
			_isScrollMoving = true;
		}
		
		private function onLocationChange(e:LocationChangeEvent):void 
		{
			StateMachine.allowDeviceActivate = false;
			
			trace(this+"onLocationChange1:"+e.location)
			invoker.stop();
			
			var targ:String = String(e.location);
			if(targ == Urls.mcDonaldsWebsite)
			Util.openURL(targ)
			
			invoker.stop();

		}
		
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
						
					case _simFooter:
					if(PublicSettings.DEBUG_RELEASE)
					redeem();
					else
					_core.controlBus.geolocationController.updateGeolocation(onGeoUpdated, onGeoFailed, onGeoMuted);
					break;
					
					case _quTermsHit:
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						//tBrowser1.invoke();
						invoker = tBrowser1.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange, false, 0, true);
						
					break;
					
					}
				}
 
			}
			
		}
		
		//==================================================o
		//-- on count down complete:
		//-- if timer runs down while on the list screen
		//==================================================o
		private function onCountdownComplete(e:CountdownEvent):void 
		{
			_vo.is_expired = true;
			_core.controlBus.appUIController.showNotification(NotificationLabel.PRIZE_EXPIRED_HEADER, NotificationLabel.PRIZE_EXPIRED_TEXT, "OK", onConfirm_popup, null, null, 1)
			
		}
		private function onConfirm_popup():void 
		{
			_core.controlBus.appUIController.removeNotification();
			EventBus.getInstance().sigSubScreenChangeRequested.dispatch(PrizesWonScreen.STATE_LIST, SuperScreen.TRANSITION_TYPE_LEFT, null)	
		}
		
		
		private function onCountdownUpdate(e:CountdownEvent):void 
		{
		    var hrs:String = _countdown.hours;
			
			if (hrs == "00")
		    hrs = hrs.charAt(1);
		    else  if (int(hrs) < 10)
		    hrs = hrs.charAt(1);
			
			_txTimeLabel.text = hrs + "h " + _countdown.minutes + "m";
		}
		
		//==================================================o
		//-- no geo location detected, force redeem
		//==================================================o
		private function onGeoFailed():void 
		{
			trace(this + "onGeoFailed()");
			redeem();
		}
		
		private function onGeoMuted():void 
		{
			trace(this + "onGeoMuted()");
			redeem();
		}
		
		//==================================================o
		//-- geo location updated, check if in store proximity;
		//==================================================o
		private function onGeoUpdated():void 
		{
			trace(this + "onGeoUpdated()");
			
			_core.controlBus.geolocationController.checkIfNearStore(function():void 
			{	//cbTrue
				trace(this + "whithin store radius, redeeming");
				redeem();
			},
			function():void 
			{ 	
				//cbFalse
				_core.controlBus.appUIController.showNotification(NotificationLabel.STORE_PROXIMITY_ALERT, NotificationLabel.STORE_PROXIMITY_ALERT_SUB, "YES", redeem, "NO", function():void {
			
				TweenLite.to(_simFooter, .2, { x: 0, onComplete:function():void {
							initScroll();
				}});
					
				_core.controlBus.geolocationController.resetUserCoordinates();
				}, 2);
			})	
		}
		
		//=======================================o
		//-- Redeem current prize
		//=======================================o
		private function redeem():void
		{
			trace(this + "redeem()");			
			if (_vo.type == "1")
			{
				if(PublicSettings.ENABLE_ANALYTICS)
				Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.PRIZES_SCREEN, AppSettings.PRIZE_REDEEM_SWIPE, 1);
			
				Services.redeemPrize.execute(_vo, true, true, onRedeemComplete);
			}
			else
			{
				Services.redeemPrize.execute(_vo, true, false, onRedeemComplete);
			}
		}
		
		//=======================================o
		//-- On Complete callback from prize controller
		//=======================================o
		private function onRedeemComplete():void 
		{

			if (_vo.type == "1")
			{
				SoundAS.playFx(Sounds.SFX_CLAIM, 1);		
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(PrizesWonScreen.STATE_ITEM_CLAIMED, SuperScreen.TRANSITION_TYPE_RIGHT, _vo)	
				
				if(PublicSettings.ENABLE_ANALYTICS)
				Analytics.trackScreen(AppSettings.PRIZE_REDEEMED);
				
			}
			else
			{
				Services.claimPrize.execute(_vo, true, true, onClaimComplete);
			}
			
		}
		
		private function onClaimComplete():void 
		{
			SoundAS.playFx(Sounds.SFX_CASH_REGISTER, 1);	
			EventBus.getInstance().sigSubScreenChangeRequested.dispatch(PrizesWonScreen.STATE_LIST, SuperScreen.TRANSITION_TYPE_LEFT, null)		
		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			_sc.kill();
			
			trace(this + "trash()");
			if (invoker != null)
			{
				if (invoker.hasEventListener(LocationChangeEvent.LOCATION_CHANGING))
				invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange)
			}
			
			this.removeEventListeners();
			_tt.trash();
			_tt = null;
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			_countdown.trash();
			this.removeFromParent();
		}
		
		public function get titleText():String 
		{
			return _titleText;
		}
		
		public function set titleText(value:String):void 
		{
			_titleText = value;
		}
		
		public function get subText():String 
		{
			return _subText;
		}
		
		public function set subText(value:String):void 
		{
			_subText = value;
		}
		
		public function get buttonCount():int 
		{
			return _buttonCount;
		}
		
		public function set buttonCount(value:int):void 
		{
			_buttonCount = value;
		}
		
		public function get btn1Text():String 
		{
			return _btn1Text;
		}
		
		public function set btn1Text(value:String):void 
		{
			_btn1Text = value;
		}
		
		public function get btn2Text():String 
		{
			return _btn2Text;
		}
		
		public function set btn2Text(value:String):void 
		{
			_btn2Text = value;
		}
		
		public function get fnBtn1Callback():Function 
		{
			return _fnBtn1Callback;
		}
		
		public function set fnBtn1Callback(value:Function):void 
		{
			_fnBtn1Callback = value;
		}
		
		public function get fnBtn2Callback():Function 
		{
			return _fnBtn2Callback;
		}
		
		public function set fnBtn2Callback(value:Function):void 
		{
			_fnBtn2Callback = value;
		}
		
		
	}

}