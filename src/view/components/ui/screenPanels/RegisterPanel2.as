package view.components.ui.screenPanels 
{

	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.StringFunctions;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMDialogEvent;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.data.LPLocalData;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormatAlign;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.AppServices;
	import net.RemoteServicesErrorCode;
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
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.AppSettings;
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.RegistrationFormData;
	import staticData.DeviceType;
	import staticData.HeaderLabels;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.LoadingLabel;
	import staticData.NativeModalInputGroups;
	import staticData.NavGroups;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.Urls;
	import staticData.valueObjects.PlayerVO;
	import view.components.screens.LoadingScreen;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.CustomCheckBox;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class RegisterPanel2 extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "RegisterPanel2";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _spContentArea:Sprite;
		
		private var _spFirstName:FormField;
		private var _spLastName:FormField;
		private var _gap:int = 20;
		
		private var _spEmail:FormField;
		private var _spConfirmEmail:FormField;
		private var _spPassword:FormField;
		private var _spConfirmPassword:FormField;
		private var _spState:FormField;
		private var _spPhone:FormField;
		private var _spPostCode:FormField;
		
		private var _cbOptIn:CustomCheckBox;
		private var _cbPrivacy:CustomCheckBox;
		private var _smcTextOptIn:starling.display.MovieClip;
		private var _smcTextPrivacy:starling.display.MovieClip;
		private var _tt:TrueTouch;
		private var _stxError:TextField;
		private var _quTermsHit:Quad;
		private var _quPrivacyHit:Quad;
		private var invoker:StageWebView;



		//=======================================o
		//-- Constructor
		//=======================================o
		public function RegisterPanel2() 
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
			
			var fbSession:FacebookSession = FacebookMobile.getSession(); 
			
			var h:int = 0;
			//top section
			var mc:MovieClip;
			
			var top:*;
			var quContentBacking:Quad = quContentBacking = new Quad(580, 10, HexColours.OFF_WHITE);
			this.addChild(quContentBacking);
			
			if (AppData.deviceResY >= 20000)
			{
				mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
				mc.$mcIcon.gotoAndStop("crate")
				h = mc.$mcHeader.height;
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

				_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
				_simTop.x = 0;
				this.addChild(_simTop);
				top = _simTop;
			}
			else
			{
				top = quContentBacking;
			}
			

			if (_simTop != null)
			{
			quContentBacking.y = _simTop.y + h;
			quContentBacking.x = _simTop.x;
			}
			else
			{
			quContentBacking.y = 0;
			quContentBacking.x = 0;
			}
			
			_spPostCode = new FormField(9, "*Postcode", SoftKeyboardType.NUMBER, FormField.TYPE_POSTCODE);
			_spPostCode.label = PlayerData.postcode;
			_spPostCode.dataClass = RegistrationFormData;
			_spPostCode.dataProperty = "postCode";
			_spPostCode.isRequired = true;
			_spPostCode.x = 25;
			_spPostCode.y = top.y + h +_gap;
			this.addChild(_spPostCode);
			
			_spPhone = new FormField(10, "Phone", SoftKeyboardType.NUMBER, FormField.TYPE_PHONE);
			_spPhone.label = PlayerData.phone;
			_spPhone.dataClass = RegistrationFormData;
			_spPhone.dataProperty = "phoneNumber";
			_spPhone.isRequired = false;
			_spPhone.x = 25;
			_spPhone.y = (_spPostCode.y + _spPostCode.height + _gap);
			this.addChild(_spPhone);
			
			
			//Check Box Opt in
			_cbOptIn = new CustomCheckBox(1, null);
			_cbOptIn.isRequired = false;
			_cbOptIn.x = 25;
			_cbOptIn.y = Math.ceil(_spPhone.y + 86 + (_gap * 2));
			this.addChild(_cbOptIn);
			
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_textTermsConfirm") as MovieClip;
			mc.gotoAndStop("black")
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_textTermsConfirm", null, 1, 2, null, 0)
			
			_smcTextOptIn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_textTermsConfirm").getMovieClip();
			_smcTextOptIn.currentFrame = 0;
			_smcTextOptIn.x = 100;
			_smcTextOptIn.y = _cbOptIn.y+5;
			this.addChild(_smcTextOptIn);
			
			//------------------------------o
			
			_cbPrivacy = new CustomCheckBox(2, null);
			_cbPrivacy.isRequired = true;
			_cbPrivacy.x = 25;
			_cbPrivacy.y = _spPhone.y + 250;
			this.addChild(_cbPrivacy);
			
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_textPrivacyConfirm") as MovieClip;
			mc.gotoAndStop("black")
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_textPrivacyConfirm", null, 1, 2, null, 0)
			
			_smcTextPrivacy = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_textPrivacyConfirm").getMovieClip();
			_smcTextPrivacy.currentFrame = 0;
			_smcTextPrivacy.x = 100;
			_smcTextPrivacy.y = _cbPrivacy.y + 5;
			this.addChild(_smcTextPrivacy);
			
			_quTermsHit = new Quad(200, 30, 0x660066);
			_quTermsHit.alpha = 0;
			_quTermsHit.x = _smcTextPrivacy.x + 264
			_quTermsHit.y = _smcTextPrivacy.y
			this.addChild(_quTermsHit);
			_quTermsHit.addEventListener(TouchEvent.TOUCH, onTouch)
			
			_quPrivacyHit = new Quad(261, 30, 0x660066);
			_quPrivacyHit.alpha = 0;
			_quPrivacyHit.x = _smcTextPrivacy.x + 190
			_quPrivacyHit.y = _smcTextPrivacy.y + 35
			this.addChild(_quPrivacyHit);	
			_quPrivacyHit.addEventListener(TouchEvent.TOUCH, onTouch)
			
			quContentBacking.height = 540;// this.height + 50
			
			trace(this + "quContentBacking.height:" + quContentBacking.height);
			_stxError = new TextField(480, 100, "*Mandatory", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.RED);
			_stxError.hAlign = HAlign.LEFT;
			_stxError.vAlign = VAlign.TOP;
			_stxError.x = 40;
			_stxError.y = _quPrivacyHit.y + _quPrivacyHit.height + 5;
			_stxError.autoSize = TextFieldAutoSize.VERTICAL;
			this.addChild(_stxError)
			
			//quContentBacking.height = this.height + 50
			//spForm.y = stxText1.y + stxText1.height + 20;
			//_spContentArea.addChild(spForm);

			


/*			var customStageText:CustomStageText = new CustomStageText(20, 5, 100, 60, _ffFirstName)
			customStageText.text = "hello";
			customStageText.init();*/
			
			

			//--------o
			//button Footer
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "Submit";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simFooter = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simFooter.x = 0;
			_simFooter.y = quContentBacking.y + quContentBacking.height;
			
			this.addChild(_simFooter);
			mc = null;
			
			_simFooter.addEventListener(TouchEvent.TOUCH, onTouch)
			
		}
		
		private function onTouch_input(e:TouchEvent):void 
		{
			
		}

		//=======================================o
		//--- SERVICES
		//=======================================o
		
		private function register():void
		{
			var playerVO:PlayerVO = new PlayerVO();
			
			playerVO.device_type = DeviceType.deviceManufacturer;
			playerVO.firstName = RegistrationFormData.firstName;
			playerVO.lastName = RegistrationFormData.lastName;
			playerVO.email = RegistrationFormData.email;
			playerVO.password = RegistrationFormData.password;
			playerVO.marketing_opt_in =  _cbOptIn.value;
			playerVO.agree_tc = _cbPrivacy.value;
			playerVO.phone = _spPhone.value;
			playerVO.postcode = _spPostCode.value;
			
			if(PlayerData.facebookID != null)
			playerVO.facebook_id = PlayerData.facebookID;
			else
			playerVO.facebook_id = "";
			
			PlayerData.device_type = playerVO.device_type;
			PlayerData.firstName = playerVO.firstName;
			PlayerData.lastName = playerVO.lastName;
			PlayerData.email = playerVO.email;
			PlayerData.password = playerVO.password;
			PlayerData.marketing_opt_in = playerVO.marketing_opt_in;
			PlayerData.agree_tc = playerVO.agree_tc;
			PlayerData.phone = playerVO.phone;
			PlayerData.postcode = playerVO.postcode;
			
			trace(this+"updateDetails() ===================================")
			trace("_playerVO.firstName :"+playerVO.firstName)
			trace("_playerVO.lastName:"+playerVO.lastName)
			trace("_playerVO.email:"+playerVO.email)
			trace("_playerVO.password:"+playerVO.password)
			trace("_playerVO.postcode:"+playerVO.postcode)
			trace("_playerVO.phone:"+playerVO.phone)
			trace("_playerVO.marketing_opt_in:"+playerVO.marketing_opt_in)
			trace("_playerVO.agree_tc:"+playerVO.agree_tc)
			trace("=======================================================")
			
			Services.register.execute(playerVO, true, true, function():void 
			{
				
					if(PublicSettings.ENABLE_ANALYTICS)
					Analytics.trackScreen(AppSettings.REGISTER_CONFIRMATION_SCREEN);
					
					//Login After Register
					Services.login.execute(PlayerData.email, PlayerData.password, true, true,  function():void 
					{
						
						_core.oDebugPanel.setTrace("onLogin success");
						_core.controlBus.appUIController.removeStageText();

						if (StateMachine.pendingRegisterCallback != null)
						{
							//EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.pendingRegisterCallback)
							StateMachine.pendingRegisterCallback();
							StateMachine.pendingRegisterCallback = null;
						}
						else if (StateMachine.pendingPrizePostRegister != null)
						{
							StateMachine.pendingPrizePostRegister();
							StateMachine.pendingPrizePostRegister = null;
						}
						else
						{
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME)
						}
						//save empty object to server
						Services.savePlayerData.execute(false);
						
					},
					//failed
					function():void
					{
						
					}
					);
					
			})
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
					//EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_GAME)
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					if (!_tt.checkTouch(touch))
					return;
					
					switch(e.target)
					{
						
						case _quPrivacyHit:
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.privacyPolicy);
						invoker = tBrowser1.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange1, false, 0, true);
						break;
												
						case _quTermsHit:
						var tBrowser2:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						invoker = tBrowser2.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange2, false, 0, true);
						break;
																		
						case _simFooter:
						checkFormFields();
						break;
					}
					
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		
		private function onLocationChange1(e:LocationChangeEvent):void 
		{
			StateMachine.allowDeviceActivate = false;
			
			trace(this+"onLocationChange1:"+e.location)
			invoker.stop();
			
			var targ:String = String(e.location);
			 if(targ == Urls.mcDonaldsWebsite)
			 Util.openURL(targ)

		}
				
		private function onLocationChange2(e:LocationChangeEvent):void 
		{
			trace(this+"onLocationChange2:"+e.location)
			 // Something here to close the webview
			 
			 StateMachine.allowDeviceActivate = false;
			 
			 invoker.stop();
			 
			 var targ:String = String(e.location);
			 if(targ == Urls.mcDonaldsWebsite)
			 Util.openURL(targ)

		}
		
		//=======================================o
		//-- Validate fields
		//=======================================o
		private function checkFormFields():void 
		{
			trace(this + "checkFormFields()");

				_spPostCode.callBack_confirm(_spPostCode.value);
				_spPhone.callBack_confirm(_spPhone.value);
				_cbOptIn.check();
				_cbPrivacy.check();
				
				if (
					_spPostCode.isValid &&
					_spPhone.isValid &&
					_cbOptIn.isValid &&
					_cbPrivacy.isValid
					)
					{
						trace(this + "fields have all validated.. proceeding to register");
						register()
					}
					else
					{
						_stxError.text = HeaderLabels.FORM_ERROR_MESSAGE_1;
					}
			
			
		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			try
			{
				if (invoker != null)
				{
					if (invoker.hasEventListener(LocationChangeEvent.LOCATION_CHANGING))
					{
						invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange1)
						invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange2)
					}
				}
			}catch (e:Error)
			{
				trace(this +"Error :"+ e.message);
			}
			
			_tt.trash();
			_tt = null;
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}