package view.components.ui 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
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
	import staticData.DeviceType;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class NotificationPanel extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "NotificationPanel";

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

		//=======================================o
		//-- Constructor
		//=======================================o
		public function NotificationPanel() 
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
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//content area
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_notificationPopup") as MovieClip;

			//mc.$mcMiddle.$txTitle.text = _titleText;
			//mc.$mcMiddle.$txSubText.text = _subText;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationPopup", null, 1, 1, null, 0)
			var simPanel:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationPopup").getImage();
			this.addChild(simPanel);
			
			var stxText1:TextField = new TextField(440, 100, _titleText, AppFonts.FONT_ARIAL, 71, HexColours.RED);
			stxText1.hAlign = HAlign.CENTER;
			stxText1.vAlign = VAlign.TOP;
			stxText1.x = 40;
			stxText1.y = 70;
			stxText1.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(stxText1);
			
			var stxText2:TextField = new TextField(442, 120, _subText, AppFonts.FONT_ARIAL, 20, HexColours.GREY);
			stxText2.hAlign = HAlign.CENTER;
			stxText2.vAlign = VAlign.TOP;
			stxText2.x = 38;
			stxText2.y = stxText1.y + stxText1.height + 20;
			stxText2.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(stxText2);
			
			
			
			//----------------o
/*			if (_buttonCount > 0)
			{
			//btn 1 (red)
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_notificationButtonRed") as MovieClip;
			trace("_btn1Text :" + _btn1Text);
			mc.$txLabel.text = _btn1Text;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationButtonRed", null, 1, 1, null, 0)
			_simBtn1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationButtonRed").getImage();
			_simBtn1.y = simPanel.y + simPanel.height;
			this.addChild(_simBtn1);
			_simBtn1.addEventListener(TouchEvent.TOUCH, onTouch);
			//----------------o				
			}
			
			if (_buttonCount == 2)
			{
			//btn 2 (white)
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_notificationButtonWhite") as MovieClip;
			mc.$txLabel.text = _btn2Text;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationButtonWhite", null, 1, 1, null, 0)
			_simBtn2 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationButtonWhite").getImage();
			_simBtn2.y = _simBtn1.y + _simBtn1.height;
			this.addChild(_simBtn2);
			_simBtn2.addEventListener(TouchEvent.TOUCH, onTouch);
			}*/
			
			
			if (_buttonCount > 0)
			{
			//btn 1 (red)
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_notificationButtonRed") as MovieClip;
			trace("_btn1Text :" + _btn1Text);
			mc.$txLabel.text = _btn1Text;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationButtonRed", null, 1, 1, null, 0)
			_simBtn1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationButtonRed").getImage();
			_simBtn1.y = simPanel.y + simPanel.height;
			this.addChild(_simBtn1);
			_simBtn1.addEventListener(TouchEvent.TOUCH, onTouch);
			//----------------o				
			}
			
			if (_buttonCount == 2)
			{
			//btn 2 (white)
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_notificationButtonWhite") as MovieClip;
			mc.$txLabel.text = _btn2Text;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationButtonWhite", null, 1, 1, null, 0)
			_simBtn2 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationButtonWhite").getImage();
			_simBtn2.y = _simBtn1.y + _simBtn1.height;
			this.addChild(_simBtn2);
			_simBtn2.addEventListener(TouchEvent.TOUCH, onTouch);
			}
			
			
			//----------------o			
			mc = null;
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			this.x = AppData.deviceResX / 2;
			this.y = AppData.deviceResY / 2;
			this.scaleX = this.scaleY = AppData.offsetScaleX;
			
			//-----------------------------------------------o
			//responsive scaling
			if (DeviceType.type == DeviceType.IPAD)
			{

			}
			else if (DeviceType.type == DeviceType.IPHONE_5)
			{
	
			}
			else if (DeviceType.type == DeviceType.IPHONE_4)
			{

			}
			//unknown device
			else
			{
				//if smaller then 640
				if (AppData.offsetScaleX < 1)
				{
				this.scaleX = this.scaleY = AppData.offsetScaleX;
				}
				else 
				{

				}
			}
		    //-----------------------------------------------o
			
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
					switch(e.target)
					{
						case _simBtn1:
						trace(this + "_simBtn1 pressed");
						if(_fnBtn1Callback != null)
						_fnBtn1Callback();
						break;
						
						case _simBtn2:
						trace(this + "_simBtn2 pressed");
						if(_fnBtn2Callback != null)
						_fnBtn2Callback();
						break;
					}
					
				
					
                }

            }
			
			
		}
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public  function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			this.removeEventListeners();
			
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