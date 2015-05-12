package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;
	import staticData.AppData;
	import staticData.dataObjects.PlayerData;
	import staticData.settings.PublicSettings;

	/**
	 * ...
	 * @author 
	 */
	public class DSpriteSheet_action 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "action";
		static public var _onComplete:Function;
		static public var arrUpgrades:Array = [MC_car0, MC_car1, MC_car2, MC_car3, MC_car4, MC_car5, MC_car6, MC_car7, MC_car8, MC_car9, MC_car10, MC_car11];
		
		public function DSpriteSheet_action() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			_onComplete = complete;
			trace(DSpriteSheet_action + "init()");
			dtm = new DMTBasic(ref, false);
				
			var carCl:Class = arrUpgrades[PlayerData.carUpgradeLevel];
			var car:* = new carCl();
			car.scaleX = car.scaleY = AppData.offsetScaleX;			
																								
			var coin:MC_coin = new MC_coin();
			coin.scaleX = coin.scaleY = AppData.offsetScaleX;	
																								
			var smokeTrail:MC_smokeTrail = new MC_smokeTrail();
			smokeTrail.scaleX = smokeTrail.scaleY = AppData.offsetScaleX;	
																											
			var ditchLong:MC_ditchLong = new MC_ditchLong();
			ditchLong.scaleX = ditchLong.scaleY = AppData.offsetScaleX;	
																														
			var ditchShort:MC_ditchShort = new MC_ditchShort();
			ditchShort.scaleX = ditchShort.scaleY = AppData.offsetScaleX;	
																														
			var point:CornerPoint = new CornerPoint();
			point.scaleX = point.scaleY = AppData.offsetScaleX;	
			
			var potHole:MC_pothole = new MC_pothole();
			potHole.scaleX = potHole.scaleY = AppData.offsetScaleX;	
						
			var oilSpill:MC_oilSpill = new MC_oilSpill();
			oilSpill.scaleX = oilSpill.scaleY = AppData.offsetScaleX;	
						
			var speedHump:MC_speedHump = new MC_speedHump();
			speedHump.scaleX = speedHump.scaleY = AppData.offsetScaleX;	
						
			var magnet:MC_magnet = new MC_magnet();
			magnet.scaleX = magnet.scaleY = AppData.offsetScaleX;	
									
			var nitro:MC_nitro = new MC_nitro();
			nitro.scaleX = nitro.scaleY = AppData.offsetScaleX;	
																					
			var nitroFlame:MC_nitroFlame = new MC_nitroFlame();
			nitroFlame.scaleX = nitroFlame.scaleY = AppData.offsetScaleX;	
												
			var coinStack:MC_coinStack = new MC_coinStack();
			coinStack.scaleX = coinStack.scaleY = AppData.offsetScaleX;	
																	
			var carShadowRoad:MC_carShadowRoad = new MC_carShadowRoad();
			carShadowRoad.scaleX = carShadowRoad.scaleY = AppData.offsetScaleX;	
																	
			var carShadowAir:MC_carShadowAir = new MC_carShadowAir();
			carShadowAir.scaleX = carShadowAir.scaleY = AppData.offsetScaleX;	
						
			dtm.addItemToRaster(carShadowRoad, "carShadowRoad");
			dtm.addItemToRaster(carShadowAir, "carShadowAir");
			dtm.addItemToRaster(nitroFlame, "nitroFlame");
			dtm.addItemToRaster(coinStack, "coinStack");
			dtm.addItemToRaster(nitro, "nitro");
			dtm.addItemToRaster(magnet, "magnet");
			dtm.addItemToRaster(ditchShort, "ditchShort");
			dtm.addItemToRaster(speedHump, "speedHump");
			dtm.addItemToRaster(oilSpill, "oilSlick");
			dtm.addItemToRaster(potHole, "potHole");
			dtm.addItemToRaster(point, "point");
			dtm.addItemToRaster(ditchLong, "ditchLong");
			dtm.addItemToRaster(smokeTrail, "smokeTrail");
			dtm.addItemToRaster(coin, "coin");
			dtm.addItemToRaster(car, "car");

			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process( true, 1, PublicSettings.FLASH_IDE_COMPILE);	
			

		}
		
		static private function onProcessComplete(e:Event):void 
		{
			dtm.removeEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			
			if (_onComplete != null)
			_onComplete();
		}
		
		
		public static function trash():void
		{
			if (dtm != null)
			{
				dtm.dispose();
				dtm = null;
			}
		}

		
	}

}