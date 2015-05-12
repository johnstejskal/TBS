package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.net.SharedObject;
	import flash.text.SoftKeyboardType;
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
	import starling.display.Sprite;
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
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class PostFBLoginPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "PostFBLoginPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _simButton1:Image;
		private var _simButton2:Image;
		private var _spPassword:FormField;
		private var _tt:TrueTouch;
		private var _quForgotPassBtn:Quad;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function PostFBLoginPanel() 
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
			mc.$mcIcon.gotoAndStop("about")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentAppPass") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentAppPass", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentAppPass").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//email form field
			_spPassword = new FormField(4, "password", SoftKeyboardType.DEFAULT, FormField.TYPE_PASSWORD);
			_spPassword.isRequired = true;
			_spPassword.x = 30;
			_spPassword.y = _simContent.y + 120;
			this.addChild(_spPassword);
			
			//--------o
			//button Login
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "SUBMIT";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simButton1.x = 0;
			_simButton1.y = _simContent.y + _simContent.height;
			this.addChild(_simButton1);
			
			//---------o
			_quForgotPassBtn = new Quad(210, 50, 0xff00ff);
			_quForgotPassBtn.alpha = 0;
			_quForgotPassBtn.x = 195;
			_quForgotPassBtn.y = _simContent.y +230;
			this.addChild(_quForgotPassBtn);
			
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
						
						case _quForgotPassBtn:
						EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_FORGOT_PASS, SuperScreen.TRANSITION_TYPE_RIGHT, null)
						break;
					}
					
                }

            }
			
		}
		
		//=======================================o
		//-- validate Field
		//=======================================o
		private function checkFields():void 
		{
			_spPassword.callBack_confirm(_spPassword.value);
			
			if(_spPassword.isValid)
			{
				Services.login.execute(PlayerData.email, _spPassword.value, true, true, function():void {
				//success	
					SharedObjects.setProperty("facebookID", PlayerData.facebookID);
					loadUserData();
				},
				function():void 
				{
				//fail	
				 
						
				});
			}
		}
		
		//=======================================o
		//-- Post Login Callback
		//=======================================o
		private function loadUserData():void 
		{
			trace(this+"loadUserData");
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
					trace("PlayerData.hasAgreedAppTerms_1 :" + PlayerData.hasAgreedAppTerms_1);
					if(!PlayerData.hasAgreedAppTerms_1)
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_TERMS);
					else
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);
				}
				
				if (StateMachine.pendingLoginCallback != null)
				{
					StateMachine.pendingLoginCallback();
					StateMachine.pendingLoginCallback = null;
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