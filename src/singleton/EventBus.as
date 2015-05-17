package singleton  {
	

	import flash.display.MovieClip;
	import flash.display.Stage;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;


	import flash.events.EventDispatcher;
	



	public class EventBus extends EventDispatcher{
		
		private static var instance: EventBus;
		private static var _privateNumber:Number = Math.random();
		
		private  var _arrSignals:Array = [];
		

		//----------------------------------------o
		//------ Signals list 
		//----------------------------------------o		

		public var sig_timeOver:Signal;
		public var sig_playerDie:Signal;
		public var sigPlayClicked:Signal;
		public var sigOnBackClicked:Signal;
		public var sigOnDeactivate:Signal;
		public var sigOnDeviceActivate:Signal;
		public var sigStarlingStageReady:Signal;
		public var sig_playScreenTrashed:Signal;
		public var sigScreenChangeRequested:Signal;
		public var sigSlideMenuAction:Signal;
		public var sigBackButtonClicked:Signal;
		
		public var sigInfoSubScreenChange:Signal;
		public var sigLeaderSubScreenChange:Signal;
		public var sigCompSubScreenChange:Signal;
		
		public var sigWinPanelPressed:Signal;
		public var sigSubScreenChangeRequested:Signal;
		
		public var sigShopItemSelected:Signal;
	
		
		//Shop Action Events
		public var sigPurchaseItem:Signal;
		public var sigEquipItem:Signal;
		public var sigUnequipItem:Signal;
		public var sigTogglePause:Signal;
		public var sigRestartGame:Signal;
		public var sigTutorialFinished:Signal;
		public var sigOnOreClicked:Signal;
		public var sigOnOreMineSuccess:Signal;
		public var sigOnOreMineFailed:Signal;
		public var sigOnPickAxeBroken:Signal;

		

		
		
		
		
		
		
		

		//----------------------------------------o
		//------ Singleton declaration
		//----------------------------------------o		
		public function EventBus(num:Number=NaN) {
			if(num !== _privateNumber){
				throw new Error("An instance of Singleton already exists. Try EventBus.getInstance()");
			}
			
			_arrSignals = new Array();
			
		}
		
		public static function getInstance() : EventBus {
			if ( instance == null ) instance = new EventBus(_privateNumber);
			return instance as EventBus;
		} 

	}	
}
