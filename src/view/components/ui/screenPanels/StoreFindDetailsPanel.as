package view.components.ui.screenPanels 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.StringFunctions;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import mx.utils.StringUtil;
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
	import starling.utils.deg2rad;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import staticData.valueObjects.ShopItemVO;
	import staticData.valueObjects.StoreVO;
	import view.components.screens.ShopScreen;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class StoreFindDetailsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "StoreFindDetailsPanel";

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
		private var _itemVO:StoreVO;
		private var _simPanel:Image;
		private var _simPanelTop:Image;
		private var _simPanelContent:Image;
		private var _tt:TrueTouch;
		private var _simMapBtn:Image;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function StoreFindDetailsPanel(itemVO:StoreVO) 
		{
			_itemVO = itemVO;
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
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_storeFindDetailsTop") as MovieClip;
			mc.$mcMarker.$txKm.text = _itemVO.DISTANCE_FROM_USER;
			//mc.scaleX = mc.scaleY = Data.deviceScaleX;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_storeFindDetailsTop", null, 1, 1, null, 0)
			_simPanelTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_storeFindDetailsTop").getImage();
			
			//Top image area

			_simPanelTop.x = 0;
			addChild(_simPanelTop)
			
			//Content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_storeFinderDetailsContent") as MovieClip;
			mc.$txName.text = _itemVO.TITLE;
			mc.$txAddress.text = _itemVO.ADDRESS+", "+_itemVO.SUBURB;
			mc.$mcLowerDetails.y = mc.$txAddress.y + mc.$txAddress.height + 20;
			mc.$mcLowerDetails.$txPhoneNumberTitle.text = "TELEPHONE";
			mc.$mcLowerDetails.$txPhoneNumber.text = _itemVO.PHONE;
			
			mc.$mcLowerDetails.$txOpeningHoursTitle.text = "OPENING HOURS";
			
			mc.$mcLowerDetails.$txMonday.text = "Mon : "+StringFunctions.convertTo12Hr(_itemVO.MONDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.MONDAY_CLOSE);
			mc.$mcLowerDetails.$txTuesday.text = "Tue : "+StringFunctions.convertTo12Hr(_itemVO.TUESDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.TUESDAY_CLOSE);
			mc.$mcLowerDetails.$txWednesday.text = "Wed : "+StringFunctions.convertTo12Hr(_itemVO.WEDNESDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.WEDNESDAY_CLOSE);
			mc.$mcLowerDetails.$txThursday.text = "Thur : "+StringFunctions.convertTo12Hr(_itemVO.THURSDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.THURSDAY_CLOSE);
			mc.$mcLowerDetails.$txFriday.text = "Fri : "+StringFunctions.convertTo12Hr(_itemVO.FRIDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.FRIDAY_CLOSE);
			mc.$mcLowerDetails.$txSaturday.text = "Sat : "+StringFunctions.convertTo12Hr(_itemVO.SATURDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.SATURDAY_CLOSE);
			mc.$mcLowerDetails.$txSunday.text = "Sun : "+StringFunctions.convertTo12Hr(_itemVO.SUNDAY_OPEN)+" - "+StringFunctions.convertTo12Hr(_itemVO.SUNDAY_CLOSE);
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_storeFinderDetailsContent", null, 1, 1, null, 0)
			
			_simPanelContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_storeFinderDetailsContent").getImage();
			_simPanelContent.x = 0;
			_simPanelContent.y = _simPanelTop.y + _simPanelTop.height;
			
			var qu:Quad = new Quad(_simPanelTop.width, _simPanelContent.height + 40, HexColours.WHITE)
			qu.y = _simPanelTop.y + _simPanelTop.height;
			addChild(qu);
			addChild(_simPanelContent);
			
			
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "SHOW ON MAP"
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simMapBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			_simMapBtn.x = 0;
			_simMapBtn.y = qu.y + qu.height;
			this.addChild(_simMapBtn)
			
			_simMapBtn.addEventListener(TouchEvent.TOUCH, onTouch);
		
			mc = null;

		}
		
		//===========================================o	
		//------ Touch Handlers 
		//===========================================o		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				
				//------------------------------------------------o
				if (touch.phase == TouchPhase.BEGAN)
				{
					_tt.mapTouch(touch);
				}
				//------------------------------------------------o
				else if (touch.phase == TouchPhase.ENDED)
				{
					if(!_tt.checkTouch(touch))
					return;
					
					if (e.target == _simMapBtn)
					{
						Util.openURL("http://maps.google.com/maps?z=18&q=" + _itemVO.LATITUDE + "," + _itemVO.LONGDITUDE)	
					}
				}
				//------------------------------------------------o
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