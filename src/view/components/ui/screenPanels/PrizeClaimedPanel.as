package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import com.thirdsense.ui.starling.ScrollControl;
	import com.thirdsense.ui.starling.ScrollType;
	import flash.geom.Rectangle;
	import ManagerClasses.AssetsManager;
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
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.PlayerData;
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
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class PrizeClaimedPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "PrizeClaimedPanel";

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
		private var _simButton:Image;
		private var _vo:PrizeVO;
		private var _txTimeLabel:TextField;
		private var _countdown:CountdownTimer;
		private var _txPrizeCode:TextField;
		private var _simPrizeImage:Image;
		private var _tt:TrueTouch;
		private var _txTerms:TextField;
		private var _quTermsHit:Quad;
		private var _sc:ScrollControl;
		
		private var _isScrollMoving:Boolean = false;
		private var _spSlider:Sprite;
		private var simContent:Image;
		private var targetDate:Date;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function PrizeClaimedPanel(vo:PrizeVO) 
		{
			trace(this + "Constructed");
			_vo = vo;
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
			
			var spTop:Sprite = new Sprite();
			var currentDate:Date = new Date();
			var day:int = currentDate.getDay();

			//-----------------o
			//top colour
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_colourTop") as MovieClip;
			mc.gotoAndStop(day+1);
			//mc.gotoAndStop(3);
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_colourTop", null, day+1, day+1, null, 0)
			var simTopColour:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_colourTop").getImage();
			spTop.addChild(simTopColour);
			
			//-----------------o
			//bottomColour
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_colourBottom") as MovieClip;
			mc.gotoAndStop(day+1);
			mc.$txName.text = _vo.name;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_colourBottom", null, day+1, day+1, null, 0)
			var simBottomColour:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_colourBottom").getImage();
			simBottomColour.y = simTopColour.y + simTopColour.height;
			spTop.addChild(simBottomColour);
			
			//----------------o
			//featurePrizeImage
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_prizeIconFeature") as MovieClip;
			mc.gotoAndStop(_vo.prize_id)
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_prizeIconFeature", null, mc.currentFrame, mc.currentFrame, null, 0)
			_simPrizeImage = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_prizeIconFeature").getImage();
			_simPrizeImage.x = 290; _simPrizeImage.y = 85;
			spTop.addChild(_simPrizeImage);
			this.addChild(spTop);
			
			//---------------o
			//content area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentPrizeClaim") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentPrizeClaim", null, 1, 1, null, 0)
			simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentPrizeClaim").getImage();
			simContent.x = 0; simContent.y = 340;
			this.addChild(simContent);
		     
			
			//---------------o
			//content area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_swipeRedeemFooter") as MovieClip;
			mc.$txLabel.text = "SWIPE AT COUNTER"
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_swipeRedeemFooter", null, 1, 1, null, 0)
			_simButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_swipeRedeemFooter").getImage();
			_simButton.x = 0;
			_simButton.y = simContent.y + simContent.height;
			
			//this.addChild(_simButton);
			_spSlider = new Sprite();
			_spSlider.addChild(_simButton);
			
			//_spSlider.clipRect = new Rectangle(Data.deviceResX -  *30, _simFooter.y, Data.offsetScaleX * simContent.width, _simFooter.height);
			this.addChild(_spSlider);
			
			if (_vo.type == "1")
			{
			 _txTerms = new TextField(simContent.width, 100, "Redeemable after 10:30am at participating restaurants. Limit of 1 voucher per person per day. Not to be used in conjunction with any other offer or as part of an Extra Value Meal. Full Terms & Conditions.", AppFonts.FONT_FUTURA_NORMAL, 16, HexColours.WHITE);
			 _txTerms.touchable = false;
			 _txTerms.hAlign = HAlign.CENTER;
			 _txTerms.vAlign = VAlign.TOP;
			 _txTerms.x = 0;
			 _txTerms.y = _simButton.y + _simButton.height + 10;
			 this.addChild(_txTerms);
			
			 _quTermsHit = new Quad(_txTerms.width, _txTerms.height, 0x00ff00);
			 _quTermsHit.x = _txTerms.x; 
			 _quTermsHit.y = _txTerms.y; 
			 _quTermsHit.alpha = 0;
			 this.addChild(_quTermsHit)
			 _quTermsHit.addEventListener(TouchEvent.TOUCH, onTouch)
			 
			}
			 
			mc = null; 
			
			 _txPrizeCode = new TextField(550, 100, _vo.unique_code, AppFonts.FONT_FUTURA_CONDENSED, 65, HexColours["DAY_"+day]);
			
			 _txPrizeCode.touchable = false;
			 _txPrizeCode.hAlign = HAlign.CENTER;
			 _txPrizeCode.x = 15;
			 _txPrizeCode.y = 570;
			 addChild(_txPrizeCode);
			 
			 //if not expired add countdown timer and textbox
			 if (!_vo.is_expired)
			 {
				_txTimeLabel = new TextField(550, 100, "", AppFonts.FONT_FUTURA_CONDENSED, 75, HexColours.GREY);
				_txTimeLabel.touchable = false;
				_txTimeLabel.hAlign = HAlign.LEFT;
				_txTimeLabel.x = 300;
				_txTimeLabel.y = 435;
				_txTimeLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				addChild(_txTimeLabel);
                
				// var targetDate:Date = new Date(_vo.TIMESTAMP_COUNTDOWN_EXPIRY.year, _vo.TIMESTAMP_COUNTDOWN_EXPIRY.month, _vo.TIMESTAMP_COUNTDOWN_EXPIRY.day, _vo.TIMESTAMP_COUNTDOWN_EXPIRY.hour, _vo.TIMESTAMP_COUNTDOWN_EXPIRY.minute, _vo.TIMESTAMP_COUNTDOWN_EXPIRY.second);
				targetDate = DateUtil.parseDateTimeString(_vo.expiry)
				_adjustExpiryForTimezone();
				_countdown = new CountdownTimer(targetDate);
				_countdown.addEventListener(CountdownEvent.COUNTDOWN_UPDATE, onCountdownUpdate, false, 0, true);
				_countdown.addEventListener(CountdownEvent.COUNTDOWN_COMPLETE, onCountdownComplete, false, 0, true); 
			}
			 
			// var swipe:SwipeGesture = new SwipeGesture(_simButton);
			// swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe); 
			 
			TweenMax.to(_simPrizeImage, 1.5, { y:"-20", yoyo:true, repeat: -1, ease:Linear.easeNone } )

			_spSlider.clipRect = new Rectangle(0, _simButton.y, simContent.width, _simButton.height);
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
				 _simButton.addEventListener(TouchEvent.TOUCH, onTouch)
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
			
				TweenLite.to(_simButton, .2, { x: 0, onComplete:function():void {
					initScroll();
				}});
			}
		}
		
		private function initScroll():void 
		{
			var rectWidth:int = 580;
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
			
			//_sc.init(_simFooter, ScrollType.HORIZONTAL, new Rectangle(0, 0, 580,1200))
			_sc.offsetX = (AppData.deviceResX - this.width) / 2;
			trace("deviceResX :" + AppData.deviceResX);
			trace("this.width :" + this.width);
			trace("_sc.offsetX :" + _sc.offsetX);
			_sc.init(_simButton, ScrollType.HORIZONTAL, new Rectangle(_sc.offsetX, 0, rectWidth, AppData.deviceScaleX*1200))
			if(!this.hasEventListener(Event.ENTER_FRAME))
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		
		private function onUpdate(e:Event):void 
		{
			if (_isScrollMoving)
			{
				if (_sc.vx == 0)
					_isScrollMoving = false;
				if(_simButton.x < 250)
					resetScrollPos();
				else if (_simButton.x > 579)
				{
					if(this.hasEventListener(Event.ENTER_FRAME))
					this.removeEventListener(Event.ENTER_FRAME, onUpdate);	
				
					_sc.disable();
					_core.controlBus.appUIController.showNotification("ARE YOU SURE", "Has your claim been verified by a McDonald's staff member and have you received your prize?", "YES", claimPrize, "NO", function():void {
					
						TweenLite.to(_simButton, .2, { x: 0, onComplete:function():void {
							initScroll();
						}});
						
					}, 2);
					
				}
			}
			
		}
		
		private function onScrollMove():void 
		{
			_isScrollMoving = true;
		}
		
		//===============================================o
		//-- Swipe Event Handler
		//===============================================o
		private function onSwipe(e:GestureEvent):void 
		{
			var swipeGesture:SwipeGesture = e.target as SwipeGesture;
			
			//----- RIGHT SWIPE
			if (swipeGesture.offsetX > 6) 
			{
				claimPrize();
			}
			//----- LEFT SWIPE
			else if (swipeGesture.offsetX < -6)
			{
				
			}
		}
		
		private function claimPrize():void 
		{
			trace(this + "claimPrize()");
			if(PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.PRIZES_SCREEN, AppSettings.PRIZE_CLAIM_SWIPE, 1);
			
			Services.claimPrize.execute(_vo, true, true, prizeClaimComplete)	
		}
		
		//==================================================o
		//-- on count down complete:
		//-- if timer runs down while on the list screen
		//==================================================o
		private function onCountdownComplete(e:CountdownEvent):void 
		{
			_vo.is_expired = true;
			_core.controlBus.appUIController.showNotification(NotificationLabel.PRIZE_EXPIRED_HEADER, NotificationLabel.PRIZE_EXPIRED_TEXT, "OKIE DOKIE", onConfirm_popup, null, null, 1)
			
		}
		private function onConfirm_popup():void 
		{
			_core.controlBus.appUIController.removeNotification();
			EventBus.getInstance().sigSubScreenChangeRequested.dispatch(PrizesWonScreen.STATE_LIST, SuperScreen.TRANSITION_TYPE_LEFT, null)	
		}
		
		//=================================================o
		//-- count down timer tick
		//=================================================o
		private function onCountdownUpdate(e:CountdownEvent):void 
		{

			var hrs:String = _countdown.hours;
			if (hrs == "00")
			hrs = hrs.charAt(1);
			else  if (int(hrs) < 10)
			hrs = hrs.charAt(1);
			  
			_txTimeLabel.text = hrs + "h " + _countdown.minutes + "m";
		
		}
		
		//=======================================o
		//-- On Touch Event handler
		//=======================================o
		private function onTouch(e:TouchEvent):void 
		{
			
			if (_vo.is_expired)
			return;
			
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
						claimPrize();
						break;
						
						case _quTermsHit:
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						tBrowser1.invoke();
						break;
					
					}
					

                }
 
            }
			
		}
		
		//=======================================o
		//-- on prize complete 
		//=======================================o
		private function prizeClaimComplete():void 
		{
			trace(this + "prizeClaimComplete():_vo.is_claimed:" + _vo.is_claimed);
			if (PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackScreen(AppSettings.PRIZE_CLAIMED)

			SoundAS.playFx(Sounds.SFX_CLAIM, 1);	
			PlayerData.prizesClaimed ++;
			_core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_PRIZE_CLAIMED, null,PlayerData.prizesClaimed)
			EventBus.getInstance().sigSubScreenChangeRequested.dispatch(PrizesWonScreen.STATE_POST_CLAIMED, SuperScreen.TRANSITION_TYPE_LEFT, null)
		
		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			_sc.kill();
			this.removeEventListeners();
			_tt.trash();
			_tt = null;
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			
			_countdown.trash();
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