
package view.components.ui.screenPanels 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.AppServices;
	import net.Services;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
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
	import staticData.LoadingLabel;
	import staticData.LocalData;
	import staticData.NativeModalInputGroups;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SharedObjectKeys;
	import staticData.SpriteSheets;
	import view.components.screens.LoginScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;
	
	//===============================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//===============================o
	
	public class EmailLoginPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "EmailLoginPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _simButton1:Image;
		private var _simButton2:Image;
		private var _spEmail:FormField;
		private var _spPassword:FormField;
		private var _tt:TrueTouch;
		private var _quForgotPassBtn:Quad;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function EmailLoginPanel() 
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
			
			//top section
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("about")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_emailLoginContent") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_emailLoginContent", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_emailLoginContent").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			_quForgotPassBtn = new Quad(210, 50, 0xff00ff);
			_quForgotPassBtn.alpha = 0;
			_quForgotPassBtn.x = 195;
			_quForgotPassBtn.y = _simContent.y +230;
			this.addChild(_quForgotPassBtn);
			
			//-------o
			//email form field
			_spEmail = new FormField(1, "email", SoftKeyboardType.EMAIL, FormField.TYPE_EMAIL);
			_spEmail.globalContext = this;
			_spEmail.showOnActivate = true;
			_spEmail.isRequired = true;
			_spEmail.x = 30;
			_spEmail.y = _simContent.y + 20;
			this.addChild(_spEmail);
			
			//-------o
			//password form field
			_spPassword = new FormField(2, "password", SoftKeyboardType.DEFAULT, FormField.TYPE_PASSWORD);
			_spEmail.globalContext = this;
			_spPassword.showOnActivate = true;
			_spPassword.isRequired = true;
			_spPassword.x = 30;
			_spPassword.y = _simContent.y + 125;
			this.addChild(_spPassword);
			
			//--------o
			//button Login
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "LOGIN";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simButton1.x = 0;
			_simButton1.y = _simContent.y + _simContent.height;
			this.addChild(_simButton1);
			
			mc = null;
			
			_simButton1.addEventListener(TouchEvent.TOUCH, onTouch)
			_quForgotPassBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
						case _simButton1:
						checkFields();
						break;
						
						case _simButton2:
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_REGISTER, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						break;
						
						case _quForgotPassBtn:
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_FORGOT_PASS, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						break;
					}
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		//=======================================o
		//-- Validate fields
		//=======================================o
		private function checkFields():void 
		{
			_spEmail.callBack_confirm(_spEmail.value);
			_spPassword.callBack_confirm(_spPassword.value);
			
			
			if (_spEmail.isValid && _spPassword.isValid)
			{
				Services.login.execute(_spEmail.value, _spPassword.value, true, true, loadUserData, null);
			}
			
		}
		
		//=======================================o
		//-- Login callback 
		//=======================================o
		private function loadUserData():void 
		{
			trace(this + "loadUserData");
			
			Services.loadPlayerData.execute(true, true, function():void {
				
				if (StateMachine.pendingRegisterCallback != null)
				{
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
					if(!PlayerData.hasAgreedAppTerms_1)
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_TERMS);
					else
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);
				}
				
			})
				
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