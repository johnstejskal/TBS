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
	import com.thirdsense.net.Analytics;
	import feathers.controls.ButtonGroup;
	import flash.text.SoftKeyboardType;
	import ManagerClasses.AssetsManager;
	import staticData.AppSettings;
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.ShopData;
	import staticData.Sounds;
	import staticData.valueObjects.ShopItemVO;
	import treefortress.sound.SoundAS;
	import view.components.ui.FormField;
	import view.components.ui.SuperPanel;

	import ManagerClasses.StateMachine;
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
	import staticData.NativeModalInputGroups;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.screens.PrizesWonScreen;
	import view.components.screens.ShopScreen;
	import view.components.screens.SuperScreen;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class RedeemPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "RedeemPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _ffInput:FormField;
		private var _simSubmitBtn:Image;
		private var _tt:TrueTouch;
		private var _code:String = "mcrich";
		private var _spEmail:FormField;
		private var _initComplete:Function;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function RedeemPanel(initComplete:Function = null) 
		{
			trace(this + "Constructed");
			_initComplete = initComplete;
			_core = Core.getInstance();
			
		//	if (stage) init(null);
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			init();
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event = null):void 
		{
			trace(this + "inited");
			
			_tt = new TrueTouch();
			
			var h:int;
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("questionMark")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_contentRedeem") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_contentRedeem", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_contentRedeem").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			//--------o
			//button Footer
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_panelSimpleRedBtn") as MovieClip;
			mc.$txLabel.text = "SUBMIT";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_panelSimpleRedBtn", null, 1, 1, null, 0)
			_simSubmitBtn = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_panelSimpleRedBtn").getImage();
			
			_simSubmitBtn.x = 0;
			_simSubmitBtn.y = _simContent.y + _simContent.height;
			
			this.addChild(_simSubmitBtn);
			mc = null;
			
			//--------o
			//email form field
			_ffInput = new FormField(1, "Enter code", SoftKeyboardType.DEFAULT, FormField.TYPE_NONE);
			_ffInput.isRequired = true;
			_ffInput.x = 30;
			_ffInput.y = _simContent.y + 20;
			this.addChild(_ffInput);
			
			_simSubmitBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			
			if (_initComplete)
			_initComplete();
			
		}


		//private function updateHeaderImage(isWin:Boolean = true):void
		private function updateHeaderImage(frame:String):void
		{
			var framelabel:String = "questionMark";
			if (frame != null)
			framelabel = frame;
			
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, "TA_shortHeader");
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop(framelabel)
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)

			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);	
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
					
					if (e.target == _simSubmitBtn)
					{
						_code = _ffInput.value;
						
						if (_ffInput.value == PublicSettings.STEAK_SUIT_CODE && !_core.controlBus.inventoryController.checkForItemByRef("steakSuit"))
						{
							if (ShopData.steakSuitAvailable)
							{
								SoundAS.playFx(Sounds.SFX_HOO_STEAK_SUIT);
								PlayerData.steakSuitUnlocked = true;
								
								var itemVO:ShopItemVO = _core.controlBus.shopItemController.findVO("steakSuit");
								itemVO.PURCHASED = true;
								Inventory.arrShopItems.push(itemVO);
								_core.controlBus.inventoryController.equipItem(itemVO);

								Services.savePlayerData.execute(false, false);
								updateHeaderImage("steakSuit");
								_core.controlBus.appUIController.showNotification("HUZZAH!", "Steak Suit Unlocked!", "OK", function():void {
								if(StateMachine.currentAppState == StateMachine.STATE_REDEEM){	
								_ffInput.changeState(FormField.STATE_OFF, "Enter code");
								}
								}, null, null, 1); 
							}
							//steak suit not yet available
							else
							{
								_core.controlBus.appUIController.showNotification("WHOOPS", NotificationLabel.CODE_NOT_AVAILABLE, "OK", function():void {
								if(StateMachine.currentAppState == StateMachine.STATE_REDEEM){	
								_ffInput.changeState(FormField.STATE_OFF, "Enter code");
								}
								}, null, null, 1); 	
							}
						}
						else
						{
						Analytics.trackEvent(AppSettings.ANALYTICS_CATEGORY, AppSettings.REDEEM_SCREEN,  AppSettings.REDEEM_CODE_BUTTON, 1);
						Services.redeemCode.execute(_code, true, true, onSuccess, onFail);
						}
					}
                }
 
            }
			
		}
		
		private function onFail():void 
		{
			_ffInput.changeState(FormField.STATE_OFF, "Enter Code");
		}
		
		private function onSuccess(amount:Number):void 
		{
			trace(this + "---------------------code redeemed");
			SoundAS.playFx(Sounds.SFX_CASH_REGISTER, 1);	
			updateHeaderImage("coins");
			_ffInput.changeState(FormField.STATE_OFF, "");
				if (PublicSettings.LOCATION == "AU")
				{
					_core.controlBus.appUIController.showNotification("HUZZAH!", amount + " Banked.", "OK", function():void {
					if(StateMachine.currentAppState == StateMachine.STATE_REDEEM){	
					_ffInput.changeState(FormField.STATE_OFF, "Enter code");
					}
					}, null, null, 1); 
				}
				else
				{
					_core.controlBus.appUIController.showNotification("BOO-YAH!", amount + " Banked.", "OK", function():void {
					if(StateMachine.currentAppState == StateMachine.STATE_REDEEM){	
					_ffInput.changeState(FormField.STATE_OFF, "Enter code");
					}
					}, null, null, 1); 
				}
		}
		
		private function updateField():void 
		{
			_ffInput.callBack_confirm(_ffInput.value);
			
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