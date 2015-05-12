package view.components.ui.screenPanels 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
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
	import starling.utils.deg2rad;
	import staticData.AppSettings;
	import staticData.Inventory;
	import staticData.NotificationLabel;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.Sounds;
	import staticData.SpriteSheets;
	import staticData.valueObjects.ShopItemVO;
	import treefortress.sound.SoundAS;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class ShopItemDetailsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "ShopItemDetailsPanel";

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
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _itemVO:ShopItemVO;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function ShopItemDetailsPanel(itemVO:ShopItemVO) 
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
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shopItemDetails") as MovieClip;
			mc.$txName.text = _itemVO.NAME;
			mc.$txDescription.text = _itemVO.DESCRIPTION;
			
			var frameName:String = _itemVO.REF;
			
			if (_itemVO.LEVELABLE)
			frameName += String(_itemVO.LEVEL)
			
			mc.$mcImage.gotoAndStop(frameName);
			
			if(!_itemVO.CRITERIA_MET)
			mc.$mcBacking.$mcFill.gotoAndStop(2);
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shopItemDetails", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shopItemDetails").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			mc = null;
			//-------o
			
			//footer Element
			updateFooter();
			
		}
		
		//=======================================o
		//-- create/ update the footer component
		//=======================================o
		private function updateFooter():void 
		{
			
			if (_simFooter) {
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, "TA_shopItemFooter")
			this.removeChild(_simFooter);
			_simFooter = null;
			}
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shopItemFooter") as MovieClip;
			mc.$txPrice.text = String(_itemVO.PRICE);
			
			if (!_itemVO.CRITERIA_MET && !_itemVO.IS_DEFAULT_ITEM)
			{
				mc.$mcActionButton.visible = false;
			}
			//if default item and levelable -  is powerup
			else if (_itemVO.IS_DEFAULT_ITEM)
			{
				if (_itemVO.LEVELABLE)
				{
					mc.$mcActionButton.gotoAndStop("owned");
				}
				//not levelable -  is fashion item
				else
				{
					if (_itemVO.EQUIPPED)
					{
						trace("IS EQUIPPED");
						mc.$mcActionButton.gotoAndStop("owned");
					}
					else
					{
						mc.$mcActionButton.gotoAndStop("equip");	
					}
				}
			
			}
			//not default item
			else
			{
				//if not owned
				if (!_itemVO.PURCHASED)
				{
					mc.$mcActionButton.gotoAndStop("purchase");
				}
				//if owned
				else 
				{
					//if levelable
					if (_itemVO.LEVELABLE)
					{
					//	if (_itemVO.EQUIPPED)
						mc.$mcActionButton.gotoAndStop("owned");
						//else
						//mc.$mcActionButton.gotoAndStop("equip");
					}
					//not levelable
					else
					{
						if (_itemVO.EQUIPPED)
						mc.$mcActionButton.gotoAndStop("unequip");
						else
						mc.$mcActionButton.gotoAndStop("equip");
					}

				}
			}


			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shopItemFooter", null, 1, 1, null, 0)
			//mc.scaleX = mc.scaleY = Data.deviceScaleX;
			
			_simFooter = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shopItemFooter").getImage();
			
			//allow touch for unequipped default outfit, all other fashion, and non default powerups
			if ((!_itemVO.IS_DEFAULT_ITEM || _itemVO.IS_DEFAULT_ITEM && !_itemVO.LEVELABLE && !_itemVO.EQUIPPED) && _itemVO.CRITERIA_MET)
			_simFooter.addEventListener(TouchEvent.TOUCH, onTouch)
			
			_simFooter.x = 0;
			_simFooter.y = 640;
			this.addChild(_simFooter);	
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
					trace(this + "onTouch()");
					//if item is not yet owned show a popup and allow for purchase.
					if (!_itemVO.PURCHASED)
					{
					_core.controlBus.appUIController.showNotification(NotificationLabel.SHOP_PURCHASE_HEADER, NotificationLabel.SHOP_PURCHASE_SUB, "YES", confirmPurchase, "NO", null, 2);
					
					if(PublicSettings.ENABLE_ANALYTICS)
					Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHOP_ITEM_DETAILS, ShopItemVO(_itemVO).NAME+"_purchase", 1);
					}
					else
					//if item is owned, toggle equip status
					{
						//if item is a fashion item
						if (!_itemVO.LEVELABLE)
						{
							if (_itemVO.EQUIPPED)
							{
								_itemVO.EQUIPPED = false;
								if(PublicSettings.ENABLE_ANALYTICS)
								Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHOP_ITEM_DETAILS, ShopItemVO(_itemVO).NAME+"_unequip", 1);
								
								_core.controlBus.inventoryController.unequipItem(_itemVO);	
							}
							else
							{
								if(PublicSettings.ENABLE_ANALYTICS)
								Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHOP_ITEM_DETAILS, ShopItemVO(_itemVO).NAME+"_equip", 1);
								
								_core.controlBus.inventoryController.equipItem(_itemVO);	
							}
							
							TweenLite.delayedCall(.5, function():void
							{
								EventBus.getInstance().sigSubScreenChangeRequested.dispatch(ShopScreen.STATE_PREVIOUS, SuperScreen.TRANSITION_TYPE_LEFT, null);
							})
						}
						updateFooter();
					}
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {

                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		//=========================================o
		//--- confirm purchase
		//=========================================o
		private function confirmPurchase():void 
		{
			trace(this+"confirmPurchase() :" + _itemVO.NAME);
			if(PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.SHOP_ITEM_DETAILS, ShopItemVO(_itemVO).NAME+"_purchasedConfirmed", 1);
			
			_core.controlBus.shopItemController.purchaseItem(_itemVO, null, true)
			updateFooter();
			TweenLite.delayedCall(.5, function():void
			{
				SoundAS.playFx(Sounds.SFX_CASH_REGISTER);
				EventBus.getInstance().sigSubScreenChangeRequested.dispatch(ShopScreen.STATE_PREVIOUS, SuperScreen.TRANSITION_TYPE_LEFT, null);
			})
		}
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		public override function deactivate():void 
		{
			trace(this + "deactivate()");
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