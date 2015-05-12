package view.components.ui.screenPanels 
{

	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
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
	import staticData.valueObjects.PlayerVO;
	import view.components.screens.LoadingScreen;
	import view.components.screens.LoginScreen;
	import view.components.screens.PrizesWonScreen;
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
	public class RegisterPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "RegisterPanel";

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

		//=======================================o
		//-- Constructor
		//=======================================o
		public function RegisterPanel() 
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
			
			var spForm:Sprite = new Sprite();
			
			//---------------------------------------o
			var requiredFName:Boolean = true;
			
			if (PlayerData.firstName != null)
			{
			requiredFName = false
			RegistrationFormData.firstName = PlayerData.firstName;
			}
			
			_spFirstName = new FormField(3, "*First Name", SoftKeyboardType.DEFAULT, FormField.TYPE_FIRST_NAME);
			_spFirstName.label = PlayerData.firstName;
			_spFirstName.globalContext = this;
			_spFirstName.dataClass = RegistrationFormData;
			_spFirstName.dataProperty = "firstName";
			
			_spFirstName.isRequired = requiredFName;
			_spFirstName.showOnActivate = true;
			_spFirstName.x = 25;
			_spFirstName.y = top.y + h +_gap;
			
			if(fbSession != null)
			_spFirstName.defaultState = FormField.STATE_ON;
			
			this.addChild(_spFirstName);
			
			//---------------------------------------o

			var requiredLName:Boolean = true;
			if (PlayerData.lastName != null)
			{
			requiredLName = false;
			RegistrationFormData.lastName = PlayerData.lastName;
			}
			
			_spLastName = new FormField(4, "*Last name", SoftKeyboardType.DEFAULT, FormField.TYPE_LAST_NAME);
			_spLastName.label = PlayerData.lastName;
			_spLastName.globalContext = this;
			_spLastName.dataClass = RegistrationFormData;
			_spLastName.dataProperty = "lastName";
			_spLastName.isRequired = requiredLName;
			_spLastName.showOnActivate = true;
			_spLastName.x = 25;
			_spLastName.y = (_spFirstName.y + _spFirstName.height + _gap);
			
			if(fbSession != null)
			_spLastName.defaultState = FormField.STATE_ON;
			
			this.addChild(_spLastName);
				
			//---------------------------------------o

			var requiredEmail:Boolean = true;
			if (PlayerData.email != null)
			{
			requiredEmail = false;
			RegistrationFormData.email = PlayerData.email;
			}
			
			_spEmail = new FormField(5, "*Email address", SoftKeyboardType.EMAIL, FormField.TYPE_EMAIL);
			_spEmail.label = PlayerData.email;
			_spEmail.isRequired = requiredEmail;
			_spEmail.dataClass = RegistrationFormData;
			_spEmail.dataProperty = "email";
			_spEmail.globalContext = this;
			_spEmail.showOnActivate = true;
			_spEmail.x = 25;
			_spEmail.y = (_spLastName.y + _spFirstName.height + _gap);
			
			if(fbSession != null)
			_spEmail.defaultState = FormField.STATE_ON;
			
			this.addChild(_spEmail);
			//---------------------------------------o
			
			_spConfirmEmail = new FormField(6, "*Confirm email address", SoftKeyboardType.EMAIL, FormField.TYPE_EMAIL, _spEmail);
			_spConfirmEmail.globalContext = this;
			_spConfirmEmail.showOnActivate = true;
			_spConfirmEmail.dataClass = RegistrationFormData;
			_spConfirmEmail.dataProperty = "confirmEmail";
			_spConfirmEmail.isRequired = true;
			_spConfirmEmail.x = 25;
			_spConfirmEmail.y = (_spEmail.y + _spFirstName.height + _gap);
			this.addChild(_spConfirmEmail);
			
			//---------------------------------------o
			
			_spPassword = new FormField(7, "*Password", SoftKeyboardType.DEFAULT, FormField.TYPE_PASSWORD);
			_spPassword.globalContext = this;
			_spPassword.showOnActivate = true;
			_spPassword.dataClass = RegistrationFormData;
			_spPassword.dataProperty = "password";
			_spPassword.isRequired = true;
			_spPassword.x = 25;
			_spPassword.y = (_spConfirmEmail.y + _spConfirmEmail.height + _gap);
			this.addChild(_spPassword);
			
			quContentBacking.height = 575;// this.height + 50;

			trace("quContentBacking.height :" + quContentBacking.height);
			
			_stxError = new TextField(480, 50, "*Mandatory", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.RED);
			_stxError.hAlign = HAlign.LEFT;
			_stxError.vAlign = VAlign.TOP;
			_stxError.x = 40;
			_stxError.y = _spPassword.y + _spPassword.height + 5;
			_stxError.autoSize = TextFieldAutoSize.VERTICAL;
			this.addChild(_stxError)

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
		//--- REGISTER
		//=======================================o
		
		private function register():void
		{
			var playerVO:PlayerVO = new PlayerVO();
			
			playerVO.device_type = DeviceType.deviceManufacturer;
			playerVO.firstName = _spFirstName.value;
			playerVO.lastName = _spLastName.value;
			playerVO.email = _spEmail.value;
			playerVO.password = _spPassword.value;
			playerVO.marketing_opt_in = _cbOptIn.value;
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
			
			
			Services.register.execute(playerVO, true, true, function():void {
				
					//Login After Register
					Services.login.execute(PlayerData.email, PlayerData.password, true, true,  function():void {
						
						_core.oDebugPanel.setTrace("onLogin success");
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME)
						//save empty object to server
						Services.savePlayerData.execute(false);
						
					});
					
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

                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					if (!_tt.checkTouch(touch))
					return;
					
					switch(e.target)
					{
																	
						case _simFooter:
						checkFormFields();
						break;
						
					}

                }

            }
			
		}
		
		//=======================================o
		//-- Validate Fields
		//=======================================o
		private function checkFormFields():void 
		{
			trace(this + "checkFormFields()");

				_spFirstName.callBack_confirm(_spFirstName.value);
				_spLastName.callBack_confirm(_spLastName.value);
				_spEmail.callBack_confirm(_spEmail.value);
				_spConfirmEmail.callBack_confirm(_spConfirmEmail.value);
				_spPassword.callBack_confirm(_spPassword.value);

			
			if (_spFirstName.isValid &&
					_spLastName.isValid &&
					_spEmail.isValid &&
					_spConfirmEmail.isValid &&
					_spPassword.isValid

				)
				{
					trace(this + "fields have all validated.. proceeding to register page 2");
					EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER_2, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						
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
			_tt.trash();
			_tt = null;
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}