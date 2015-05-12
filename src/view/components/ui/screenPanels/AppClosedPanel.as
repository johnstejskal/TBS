package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
	import staticData.DeviceType;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.valueObjects.PrizeVO;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ProfileScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	//=======================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//=======================================o
	
	public class AppClosedPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "AppClosedPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simContent:Image;

		private var _tt:TrueTouch;
		private var _simExitBtn:Image;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function AppClosedPanel() 
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
			
			_tt = new TrueTouch();
			
			trace(this + "inited");
			var h:int;
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("cat")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//content
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentAppClosed") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentAppClosed", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentAppClosed").getImage();
			_simContent.x = 0;
			_simContent.y = _simTop.y + h;	
			this.addChild(_simContent);
		
			//if android, show exit
			//--------o
			//exit btn
			if (DeviceType.deviceManufacturer == "android")
			{
				mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleMidBlueBtn") as MovieClip;
				mc.$txLabel.text = "EXIT";
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleMidBlueBtn", null, 1, 1, null, 0)
				_simExitBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleMidBlueBtn").getImage();
				_simExitBtn.name = "_simExitBtn";
				_simExitBtn.x = 0;
				_simExitBtn.y = _simContent.y + _simContent.height;
				
				this.addChild(_simExitBtn);
				
				_simExitBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			}
			
			mc = null;
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
				    	case _simExitBtn:
						//exit app
						break;
						
					}
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
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