package view.components.ui.screenPanels 
{

	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
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
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.valueObjects.PrizeVO;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.CustomCheckBox;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class PrePlayNoCompPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "PrePlayNoCompPanel";
		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _tt:TrueTouch;
		private var _quHitArea1:Quad;
		private var _quHitArea2:Quad;
		private var _simPracticeBtn:Image;
		private var _simRegisterBtn:Image;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function PrePlayNoCompPanel() 
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
			var h:int;
			_tt = new TrueTouch();
			//-----------------o
			//top header
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_skyHeaderTall") as MovieClip;
			mc.gotoAndStop("nocomp");
			h = mc.$mcBacking.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_skyHeaderTall", null, 1, 2, null, 0)
			var simTop:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_skyHeaderTall").getImage(false, 1);
			this.addChild(simTop);
			
			//-----------------o
			//content
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentPrePlayNoComp") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentPrePlayNoComp", null, 1, 1, null, 0)
			var simContent:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentPrePlayNoComp").getImage();
			simContent.y = simTop.y + h;
			this.addChild(simContent);
			
			//----------------o
			//Register btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "REGISTER";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simRegisterBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simRegisterBtn.name = "_simRegisterBtn";
			_simRegisterBtn.x = 0;
			_simRegisterBtn.y = simContent.y + simContent.height;
			this.addChild(_simRegisterBtn);
						
			//-----------------o
			//practice btn
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleLightBlueBtn") as MovieClip;
			mc.$txLabel.text = "PLAY ANYWAY";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn", null, 1, 1, null, 0)
			_simPracticeBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleLightBlueBtn").getImage();
			_simPracticeBtn.name = "_simPracticeBtn";
			_simPracticeBtn.x = 0;
			_simPracticeBtn.y = _simRegisterBtn.y + _simRegisterBtn.height;
			this.addChild(_simPracticeBtn);
			
			mc = null;
			
			var cb:CustomCheckBox
			cb = new CustomCheckBox(1, function():void {
			SharedObjects.setProperty("prePlaySeen", true);
			});
			
			cb.isRequired = false;
			cb.x = 0;
			cb.y = 750;// simContent.y + 300;//
			this.addChild(cb);
				
			//sub text
			var textFieldSub:TextField = new TextField(300, 100, "Don't ask me again", AppFonts.FONT_FUTURA_NORMAL, 30, HexColours.WHITE);
			textFieldSub.hAlign = HAlign.LEFT; 
			textFieldSub.vAlign = VAlign.TOP;
			textFieldSub.border = false;
			textFieldSub.x = 65// Math.floor(Data.deviceScaleX *20);
			textFieldSub.y = cb.y
			textFieldSub.autoSize = TextFieldAutoSize.VERTICAL;
			this.addChild(textFieldSub);
			
			_simRegisterBtn.addEventListener(TouchEvent.TOUCH, onTouch)
			_simPracticeBtn.addEventListener(TouchEvent.TOUCH, onTouch)

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
					
					switch(DisplayObject(e.target).name)
					{
						
						case "_simRegisterBtn":
						EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_LOGIN)
						break;	
						
						case "_simPracticeBtn":
						EventBus.getInstance().sigPlayClicked.dispatch(true);
						break;	

					}

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