package ManagerClasses 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import singleton.Core;
	import singleton.EventBus;
	import staticData.DeviceType;
	import staticData.settings.PublicSettings;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class MobileSoftKeys 
	{
		
		private var _core:Core;
		private const _stage:Main = Core.getInstance().main;
		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function MobileSoftKeys() 
		{
			_core = Core.getInstance();
			
			
		}
		//----------------------------------------o
		//------ init
		//----------------------------------------o				
		public static function init():void
		{
			trace(MobileSoftKeys + "inited");
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onDeactivate); //iphone specific for home button
			
			if(PublicSettings.PLATFORM == "ANDROID")
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		static private function onKeyDown(e:KeyboardEvent):void 
		{
			
			e.preventDefault();
			if(e.keyCode == Keyboard.BACK)
			{
				trace(MobileSoftKeys+"pressed Keyboard.BACK")
				
				 if (StateMachine.currentAppState != StateMachine.STATE_HOME)
				 {
					//Core.getInstance().controlBus.appUIController.removeLoadingScreen();
					//Core.getInstance().controlBus.appUIController.removeNotification();
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_HOME);
				 } 
				 else
				 {
					NativeApplication.nativeApplication.exit();
				 }
              
			}
			else if(e.keyCode == Keyboard.HOME)
			{
				trace(MobileSoftKeys+"pressed Keyboard.HOME")
				
				NativeApplication.nativeApplication.exit();
			}
			else if(e.keyCode == Keyboard.MENU)
			{
				NativeApplication.nativeApplication.exit();
			}

		}
		
		static private function onActivate(e:Event):void 
		{
			//EventBus.getInstance().sigOnDeviceActivate.dispatch();
		}
		
		static private function onDeactivate(e:Event):void 
		{
			if(!PublicSettings.DEBUG_RELEASE)
			EventBus.getInstance().sigOnDeactivate.dispatch();
		}
		


		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o	
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o		
		
	}

}