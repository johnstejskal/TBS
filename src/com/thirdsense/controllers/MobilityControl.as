package com.thirdsense.controllers 
{
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.Profiles;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	/**
	 * Utility set to allow specific functions within a Mobile environment (such as smart phone and tablet)
	 * @author Ben Leffler
	 */
	
	public class MobilityControl 
	{
		private static var _has_focus:Boolean = true;
		private static var onActive:Function;
		private static var onDeactive:Function;
		private static var keep_awake:Boolean = false;
		private static var onBackButton:Function;
		private static var fps:int;
		private static var gc_timer:uint;
		
		/**
		 * Does the mobile device currently have focus? False is returned if the app is running in the background.
		 */
		
		public static function get has_focus():Boolean
		{
			return _has_focus;
		}
		
		public function MobilityControl() 
		{
			
		}
		
		/**
		 * Enables the iPhone/iPad mute button to mute the app.
		 */
		public static function initAudioMode():void
		{
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
		}
		
		/**
		 * Set the app to exit completely if focus is lost (Compatible only with Android)
		 * @param	enabled	Set to true if the app is to shut down on loss of focus. Set to false if it is to remain operating in the background.
		 */
		
		public static function exitIfInactive( enabled:Boolean=true ):void
		{
			if ( Capabilities.manufacturer.toLowerCase().indexOf("ios") < 0 ) {
				if ( enabled )
				{
					killActivationControl();
					NativeApplication.nativeApplication.autoExit = true;
					initActivationControl( null, exitApplication );
				}
				else
				{
					killActivationControl();
					NativeApplication.nativeApplication.autoExit = false;
					initActivationControl();
				}
			}
			
		}
		
		/**
		 * Removes any activate control listeners and returns the device to the default state
		 */
		
		public static function killActivationControl():void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, MobilityControl.activationHandler);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, MobilityControl.activationHandler);
		}
		
		/**
		 * Handles the activation process for the device if it loses or regains focus (Android only)
		 * @param	onActivate	Function to call upon the app regaining focus
		 * @param	onDeactivate	Function to call upon the app losing focus
		 */
		public static function initActivationControl( onActivate:Function=null, onDeactivate:Function=null ):void
		{
			if ( Capabilities.cpuArchitecture != "x86" ) {
				
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, MobilityControl.activationHandler, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, MobilityControl.activationHandler, false, 0, true);
				
				if ( onActivate != null ) {
					MobilityControl.fps = LaunchPad.instance.nativeStage.frameRate;
				}
				
				MobilityControl.onActive = onActivate;
				MobilityControl.onDeactive = onDeactivate;
				
			}
			
		}
		
		/**
		 * Prevents the device from entering a sleep state. (Android requires the KEEP_AWAKE permission to be enabled to use this feature)
		 */
		
		public static function preventFromSleep():void
		{
			if ( Profiles.mobile ) {
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
				keep_awake = true;
			}
			
		}
		
		/**
		 * Allows the device to enter a sleep state if no interaction is detected for a user-determined amount of time
		 * @param	save_state	Retains the allow sleep state in memory until overriden.
		 */
		
		public static function allowSleep( save_state:Boolean = true ):void
		{
			if ( Profiles.mobile ) {
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
				if ( save_state ) {
					keep_awake = false;
				}
			}
			
		}
		
		/**
		 * @private
		 */
		
		private static function activationHandler(evt:Event):void
		{
			if ( evt.type == Event.ACTIVATE ) {
				
				_has_focus = true;
				
				if ( keep_awake ) {
					preventFromSleep();
				}
				
				SoundMixer.soundTransform = new SoundTransform(1);
				
				if ( onActive != null ) {
					onActive();
				}
				
			}
			
			if ( evt.type == Event.DEACTIVATE ) {
				
				_has_focus = false;
				
				allowSleep(false);
				
				SoundMixer.soundTransform = new SoundTransform(0);
				
				if ( onDeactive != null ) {
					onDeactive();
				}
			}
			
		}
		
		/**
		 * Exits the application (Android only)
		 * @param	evt	Event object to allow a listener to invoke this method
		 */
		
		public static function exitApplication( evt:Event = null ):void
		{
			trace( "exitApplication" );
			
			if ( Capabilities.manufacturer.toLowerCase().indexOf("ios") >= 0 ) {
				trace( MobilityControl, "exitApplication call failed. Not compatible with iOS devices." );
			} else {
				NativeApplication.nativeApplication.exit();
			}
			
		}
		
		/**
		 * Starts a routine garbage collection every 5 seconds
		 */
		public static function initTimedGarbageCollect():void
		{
			gc_timer = setTimeout( garbageCollect, 5000 );
			
		}
		
		/**
		 * 
		 */
		
		private static function garbageCollect():void
		{
			System.gc();
			System.gc();
			
			initTimedGarbageCollect();
		}
		
		/**
		 * Creates a listener tied to the back button press event (Android only)
		 * @param	onPress	The function to execute upon the event occuring.
		 */
		
		public static function initBackButton( onPress:Function ):void
		{
			MobilityControl.killBackButton();
			
			if ( Capabilities.manufacturer.toLowerCase().indexOf("ios") < 0 && Profiles.mobile ) {
				trace( MobilityControl, "Back Button is now handled." );
				onBackButton = onPress;
				LaunchPad.instance.nativeStage.stage.removeEventListener( KeyboardEvent.KEY_DOWN, backButtonHandler );
				LaunchPad.instance.nativeStage.stage.addEventListener( KeyboardEvent.KEY_DOWN, backButtonHandler, false, 0, true );
			} else {
				trace( MobilityControl, "Attempt to initBackButton failed - not compatible with this device type" );
			}
			
		}
		
		/**
		 * Returns the back button to it's default state (Android only)
		 */
		
		public static function killBackButton():void
		{
			LaunchPad.instance.nativeStage.stage.removeEventListener( KeyboardEvent.KEY_DOWN, backButtonHandler );
			onBackButton = null;
		}
		
		/**
		 * @private
		 */
		
		private static function backButtonHandler(evt:KeyboardEvent):void
		{
			if ( evt.keyCode == Keyboard.BACK || (LaunchPad.getValue("debug") == "true" && evt.charCode == 96) ) {
				
				evt.preventDefault();
				if ( onBackButton != null )
				{
					onBackButton();
				}
			}
		}
		
		/**
		 * Returns the back button handler that is currently in use (use for temporary override of button functions such as application ui alerts)
		 * @return	The function that is currently being called upon a back-button being pressed
		 */
		
		public static function getBackButtonHandler():Function
		{
			if ( onBackButton != null )
			{
				return onBackButton;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Obtains the version number assigned to the application within the Application Descriptor XML file
		 * @return	String representation of the application version number
		 */
		
		public static function getApplicationVersion():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			
			var xml_str:String = appDescriptor.toXMLString();
			var pos:int = xml_str.indexOf( "xmlns=" );
			var str1:String = xml_str.substr(0, pos);
			var str2:String = xml_str.substr(pos + 6);
			appDescriptor = XML( str1 + "xmlns_default=" + str2 );
			
			return String( appDescriptor.versionNumber );
		}
		
	}

}