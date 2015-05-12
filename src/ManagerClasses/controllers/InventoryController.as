package ManagerClasses.controllers 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import ManagerClasses.StateMachine;
	import ManagerClasses.supers.SuperController;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import staticData.AppData;
	import staticData.dataObjects.PlayerData;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.valueObjects.achievement.Achievement1VO;
	import staticData.valueObjects.achievement.Achievement2VO;
	import staticData.valueObjects.achievement.Achievement3VO;
	import staticData.valueObjects.achievement.Achievement4VO;
	import staticData.valueObjects.powerUps.CoinDoubleVO;
	import staticData.valueObjects.ShopItemVO;
	import view.components.screens.LoadingScreen;
	import view.components.ui.MenuIcon;
	import view.components.ui.SlideOutMenu;
	import view.StarlingStage;
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class InventoryController extends SuperController
	{
		
		
		//=============================================o
		//-- Constructor
		//=============================================o			
		public function InventoryController() 
		{
			trace("InventoryController constructed");
		}
		
		public function init():void
		{
			
		}
		
		//=============================================o
		//-- Add money to inventory
		//=============================================o
		public function addMoney(amount:int = 1, saveData:Boolean = false):void
		{
			Inventory.coins += amount;
			
			if (StateMachine.currentAppState == StateMachine.STATE_GAME)
			{
				//core.controlBus.gameHUDController.updateCoins();
			}
			
			//if (saveData)
			//Services.savePlayerData.execute(false, true)
		}
				
		//=============================================o
		//-- Equip an Item -  
		//=============================================o
		public function equipItem(itemVO:ShopItemVO, callback:Function = null):void
		{
			trace(this + "equipItem(" + itemVO.NAME + ")");
			
			if (itemVO.TYPE != ShopItemVO.TYPE_FASHION)
			unequipAll(itemVO.REF);
			else
			unequipAll(null, ShopItemVO.TYPE_FASHION);
			
			//unequip all owned items first
			itemVO.EQUIPPED = true;
			
			//Services.savePlayerData.execute(false);
			
			if(callback != null)
			callback(itemVO);
			
		}
		
		//=============================================o
		//-- Unequip an Item -  
		//=============================================o		
		public function unequipItem(itemVO:ShopItemVO, callback:Function = null):void
		{
			trace(this + "unequipItem(" + itemVO.NAME + ")");
			
			if (itemVO.TYPE != ShopItemVO.TYPE_FASHION)
			{
			itemVO.EQUIPPED = false;
			}
			else
			{
				//if unequiping fashion, reqeuip default outfit
				for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
				{
					if(ShopItemVO(Inventory.arrShopItems[i]).IS_DEFAULT_ITEM && ShopItemVO(Inventory.arrShopItems[i]).TYPE == ShopItemVO.TYPE_FASHION)
					ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED = true;
				}
			}
			
			//Services.savePlayerData.execute(false);
			
			if(callback != null)
			callback(itemVO);
			
		}
		
		//=============================================o
		//-- Unequip all owned items
		//=============================================o		
		public function unequipAll(byRefName:String = null, byType:String = null):void
		{
			trace(this + "unequipAll(byRefName:" + byRefName + ", byType:" + byType + ")");
			var key:String;
			
			if (byRefName)
			key = byRefName;
			else if (byType)
			key = byType;
			
			for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
			{
				if (key != null)
				{
					if (ShopItemVO(Inventory.arrShopItems[i]).REF == key || 
					ShopItemVO(Inventory.arrShopItems[i]).TYPE == key)
					ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED = false;
				}
				//no key set unequip everything
				else
				{
					ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED = false;
				}
			}
			
		}
		
		
		//=============================================o
		//-- Check if item exists in inventory
		//=============================================o	
		public function checkForItem(item:ShopItemVO):Boolean 
		{
			var exists:Boolean;
			if (Inventory.arrShopItems.indexOf(item) == -1)
			exists = false;
			else
			exists = true;
			
			return exists;
		}		
		
		//=============================================o
		//-- Check if item exists in inventory by Ref
		//=============================================o	
		public function checkForItemByRef(itemRef:String):Boolean 
		{
			var exists:Boolean = false;
			
			for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
			{
				if (ShopItemVO(Inventory.arrShopItems[i]).REF == itemRef)
				exists = true;
			}
			
			return exists;
		}	
		
		//=============================================o
		//-- Check if item is equipped
		//=============================================o	
		public function checkIfItemEqiuippedByRef(itemRef:String):Boolean 
		{
			var equipped:Boolean = false;
			
			loop: for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
			{
				if (ShopItemVO(Inventory.arrShopItems[i]).REF == itemRef)
				{
					if (ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED)
					{
					equipped = true;
					break loop;
					}
				}
				
			}
			
			return equipped;
		}
		
		//=============================================o
		//-- Trash the inventory, clear all items out
		//=============================================o	
		public function trash():void
		{
			
		}
				
		//=============================================o
		//-- reset all items  (logout/new user)
		//=============================================o	
		public function resetAll():void
		{
			trace(this + "resetAll ()");
				unequipAll();
					
				var arrNewUserItems:Array = new Array();
				// reqeuip default skills
				for (var i:int = 0; i < Inventory.arrShopItems.length; i++) 
				{
					if (ShopItemVO(Inventory.arrShopItems[i]).IS_DEFAULT_ITEM)
					{
						trace("YES IS DEFAULT")
						ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED = true;
						arrNewUserItems.push(Inventory.arrShopItems[i]);
					}
					
				}
				
			Inventory.coins = PublicSettings.COIN_START_AMOUNT;
			Inventory.arrShopItems.length = 0;
			Inventory.arrShopItems = [];
			Inventory.arrShopItems = arrNewUserItems;
			trace(this + " has been reset ");
			
		}
		
		//=============================================o
		//-- Create object packet for server froma array
		//=============================================o	
		public function getInventAsPacket():Object 
		{
			var obj:Object = new Object();
			var lng:int = Inventory.arrShopItems.length;
		
			trace(this+"Inventory():"+Inventory.arrShopItems)

			for (var i:int = 0; i < lng; i++) 
			{

				obj["item" + i] = { }
				obj["item" + i]["id"] = ShopItemVO(Inventory.arrShopItems[i]).ID;
				obj["item" + i]["equipped"] = ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED;

			}
			
			return obj;
			
		}

		
	}

}