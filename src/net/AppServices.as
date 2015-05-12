package net 
{
//	import com.app.controllers.ApplicationController;
	import com.thirdsense.utils.Trig;
	import ManagerClasses.controllers.ApplicationController;
	import singleton.Core;
	import staticData.dataObjects.PlayerData;
	import staticData.DeviceType;
	import staticData.Inventory;
	import staticData.valueObjects.PlayerVO;
	import staticData.valueObjects.StoreVO;
	
	/**
	 * ...
	 * @author Ben Leffler
	 */
	
	public class AppServices
	{
		private static var onResponse:Function;
		
		private static var last_save:Number = 0;
		private static var last_leaderboard:Number = 0;
		
		public static function init():void
		{
			RemoteServices.init();
		}
		
		public static function reset():void
		{
			last_save = 0;
		}
		
		//=============================================o
		//-- Register the user
		//=============================================o
		public static function register( pd:PlayerVO, onResponse:Function ):Boolean
		{
			var data:Object = {
				device_type:"ios",//DeviceType.deviceManufacturer,
				first_name:pd.firstName,
				last_name:pd.lastName,
				email:pd.email,
				facebook_id:pd.facebook_id,
				password:pd.password,
				marketing_opt_in:pd.marketing_opt_in,
				agree_tc:pd.agree_tc,
				phone:pd.phone,
				postcode:pd.postcode
				
			}
			
			return RemoteServices.instance.executeCall( "register", data, onResponse );			
		}
		
		//=============================================o
		//-- update the user details
		//=============================================o
		public static function update( pd:PlayerVO, onResponse:Function ):Boolean
		{
			var data:Object = {
				hash:PlayerData.hash,
				id:PlayerData.player_id,
				device_type:"ios", //TODO, take out of api
				first_name:pd.firstName,
				last_name:pd.lastName,
				email:pd.email,
				password:pd.password,
				marketing_opt_in:pd.marketing_opt_in,
				agree_tc:pd.agree_tc,
				phone:pd.phone,
				postcode:pd.postcode
			}
			
			if (pd.facebook_id != null)
			data.facebook_id = pd.facebook_id
			
			return RemoteServices.instance.executeCall( "update", data, onResponse );
		}

		public static function getScoreThreshold(onResponse:Function):Boolean
		{
			return RemoteServices.instance.executeCall( "getScoreThreshold", null, onResponse );
		}
				
		
		public static function retrievePassword( email:String, onResponse:Function ):Boolean
		{
			var data:Object = {
				email:email
			}
			
			return RemoteServices.instance.executeCall( "forgot_password", data, onResponse );
		}
		
		public static function getProfile( player_id:int, onResponse:Function ):Boolean
		{
			var data:Object = {
				id:player_id
			}
			
			return RemoteServices.instance.executeCall( "profile", data, onResponse );
		}
		
		
		public static function loadGameState( player_id:int, onResponse:Function ):Boolean
		{
			var data:Object = {
				id:player_id,
				hash:PlayerData.hash
			}
			
			return RemoteServices.instance.executeCall( "loadPlayerData", data, onResponse, false );
			//return RemoteServices.instance.executeCall( "loadGameState", data, onResponse, false );
		}
			
		
		public static function requestPrize(onResponse:Function ):Boolean
		{
			var data:Object = {
				id:PlayerData.player_id,
				hash:PlayerData.hash
			}
			return RemoteServices.instance.executeCall( "requestPrize", data, onResponse, false );
		}
				
		public static function redeemPrize(prizeAllocationID:String, onResponse:Function ):Boolean
		{
			var data:Object = {
				id:PlayerData.player_id,
				hash:PlayerData.hash,
				prize_allocation_id:prizeAllocationID
			}
			return RemoteServices.instance.executeCall( "redeemPrize", data, onResponse, false );
		}
			
						
		public static function resendPrize(prizeAllocationID:String, onResponse:Function ):Boolean
		{
			trace("prizeAllocationID :" + prizeAllocationID);
			var data:Object = {
				prize_allocation_id:prizeAllocationID,
				hash:PlayerData.hash,
				id:PlayerData.player_id
			}
			return RemoteServices.instance.executeCall( "resendPrize", data, onResponse, false );
		}
								
		public static function setPushToken(token:String, onResponse:Function ):Boolean
		{
			
			var data:Object = {
				token :token,
				hash:PlayerData.hash,
				id:PlayerData.player_id
			}
			return RemoteServices.instance.executeCall( "setPushToken", data, onResponse, false );
		}
			
										
		public static function checkIn(storeVO:StoreVO, onResponse:Function ):Boolean
		{
			
			var data:Object = {
				store_id :storeVO.STORE_CODE,
				distance :storeVO.DISTANCE_FROM_USER,
				hash:PlayerData.hash,
				id:PlayerData.player_id
			}
			return RemoteServices.instance.executeCall( "checkIn", data, onResponse, false );
		}
			
						
		public static function claimPrize(prizeAllocationID:String, onResponse:Function ):Boolean
		{
			var data:Object = {
				id:PlayerData.player_id,
				hash:PlayerData.hash,
				prize_allocation_id:prizeAllocationID
			}
			return RemoteServices.instance.executeCall( "claimPrize", data, onResponse, false );
		}
			
		
		public static function loadMyPrizes(page:Number, limit:Number, onResponse:Function ):Boolean
		{
			var data:Object = {
				id:PlayerData.player_id,
				page:page,
				limit:limit,
				hash:PlayerData.hash
			}
			return RemoteServices.instance.executeCall( "loadMyPrizes", data, onResponse, false );
		}
				
		public static function loadPrizeList(onResponse:Function ):Boolean
		{
			var data:Object = {
			
			}
			return RemoteServices.instance.executeCall( "loadPrizeList", data, onResponse, false );
		}
		
		
		
		public static function saveGameState( onResponse:Function = null, force:Boolean = true ):Boolean
		{
			//var game_data:Object = ApplicationController.createSaveGameObject();
			
			var time:Number = new Date().getTime();
			if ( last_save == 0 || time - last_save > 120000 || force == true )
			{
				last_save = time;
			}
			else
			{
				return false;
			}
			//ApplicationController.createSaveGameObject();
			var data:Object =
			{
				id:PlayerData.player_id,
				hash:PlayerData.hash,
				player:
				ApplicationController.createPlayerDataObject()

			}
			
			//return RemoteServices.instance.executeCall( "saveGameState", data, onResponse, false );
			return RemoteServices.instance.executeCall( "savePlayerData", data, onResponse, false );
		}
		
		
		
		public static function submitScore( score:Number, distance:Number, nugs:Number, onResponse:Function ):Boolean
		{
			trace("==================================nugs :" + nugs);
			var data:Object = 
			{
				id:PlayerData.player_id,
				hash:PlayerData.hash,
				nugs:nugs,
				score:score,
				distance:distance
			}
			
			return RemoteServices.instance.executeCall( "submitScore", data, onResponse )
		}
				
		public static function couponCode( code:String, onResponse:Function ):Boolean
		{
			var data:Object = 
			{
				id:PlayerData.player_id,
				hash:PlayerData.hash,
				code:code
			}
			
			return RemoteServices.instance.executeCall( "couponCode", data, onResponse )
		}
					
		public static function login( email:String, password:String, onResponse:Function ):Boolean
		{
			var data:Object = {
				email:email,
				password:password
			}
			
			return RemoteServices.instance.executeCall( "login", data, onResponse )
		}
				
		public static function isRegistered( facebook_id:String = null, email:String = null, onResponse:Function = null ):Boolean
		{
			var data:Object = { };
			
			if (facebook_id != null)
			data.facebook_id = facebook_id;
						
			if (email != null)
			data.email = email;
			
/*			if (facebook_id != null)
			{
				data = {
					facebook_id:facebook_id
				}
			}
			else if (email != null)
			{
				data = {
					email:email
				}	
			}*/
			
			return RemoteServices.instance.executeCall( "isRegistered", data, onResponse )
		}
		
		
		
		
		public static function leaderboard(id:String = null, hash:String = null, facebook_ids:Array = null, state:String = null, onResponse:Function = null ):Boolean
		{
			
			var time:Number = new Date().getTime();
			if ( last_leaderboard == 0 || time - last_leaderboard > 5000 )
			{
				last_leaderboard = time;
			}
			else
			{
				return false;
			}

			
			var data:Object = 
			{
				limit:20
			}
			
			if (facebook_ids != null)
			{
			var arr:Array = Trig.copyArray( facebook_ids );	
			data.facebook_ids = arr;
			}
			
			if (id != null)
			data.id = id;
			
			if (hash != null)
			data.hash = hash;
						
			if (state != null)
			data.state = state;
			
			trace(AppServices + "leaderboard(): data :" + data);
			return RemoteServices.instance.executeCall( "leaderboard", data, onResponse );
		}
		
				
		public static function getWeeklyWinners(onResponse:Function ):Boolean
		{
			var data:Object = {

			}
			
			return RemoteServices.instance.executeCall( "getWeeklyWinners", data, onResponse );
		}
			
		public static function checkStatus( onResponse:Function ):Boolean
		{
			return RemoteServices.instance.executeCall( "check_status", null, onResponse );
		}
				
		public static function getHomeStats(onResponse:Function ):Boolean
		{
			var data:Object = {
				id:PlayerData.player_id,
				hash:PlayerData.hash
			}
			
			return RemoteServices.instance.executeCall( "getHomeStats", data, onResponse );
		}
		
		public static function getNews( onResponse:Function ):Boolean
		{
			return RemoteServices.instance.executeCall( "news", null, onResponse );
		}
	}

}