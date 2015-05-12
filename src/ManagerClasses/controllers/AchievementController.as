package ManagerClasses.controllers 
{
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.Maths;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ManagerClasses.StateMachine;
	import ManagerClasses.supers.SuperController;
	import singleton.Core;
	import starling.display.Sprite;
	import staticData.AppData;
	import staticData.dataObjects.AchievementData;
	import staticData.dataObjects.PlayerData;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.Sounds;
	import staticData.valueObjects.achievement.Achievement1VO;
	import staticData.valueObjects.achievement.Achievement2VO;
	import staticData.valueObjects.achievement.Achievement3VO;
	import staticData.valueObjects.achievement.Achievement4VO;
	import staticData.valueObjects.achievement.Achievement5VO;
	import staticData.valueObjects.achievement.Achievement6VO;
	import staticData.valueObjects.achievement.Achievement7VO;
	import staticData.valueObjects.achievement.Achievement8VO;
	import staticData.valueObjects.AchievementVO;
	import staticData.XMLData;
	import treefortress.sound.SoundAS;
	import view.components.screens.HomeScreen;

	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class AchievementController extends SuperController
	{
		
		//TODO pull thesevalues from and XML/VO later
		static public const ACHIEVEMENT_1:String = "Collect 100 coins";
		static public const ACHIEVEMENT_2:String = "Collect 1000 coins";
		static public const ACHIEVEMENT_3:String = "Collect 10000 coins";
		static public const ACHIEVEMENT_4:String = "login 5 days in a row";
		static public const ACHIEVEMENT_5:String = "login 5 days in a row";

		
		
		private var _hudLayer:Sprite;
		

		private var _currentVO:Class;
		private var _panelDelay:int;
		private var _panelSlideOutPos:Number;

		private var _arrAchievements:Array;
		private var _arrAchievementsCompleted:Array;
		
		//===============================================o
		//-- Construct
		//===============================================o			
		public function AchievementController() 
		{
			_panelDelay = PublicSettings.ACHIEVEMENT_PANEL_TIME;
			
		}
		
		//===============================================o
		//-- init
		//===============================================o
		public function init():void
		{
			trace(this + "inited");
			AchievementData.objAchievementsMasterList = JSON.parse(new XMLData["AchievementList_AU"]());
			
			for ( var i:String in AchievementData.objAchievementsMasterList)
			{
				var obj:Object = AchievementData.objAchievementsMasterList[i];
				var item:AchievementVO = new AchievementVO();
				item.id = obj.ID;
				item.name = obj.NAME;
				item.description = obj.DESCRIPTION;
				item.action = obj.ACTION;
				item.type = obj.TYPE;
				item.quantity = obj.QUANTITY;
				item.award = obj.AWARD;
				AchievementData.arrAchievementMasterList.push(item);
			}
			
			_arrAchievements = AchievementData.arrAchievementMasterList;

			_arrAchievementsCompleted = new Array();
		}
		
		//===============================================o
		//-- Restore Achievements from server
		//===============================================o
		public function restoreAchievements():void
		{
			trace(this + "restoreAchievements()");
			
			for (var i:int = 0; i < _arrAchievements.length; i++) 
			{
				for (var j:int = 0; j < PlayerData.arrAchievements.length; j++) 
				{
					if (_arrAchievements[i].id == PlayerData.arrAchievements[j])
					{
						if (_arrAchievementsCompleted.indexOf(_arrAchievements[i].id) == -1)
						{
						_arrAchievementsCompleted.push(_arrAchievements[i].id)
						_arrAchievements[i].completed = true;
						}
					
					}
				}
				
			}
			
		}
		

		
		//=========================================================o
		//-- complete achievement
		//=========================================================o
		private function completeAchievement(vo:AchievementVO):void 
		{	
			_arrAchievementsCompleted.push(vo.id)
			core.controlBus.appUIController.showAchievementPanel(vo)
		}

		//=========================================================o
		//-- Reset all acheievements (new user/logged out)
		//=========================================================o		
		public function resetAll():void
		{
			var lngth:int = _arrAchievements.length;
			
			for (var i:int = 0; i < lngth ; i++) 
			{
				AchievementVO( _arrAchievements[i]).completed = false;
			}
			
			_arrAchievementsCompleted.length = 0;
			_arrAchievementsCompleted = [];
			trace(this + " has been reset ");
		}
		
		public function checkAchievement(action:String, type:Object, quantity:int):void 
		{
			trace(this + "checkAchievement()action:" + action + " | quantity:" + quantity);
			
			//if (UserServiceStatus.currentState == UserServiceStatus.STATE_LOGGED_OUT)
			//return;
			
			var lngth:int = _arrAchievements.length;
			
			var item:AchievementVO;
			var arrCompleted:Array = new Array(); //used for some achievements where more than one level of completion has been obtained
			var toAward:Boolean = false;
			loop: for (var i:int = 0; i < lngth; i++) 
			{
				
				item = AchievementVO(_arrAchievements[i]);
				
				if (!item.completed)
				{
					if (item.action == action)
					{
						
						if(action == AchievementData.ACTION_FALL)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}
						else if(action == AchievementData.ACTION_COIN)
						{
							if (quantity >= item.quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
								
							}
					
						}
						else if(action == AchievementData.ACTION_POWER_UP)
						{
							
							if (item.type == type)
							{
								if (quantity == item.quantity && !item.completed)
								{
									item.completed = true;
									arrCompleted.push(item);
									toAward = true;
									_arrAchievementsCompleted.push(item.id)
									break loop;
								}
							}
					
						}						
						else if(action == AchievementData.ACTION_UPGRADE)
						{
							if (item.type == type)
							{
								if (quantity == item.quantity && !item.completed)
								{
									item.completed = true;
									arrCompleted.push(item);
									toAward = true;
									_arrAchievementsCompleted.push(item.id)
									break loop;
								}
							}
					
						}
						else if(action == AchievementData.ACTION_THRESHOLD)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}							
						else if(action == AchievementData.ACTION_SHARED)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}							
						else if(action == AchievementData.ACTION_PRIZE_CLAIMED)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}							
						else if(action == AchievementData.ACTION_FASHION)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}							
						else if(action == AchievementData.ACTION_LOGIN)
						{
							if (item.quantity == quantity && !item.completed)
							{
								item.completed = true;
								arrCompleted.push(item);
								toAward = true;
								_arrAchievementsCompleted.push(item.id)
								break loop;
							}
					
						}	
						
					}
				}
				
			}
			
			
			
			if (item.award > 0 && toAward == true) {

				Inventory.coins += item.award;
				SoundAS.playFx(Sounds.SFX_COIN_DROP, 1);	
			}
			
			if (arrCompleted.length == 1)
			core.controlBus.appUIController.showAchievementPanel(arrCompleted[0]);
			else if (arrCompleted.length > 1)
			core.controlBus.appUIController.showAchievementPanel(arrCompleted[arrCompleted.length - 1]);
			
		}

		//============================================o
		//------  GETTERS AND SETTERS
		//============================================o				
		public function get arrAchievements():Array 
		{
			return _arrAchievements;
		}
		
		public function set arrAchievements(value:Array):void 
		{
			_arrAchievements = value;
		}
		
		public function get arrAchievementsCompleted():Array 
		{
			return _arrAchievementsCompleted;
		}
		
		public function set arrAchievementsCompleted(value:Array):void 
		{
			_arrAchievementsCompleted = value;
		}
		

		
		

		
	}

}