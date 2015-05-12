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
	import staticData.AppData;
	import staticData.AppFonts;
	import staticData.DeviceType;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TitleBar extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "TitleBar";

		private var _core:Core;
		private var _qBacking:Quad;
		private var _hexColour:uint = 0xf6534e;
		private var _label:String = "test";
		private var _enableMenuIcon:Boolean;
		private var _enableBackButton:Boolean;
		private var _isTransparent:Boolean;
		private var _simMenuIcon:Image;
		private var _simBackButton:Image;
		private var _spJaggedSlider:Sprite;
		private var _showSubBar:Boolean;
		private var _tfLabel:TextField;
		
		

		//=======================================o
		//-- Constructor
		//=======================================o
		public function TitleBar(showSubBar:Boolean = false) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_showSubBar = showSubBar;
			
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


			if(DeviceType.type == DeviceType.IPAD)
			_qBacking = new Quad(AppData.deviceResX, 60, _hexColour);
			else if (DeviceType.type == DeviceType.IPHONE_5)
			_qBacking = new Quad(AppData.deviceResX, 82, _hexColour);
			else if (DeviceType.type == DeviceType.IPHONE_4)
			_qBacking = new Quad(AppData.deviceResX, 82, _hexColour);
			else
			{
			_qBacking = new Quad(AppData.deviceResX, AppData.deviceScaleX*85, _hexColour);	
			}
			
			this.addChild(_qBacking);
			
			//var mc:MovieClip
			var mc:MovieClip;
			//----Add optional menu icon
			if (this.enableBackButton)
			{
				mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_titleBar_backButton") as MovieClip;
				
				//mc.scaleX = mc.scaleY = Data.deviceScaleX;
				if(DeviceType.type == DeviceType.IPAD)
				mc.width = mc.height = 60;
				else if (DeviceType.type == DeviceType.IPHONE_5)
				mc.width = mc.height = 82;
				else if (DeviceType.type == DeviceType.IPHONE_4)
				mc.width = mc.height = 82;
				else
				{
				//mc.width = mc.height = Data.deviceScaleX *82;
				mc.width = mc.height = AppData.deviceScaleX *82;
				}
			
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBar_backButton", null, 1, 1, null, 0);
				_simBackButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBar_backButton").getImage();
				_simBackButton.x = 0;
				_simBackButton.y = 0;
				this.addChild(_simBackButton);
				_simBackButton.addEventListener(TouchEvent.TOUCH, onTouch);
			}
			
			var fs:int;
				if(DeviceType.type == DeviceType.IPAD)
				fs = 34;
				else if (DeviceType.type == DeviceType.IPHONE_5)
				fs = 44;
				else if (DeviceType.type == DeviceType.IPHONE_4)
				fs = 44;
				else
				{
				fs = AppData.deviceScaleX * 44;
				}
			
			_tfLabel = new TextField(_qBacking.width, _qBacking.height, _label, AppFonts.FONT_ARIAL, fs, HexColours.WHITE);
			
			
			_tfLabel.hAlign = HAlign.CENTER; 
			_tfLabel.vAlign = VAlign.CENTER;
			_tfLabel.border = false;
			
			_tfLabel.autoSize = TextFieldAutoSize.NONE;
			_tfLabel.touchable = false
			addChild(_tfLabel);
			
			if (_isTransparent)
			{
			_qBacking.visible = false;
			_tfLabel.visible = false;
			}
			
			//=================================
			//-- 
			if (_showSubBar)
			{
				mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_titleBarJagged") as MovieClip;
				mc.scaleX = mc.scaleY = AppData.deviceScaleX;
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBarJagged", null, 1, 1, null, 0);
				var simJaggedBar:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBarJagged").getImage();
				
				simJaggedBar.x = 0;
				simJaggedBar.y = _qBacking.y+ _qBacking.height;
				
				_spJaggedSlider = new Sprite();
				_spJaggedSlider.addChild(simJaggedBar);
				this.addChildAt(_spJaggedSlider, 0);
				mc = null;	
			}

			

		}
		
		//=================================o
		//-- update label
		//=================================o
		public function updateLabel(displayName:String):void 
		{
			_tfLabel.text = displayName;
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
						
						case _simMenuIcon:
						trace("menu");
						EventBus.getInstance().sigSlideMenuAction.dispatch(null);
						break;
												
						case _simBackButton:
						EventBus.getInstance().sigBackButtonClicked.dispatch();
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

		
		public function set hexColour(value:uint):void 
		{
			_hexColour = value;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		public function get enableMenuIcon():Boolean 
		{
			return _enableMenuIcon;
		}
		
		public function set enableMenuIcon(value:Boolean):void 
		{
			_enableMenuIcon = value;
		}
		
		public function get enableBackButton():Boolean 
		{
			return _enableBackButton;
		}
		
		public function set enableBackButton(value:Boolean):void 
		{
			_enableBackButton = value;
		}
		
		public function get isTransparent():Boolean 
		{
			return _isTransparent;
		}
		
		public function set isTransparent(value:Boolean):void 
		{
			_isTransparent = value;
		}
		
		
	}

}