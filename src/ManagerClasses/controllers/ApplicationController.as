package ManagerClasses.controllers 
{
	import com.johnstejskal.DateUtil;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.data.LPLocalData;

	import singleton.Core;
	import staticData.AppData;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.LeaderboardData;
	import staticData.dataObjects.PlayerData;

	import staticData.dataObjects.ShopData;
	import staticData.Inventory;
	import staticData.LocalData;
	import staticData.settings.DeviceSettings;
	import staticData.SharedObjectKeys;
	import staticData.valueObjects.AchievementVO;
	import staticData.valueObjects.ShopItemVO;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ApplicationController 
	{
		
		
		private static var _core:Core = Core.getInstance();
		
		public function ApplicationController() 
		{
			
		}
		

		/**
		 * Saves the game state to local data and returns the save game object for backend saving if desired
		 * @return	The save game object
		 */
		
		public static function createPlayerDataObject():Object
		{
/*			var date:Date = new Date();
			var _timeStamp:String = date.toString();
			
			var player:Object =
			{
				timeStamp:_timeStamp,
				facebook_ids:PlayerData.facebook_ids,
				coins:Inventory.coins,
				timesBeatThreshold:PlayerData.timesBeatThreshold,
				timesShared:PlayerData.timesShared,
				prizesClaimed:PlayerData.prizesClaimed,
				consecutiveLogins:PlayerData.consecutiveLogins,
				lastLoginDate:PlayerData.lastLoginDate,
				steakSuitUnlocked:PlayerData.steakSuitUnlocked,
				hasAgreedAppTerms_1:PlayerData.hasAgreedAppTerms_1,
				hasRated:PlayerData.hasRated,
				hasSeenVersionNotes_1:PlayerData.hasSeenVersionNotes_1,
				ownedItems:	
				getOwnedItems(),
				achievements:
				getAchievements()
			}
			
			trace( "Saving game to local data" );
			SharedObjects.setProperty("save_game_json", JSON.stringify(player));
			
			return player;
			*/
			
			return new Object();
		}
		
		
		//=============================================o
		//-- Create object packet for server froma array
		//=============================================o	
		public static function getOwnedItems():Object 
		{
/*			var obj:Object = new Object();
			var lng:int = Inventory.arrShopItems.length;
		
			for (var i:int = 0; i < lng; i++) 
			{
				obj["item" + i] = { }
				obj["item" + i]["id"] = ShopItemVO(Inventory.arrShopItems[i]).ID;
				obj["item" + i]["equipped"] = ShopItemVO(Inventory.arrShopItems[i]).EQUIPPED;

			}
			
			return obj;*/
			return new Object();
		}	
		
		//=============================================o
		//-- Create object packet for server froma array
		//=============================================o	
		public static function getAchievements():Object 
		{
			
			trace(ApplicationController + "getAchievements()");
/*			var obj:Object = new Object();
			var lng:int = _core.controlBus.achievementController.arrAchievementsCompleted.length
			for (var i:int = 0; i < lng; i++) 
			{
				//obj[i] = _core.controlBus.achievementController.arrAchievementsCompleted[i];
				obj = _core.controlBus.achievementController.arrAchievementsCompleted;
				
			}
			
			return obj;*/
			return new Object();
		}	
		
		static public function restorePlayerData(callback:Function = null):void 
		{
				trace(ApplicationController+"restorePlayerData()")
				
/*				PlayerData.playerDataObj = JSON.parse(LocalData.playerDataObj);
				
				//------------------- restore player progress
				Inventory.coins = PlayerData.playerDataObj.coins;

				PlayerData.prizesClaimed = PlayerData.playerDataObj.prizesClaimed;
				PlayerData.timesBeatThreshold = PlayerData.playerDataObj.timesBeatThreshold;
				
				PlayerData.timesShared = PlayerData.playerDataObj.timesShared;
				
				var friendsIds:Array = PlayerData.playerDataObj.facebook_ids;
				
				if(PlayerData.facebook_ids.length == 0)
				PlayerData.facebook_ids = friendsIds;
				
				PlayerData.consecutiveLogins = PlayerData.playerDataObj.consecutiveLogins;
				PlayerData.lastLoginDate = PlayerData.playerDataObj.lastLoginDate;
				
				PlayerData.steakSuitUnlocked = PlayerData.playerDataObj.steakSuitUnlocked;
				PlayerData.hasAgreedAppTerms_1 = PlayerData.playerDataObj.hasAgreedAppTerms_1;
				PlayerData.hasRated = PlayerData.playerDataObj.hasRated;
				PlayerData.hasSeenVersionNotes_1 = PlayerData.playerDataObj.hasSeenVersionNotes_1;

				//------------------- restore Player purchases
				if(PlayerData.playerDataObj.ownedItems != null)
				PlayerData.objPurchasedItems = PlayerData.playerDataObj.ownedItems;
				else
				PlayerData.objPurchasedItems = { };
				
				
				//------------------- add object into Data 
				for (var i:String in PlayerData.objPurchasedItems)
				{
					var item:ShopItemVO = new ShopItemVO();
					item.ID = PlayerData.objPurchasedItems[i].id;
					item.EQUIPPED = PlayerData.objPurchasedItems[i].equipped;

					if(PlayerData.arrPurchasedItems.indexOf(item) == -1)
					PlayerData.arrPurchasedItems.push(item);
				}
				
				// unequip all items and request items from shop
				_core.controlBus.shopItemController.updatePurchasedAfterLoad();
				
				//------------------ restore Player Achievements
				if(PlayerData.playerDataObj.achievements != null)
				PlayerData.objAchievements = PlayerData.playerDataObj.achievements;
				else
				PlayerData.objAchievements = { };
				
				//add object into Data 
				for (var j:String in PlayerData.objAchievements)
				{
					var achievementID:String = PlayerData.objAchievements[j];
					PlayerData.arrAchievements.push(achievementID);
				}
				
				_core.controlBus.achievementController.restoreAchievements();	
				
				
				if (SharedObjects.getProperty(SharedObjectKeys.FACE_BOOK_FRIENDS) != null)
				PlayerData.facebook_ids = SharedObjects.getProperty(SharedObjectKeys.FACE_BOOK_FRIENDS);
				
				checkDaysLoggedIn();
				
				
				if (callback != null)
				callback();*/
		}
		
		
		//============================================o
		//-- Reset all Player and application Data
		//============================================o
		static public function reset():void 
		{
			
/*			SharedObjects.deleteAll();
			PlayerData.reset();
			AppData.reset();
			
			//RegistrationFormData.reset();
			//ProfileUpdateFormData.reset();
			LeaderboardData.reset();
			LocalData.reset();
			DeviceSettings.isVibrationMuted = false;
			
			_core.controlBus.achievementController.resetAll();
			_core.controlBus.prizeController.resetAll();
			_core.controlBus.powerupController.resetAll();
			
			_core.controlBus.inventoryController.resetAll();
			_core.controlBus.shopItemController.resetAll();
			*/
		}
		
		static public function checkDaysLoggedIn():void 
		{

/*				trace(ApplicationController + "checkDaysLoggedIn()");
				//===================================o
				// Check consecutive logins for login achievement
				var currDaysLoggedIn:int = PlayerData.consecutiveLogins;
				var lastLoginDate:Date = new Date();
				var currDate:Date = new Date(); 

				//if player is a new user, first login
				if (currDaysLoggedIn == 0)
				{
					currDaysLoggedIn ++;
					PlayerData.lastLoginDate = currDate.toDateString();
				}
				//user has at least 1 login day
				else
				{
					
					if (PlayerData.lastLoginDate != null)
					{
						lastLoginDate = DateUtil.parseDateTimeString(PlayerData.lastLoginDate);
						PlayerData.lastLoginDate = lastLoginDate.toDateString();
						
						var daysSinceLastLogin:int = DateUtil.getDaysBetweenDates(lastLoginDate, currDate)
						trace("daysSinceLastLogin:"+daysSinceLastLogin);

						if (daysSinceLastLogin > 0)
						{
							if (daysSinceLastLogin == 1)
							{
								currDaysLoggedIn ++;
							}
							else if (daysSinceLastLogin > 1)
							{
								currDaysLoggedIn = 1;
							}
						}
					}
					else
					{
						PlayerData.lastLoginDate = lastLoginDate.toDateString();
						currDaysLoggedIn = 1;	
					}
					
				}
				PlayerData.lastLoginDate = currDate.toDateString();
				PlayerData.consecutiveLogins = currDaysLoggedIn;
				_core.controlBus.achievementController.checkAchievement(AchievementData.ACTION_LOGIN, null, PlayerData.consecutiveLogins);
				*/
				

				// Login Check End
				//=================================o
		}
		
		


		
		
	}

}