package ManagerClasses.controllers 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.thirdsense.data.LPLocalData;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import ManagerClasses.supers.SuperController;

	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import staticData.AppData;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.PlayerData;
	import staticData.dataObjects.ShopData;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.valueObjects.achievement.Achievement1VO;
	import staticData.valueObjects.achievement.Achievement2VO;
	import staticData.valueObjects.achievement.Achievement3VO;
	import staticData.valueObjects.achievement.Achievement4VO;
	import staticData.valueObjects.powerUps.AntiGravityVO;
	import staticData.valueObjects.powerUps.BoostMoveVO;
	import staticData.valueObjects.powerUps.BoostVO;
	import staticData.valueObjects.powerUps.CoinDoubleVO;
	import staticData.valueObjects.powerUps.CoinMagnetVO;
	import staticData.valueObjects.powerUps.HeadGearVO;
	import staticData.valueObjects.powerUps.NugMultipleVO;
	import staticData.valueObjects.powerUps.NugSuitVO;
	import staticData.valueObjects.powerUps.SaucesVO;
	import staticData.valueObjects.powerUps.SlowDownVO;
	import staticData.valueObjects.ShopItemVO;
	import staticData.XMLData;
	import view.components.screens.LoadingScreen;
	import view.components.ui.MenuIcon;
	import view.components.ui.SlideOutMenu;
	import view.StarlingStage;
	
	//================================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//================================================o
	
	public class ShopItemController extends SuperController
	{
		private var _arrShopItems:Array;
		private var _xmlShopItems:XML;
		private var _arrReadOnlyItemsList:Array;
		
		
		//================================================o
		//------ Constructor
		//================================================o			
		public function ShopItemController() 
		{
			trace("ShopItemsController constructed");
			
		}
		
		//================================================o
		//------ init
		//================================================o				
		public function init():void
		{
			trace(this+ "inited");
			if (core.controlBus.inventoryController == null)
			throw new Error(this+"init() Error: You must initiate the inventory controller before the Shop controller" )
			
			_arrShopItems = new Array();
			
			_xmlShopItems = new XML( new XMLData["ShopItemList_AU"]());		
			parseShopItemList()
			
		}
		
		//================================================o
		//------ xml loaded callback
		//================================================o	
		private function processXML(e:Event):void 
		{
			parseShopItemList();
		}
		
		//===============================================o
		//-- Parse the Shop item list
		//-- push all data into Value Objects
		//-- creates master list
		//===============================================o
		private function parseShopItemList():void 
		{
			trace(this+"parseShopItemList()")
			_arrShopItems = new Array();
			_arrReadOnlyItemsList = new Array();
			
			for (var i:int = 0; i < _xmlShopItems.*.length(); i++)
			{
				
				var item:ShopItemVO = new ShopItemVO();
				item.NAME = _xmlShopItems.ITEM[i].NAME;
				item.REF = _xmlShopItems.ITEM[i].REF;
				
				
				if((_xmlShopItems.ITEM[i].LEVELABLE) == "yes")
				item.LEVELABLE = true;
				else
				item.LEVELABLE = false;
				
				if((_xmlShopItems.ITEM[i].DEFAULT_ITEM) == "true")
				item.IS_DEFAULT_ITEM = true;
				else
				item.IS_DEFAULT_ITEM = false;
				
				if (item.LEVELABLE)
				item.LEVEL = _xmlShopItems.ITEM[i].LEVEL;
				
				//If a default item, add it to the inventory without cost
				if (item.IS_DEFAULT_ITEM)
				{
				item.EQUIPPED = true;	
				item.PURCHASED = true;
				Inventory.arrShopItems.push(item);
				}
				
				item.ID = _xmlShopItems.ITEM[i].@id;
				item.TYPE = _xmlShopItems.ITEM[i].TYPE;
				item.DESCRIPTION = _xmlShopItems.ITEM[i].DESCRIPTION;
				item.PRICE = _xmlShopItems.ITEM[i].PRICE;
				item.AVAILABLE = _xmlShopItems.ITEM[i].AVAILABLE;
				
				item.DESCRIPTION = item.DESCRIPTION.split("~").join("\n");


				//creates a read only list to be filtered based on inventory purchases
				_arrReadOnlyItemsList.push(item);
					
			}

		}

		
		//=================================================o
		// after game load from server, restore purchases
		//=================================================o
		public function updatePurchasedAfterLoad():void
		{
			
			trace(this + "updatePurchasedAfterLoad()");
			var lngth:int = _arrReadOnlyItemsList.length;
			
			for (var i:int = 0; i < lngth; i++) 
			{
				var item:ShopItemVO = _arrReadOnlyItemsList[i];
				
				for (var j:int = 0; j < PlayerData.arrPurchasedItems.length; j++) 
				{
					var ownedItem:ShopItemVO = ShopItemVO(PlayerData.arrPurchasedItems[j]);
					if (item.ID == ownedItem.ID)
					{

						item.EQUIPPED = ownedItem.EQUIPPED;
						item.PURCHASED = true;
/*						trace("=====================================");
						trace("item.ID :" + item.ID );
						trace("item.EQUIPPED :" + item.EQUIPPED );
						trace("item.PURCHASED :" + item.PURCHASED );
						trace("item.PURCHASED :" + item.PURCHASED );
						trace("=====================================");*/
						if(Inventory.arrShopItems.indexOf(item) == -1)
						Inventory.arrShopItems.push(item)
						
						
						//if power up, restore to correct level
						//if (item.TYPE != "fashion" && item.EQUIPPED && !item.IS_DEFAULT_ITEM)
						//core.controlBus.powerupController.restoreSkillLevel(item);
					}
					
				}

			}
			
			//checkForProblemInData();
			trace(this+"Inventory Restored: length is:"+Inventory.arrShopItems.length)
		}
		
		private function checkForProblemInData():void 
		{

				//TODO check if corrupted data object, if player has no powerup up types equipped, 
				// determin the highest level owned and equip it. 
				var arrHeadGear:Array = new Array();
				
				for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
				{
					if (ShopItemVO(Inventory.arrShopItems[i]).REF == "headGear")
					arrHeadGear.push(ShopItemVO(Inventory.arrShopItems[i]));
					
					trace("arrHeadGear :"+arrHeadGear)
				}
				
				var equippedCount:int = 0;
				for (var j:int = 0; j < arrHeadGear.length; j++) 
				{
					if (ShopItemVO(arrHeadGear[j]).EQUIPPED == true)
					equippedCount ++;
				}

				if (equippedCount == 0)
				{
					ShopItemVO(arrHeadGear[arrHeadGear.length - 1]).EQUIPPED = true;
					HeadGearVO.CURRENT_LEVEL = int(ShopItemVO(arrHeadGear[arrHeadGear.length - 1]).LEVEL);
				}

		}
		
		//==============================================================o
		//-- update the shop items list
		//-- call this whenever the shopScreen is initiated
		// this filters the readOnlyItemsList based on existing
		// purchases and upgrades
		//=======================================================o
		public function updateShopItemList(queryType:String = ""):void 
		{
			
			//Filter out items not required, such as items not hyet available and old powerup levels
			var arrNewShopsArray:Array = new Array();
			
			for (var i:int = 0; i < _arrReadOnlyItemsList.length; i++) 
			{
				var item:ShopItemVO = ShopItemVO(_arrReadOnlyItemsList[i]);
				var allowItem:Boolean = false;
				
				//unlock the nect level of a levelable skill, so it is available for purchase
				if (item.LEVELABLE)
				{
					
					switch(item.REF)
					{
						case CoinMagnetVO.REF_NAME:
						item.SKILL_VO = CoinMagnetVO;
						if (item.LEVEL == String(CoinMagnetVO.CURRENT_LEVEL + 1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
								
						case HeadGearVO.REF_NAME:
						item.SKILL_VO = HeadGearVO;
						if (item.LEVEL == String(HeadGearVO.CURRENT_LEVEL + 1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
								
						case SlowDownVO.REF_NAME:
						item.SKILL_VO = SlowDownVO;
						if (item.LEVEL == String(SlowDownVO.CURRENT_LEVEL + 1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
								
						case CoinDoubleVO.REF_NAME:
						item.SKILL_VO = CoinDoubleVO;
						if (item.LEVEL == String(CoinDoubleVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
						
						case BoostVO.REF_NAME:
						item.SKILL_VO = BoostVO;
						if (item.LEVEL == String(BoostVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;	
						
						case BoostMoveVO.REF_NAME:
						item.SKILL_VO = BoostMoveVO;
						if (item.LEVEL == String(BoostMoveVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
						
						case AntiGravityVO.REF_NAME:
						item.SKILL_VO = AntiGravityVO;
						if (item.LEVEL == String(AntiGravityVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
												
						case NugMultipleVO.REF_NAME:
						item.SKILL_VO = NugMultipleVO;
						if (item.LEVEL == String(NugMultipleVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
																		
						case SaucesVO.REF_NAME:
						item.SKILL_VO = SaucesVO;
						if (item.LEVEL == String(SaucesVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
																								
						case NugSuitVO.REF_NAME:
						item.SKILL_VO = NugSuitVO;
						if (item.LEVEL == String(NugSuitVO.CURRENT_LEVEL+1))
						{
						allowItem = true;
						item.CRITERIA_MET = true;
						}
						break;
						
					}
						
				}
				//ELSE NOT A LEVELABLE
				else
				{
					allowItem = true
					item.CRITERIA_MET = true;
				}
				
				//if default starting item (level 1)
				if(item.IS_DEFAULT_ITEM)
				item.CRITERIA_MET = true;
				
				
				if (Inventory.coins < int(item.PRICE))
				item.CRITERIA_MET = false;
				
				
				if (item.PURCHASED)
				item.CRITERIA_MET = true;
				
				
				//if user is logged out, lock all shop items
				//if (UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_OUT && !PublicSettings.ENABLE_UNLOGGED_SHOP_PURCHASE)
				//item.CRITERIA_MET = false;
				
				
				/*
				 * By commenting out the line below, you can allow a levelable shop item system, so only
				 * the next level of a item is visible
				 */
				allowItem = true;
				
				
				//Filter specific Query
				if (item.TYPE == queryType)
				allowItem = true;
				else
				allowItem = false;
				
				if (allowItem == true)
				arrNewShopsArray.push(item);
			}
			
			_arrShopItems.length = 0;
			_arrShopItems = arrNewShopsArray;
			
		}
		
		//================================================o
		//------ trash/kill/dispose
		//================================================o		
		public function trash():void
		{
			
		}
		
		//================================================o
		//------ Purchase Item
		//================================================o	
		public function purchaseItem(itemVO:ShopItemVO, callback:Function, equipItem:Boolean = true):void 
		{
			
			trace("purchaseItem()" + itemVO.NAME + " level:" + itemVO.LEVEL);
			
			if (Inventory.arrShopItems.indexOf(itemVO) == -1 && Inventory.coins >= int(itemVO.PRICE))
			{
				Inventory.arrShopItems.push(itemVO)
				itemVO.PURCHASED = true;
				
				Inventory.coins -= int(itemVO.PRICE);
				itemVO.PURCHASED = true;
				//core.controlBus.appUIController.oSubTitleBar.updateLabel(String(Inventory.coins));
				
				if (itemVO.LEVELABLE)
				{
					itemVO.SKILL_VO.CURRENT_LEVEL++;
					core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_UPGRADE, itemVO.SKILL_VO.REF_NAME, itemVO.SKILL_VO.CURRENT_LEVEL)
				}
				else
				{
					var fashionItemCount:int = 0;
					for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
					{
						if (ShopItemVO (Inventory.arrShopItems[i]).LEVELABLE == false && ShopItemVO(Inventory.arrShopItems[i]).IS_DEFAULT_ITEM == false)
						fashionItemCount ++;
					}
					if(fashionItemCount > 0)
					core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_FASHION, null, fashionItemCount)
				
				}
				//if equip after purchase flagged
				if (equipItem)
				{
					core.controlBus.inventoryController.equipItem(itemVO, null);
				}
				
			}
			else{
			itemVO.PURCHASED = false;
			}
			
			
			//Services.savePlayerData.execute(false);
			
			if (callback != null)
			callback(itemVO)
		}
		
		
		
		//================================================o
		//------ Retrieve a VO from master list based on search 
		//================================================o		
		public function findVO(refName:String, level:String = null):ShopItemVO 
		{
			var itemVO:ShopItemVO 
			loop: for (var i:int = 0; i < _arrReadOnlyItemsList.length; i++) 
			{
				itemVO = ShopItemVO(_arrReadOnlyItemsList[i])
				
				if (itemVO.REF == refName && itemVO.LEVEL == level)
				break loop;
				
			}
			return itemVO;
		}
		
		//=============================================o
		//-- reset all items  (logout/new user)
		//=============================================o	
		public function resetAll():void
		{
			var itemVO:ShopItemVO 
			loop: for (var i:int = 0; i < _arrReadOnlyItemsList.length; i++) 
			{
				itemVO = ShopItemVO(_arrReadOnlyItemsList[i])
				if (!itemVO.IS_DEFAULT_ITEM)
				{
				itemVO.PURCHASED = false;
				itemVO.EQUIPPED = false;
				PlayerData.arrPurchasedItems.splice(i, 1)
				}
/*				else
				{
				itemVO.PURCHASED = true;
				itemVO.EQUIPPED = true;	
				}*/
			}

			PlayerData.arrPurchasedItems.length = 0;
			PlayerData.arrPurchasedItems = [];
			

			
			trace(this + " has been reset ");
		}
		

		//================================================o
		//------ Getters and Setters
		//================================================o			
		public function get arrShopItems():Array 
		{
			return _arrShopItems;
		}
		
		public function set arrShopItems(value:Array):void 
		{
			_arrShopItems = value;
		}

		

		
	}

}