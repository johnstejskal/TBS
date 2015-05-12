
package view.components.ui.screenPanels 
{


	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import flash.text.SoftKeyboardType;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import net.AppServices;
	import net.Services;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
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
	import staticData.LoadingLabel;
	import staticData.LocalData;
	import staticData.NativeModalInputGroups;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.screens.LoginScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;
	
	//=================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//=================================o
	
	public class ForgotPassPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "ForgotPassPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _simButton1:Image;
		private var _simButton2:Image;
		private var _spEmail:FormField;
		private var _spPassword:FormField;
		private var _tt:TrueTouch;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function ForgotPassPanel() 
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
			mc.$mcIcon.gotoAndStop("about")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)
			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentForgotPass") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentForgotPass", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentForgotPass").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//-------o
			//email form field
			_spEmail = new FormField(9, "email", SoftKeyboardType.EMAIL, FormField.TYPE_EMAIL);
			_spEmail.isRequired = true;
			_spEmail.x = 30;
			_spEmail.y = _simContent.y + 120;
			this.addChild(_spEmail);
			
			
			//--------o
			//button Login
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "SUBMIT";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simButton1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simButton1.x = 0;
			_simButton1.y = _simContent.y + _simContent.height;
			this.addChild(_simButton1);
			

			_simButton1.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
					}
                }

            }
		}
		
		//=======================================o
		//-- Validate fields
		//=======================================o
		private function checkFields():void 
		{
			_spEmail.callBack_confirm(_spEmail.value);
			
			if(_spEmail.isValid)
			Services.retrievePassword.execute(_spEmail.value, true, true, function():void {
				
				StateMachine.allowDeviceActivate = false;
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(LoginScreen.STATE_HOME);	
				
			});
			
		}
		
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			_tt.trash();
			_tt = null;
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}