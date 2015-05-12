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
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMDialogEvent;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.data.LPLocalData;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import flash.geom.Rectangle;
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
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.ProfileUpdateFormData;
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
	public class ProfileUpdatePanel2 extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "ProfileUpdatePanel2";

		private var _core:Core;
		private var _simTop:Image;
		private var _simButton:Image;
		private var _simContent:Image;
		private var _spContentArea:Sprite;
		
		private var _spFirstName:FormField;
		private var _spLastName:FormField;
		private var _gap:int = 20;
		
		private var _spEmail:FormField;
		private var _spConfirmEmail:FormField;
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
		private var _playerVO:PlayerVO;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function ProfileUpdatePanel2() 
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
			

			_spPostCode = new FormField(9, "Postcode", SoftKeyboardType.NUMBER, FormField.TYPE_POSTCODE);
			_spPostCode.label = PlayerData.postcode;
			_spPostCode.isRequired = false;
			_spPostCode.dataClass = ProfileUpdateFormData;
			_spPostCode.dataProperty = "postCode";
			_spPostCode.x = 25;
			_spPostCode.y = top.y + h +_gap;
			this.addChild(_spPostCode);
			

			_spPhone = new FormField(10, "Phone", SoftKeyboardType.NUMBER, FormField.TYPE_PHONE);
			
			if (PlayerData.phone != null)
			_spPhone.label = PlayerData.phone;
			
			_spPhone.isRequired = false;
			_spPhone.dataClass = ProfileUpdateFormData;
			_spPhone.dataProperty = "phone";
			_spPhone.x = 25;
			_spPhone.y = (_spPostCode.y + _spPostCode.height + _gap);
			this.addChild(_spPhone);
			
			
			//Check Box Opt in
			if (PlayerData.marketing_opt_in == true)
			{
			_cbOptIn = new CustomCheckBox(1, null, CustomCheckBox.STATE_ON);
			_cbOptIn.visible = false;
			_cbOptIn.touchable = false;
			}
			else
			{
			_cbOptIn = new CustomCheckBox(1, null, CustomCheckBox.STATE_OFF);
			}
			
			_cbOptIn.isRequired = false;
			_cbOptIn.dataClass = ProfileUpdateFormData;
			_cbOptIn.dataProperty = "optIn";
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
			if (PlayerData.marketing_opt_in == true)
			_smcTextOptIn.visible = false;
			
			quContentBacking.height = this.height + 50
			
			_stxError = new TextField(480, 100, "*Mandatory", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.RED);
			_stxError.hAlign = HAlign.LEFT;
			_stxError.vAlign = VAlign.TOP;
			_stxError.x = 40;
			_stxError.y = _smcTextOptIn.y + _smcTextOptIn.height + 5;
			_stxError.autoSize = TextFieldAutoSize.VERTICAL;
			this.addChild(_stxError)
			

			//--------o
			//button Footer
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "Save";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simButton.x = 0;
			_simButton.y = quContentBacking.y + quContentBacking.height;
			
			this.addChild(_simButton);
			mc = null;
			
			_simButton.addEventListener(TouchEvent.TOUCH, onTouch)
			
		}
		
		private function updateDetails():void
		{
			_playerVO = new PlayerVO();
			
			_playerVO.device_type = DeviceType.deviceManufacturer;
			_playerVO.firstName = ProfileUpdateFormData.firstName;
			_playerVO.lastName = ProfileUpdateFormData.lastName;
			_playerVO.email = ProfileUpdateFormData.email;
			_playerVO.password = ProfileUpdateFormData.password;
			
			_playerVO.marketing_opt_in = _cbOptIn.value;
			
			_playerVO.agree_tc = true;
			
			_playerVO.phone = PlayerData.phone;
			
			if (_spPhone.value != _spPhone.defaulLabel)
			_playerVO.phone = _spPhone.value;
			
			
			_playerVO.postcode = PlayerData.postcode;
			if (_spPostCode.value != _spPostCode.defaulLabel)
			_playerVO.postcode = _spPostCode.value;
		
			trace(this+"updateDetails() ===================================")
			trace("_playerVO.firstName :"+_playerVO.firstName)
			trace("_playerVO.lastName:"+_playerVO.lastName)
			trace("_playerVO.email:"+_playerVO.email)
			trace("_playerVO.password:"+_playerVO.password)
			trace("_playerVO.postcode:"+_playerVO.postcode)
			trace("_playerVO.phone:"+_playerVO.phone)
			trace("_playerVO.marketing_opt_in:"+_playerVO.marketing_opt_in)
			trace("_playerVO.agree_tc:"+_playerVO.agree_tc)
			trace("=======================================================")
			
			Services.updateProfile.execute(_playerVO, true, true, onProfileUpdated, null)
		}
		
		private function onProfileUpdated():void 
		{
			EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);
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
						
						case _quPrivacyHit:
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.privacyPolicy);
						tBrowser1.invoke();
						break;
												
						case _quTermsHit:
						var tBrowser2:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						tBrowser2.invoke();
						break;
																		
						case _simButton:
						checkFormFields();
						break;
						
					}

                }
 
            }
		}
		
		private function checkFormFields():void 
		{
			trace(this + "checkFormFields()");


				_spPostCode.callBack_confirm(_spPostCode.value);
				_spPhone.callBack_confirm(_spPhone.value);
				_cbOptIn.check();
				//_cbPrivacy.check();
				
			
				if (
					_spPostCode.isValid &&
					_spPhone.isValid &&
					_cbOptIn.isValid //&&
					//_cbPrivacy.isValid
					)
					{
						trace(this + "fields have all validated.. proceeding to update");
						updateDetails()
					}
					else
					{
						_stxError.text = HeaderLabels.FORM_ERROR_MESSAGE_1;
						//_stxError.text = "We don’t add stars to each field for decoration. Fill in the blanks, foolio.";
					}
			
			;
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