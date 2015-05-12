package pl.net 
{
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.LPSettings;
	import flash.events.EventDispatcher;
	import flash.net.sendToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import eu.alebianco.air.extensions.analytics.Analytics;
	import eu.alebianco.air.extensions.analytics.api.ITracker;
	import eu.alebianco.air.extensions.analytics.api.IViewBuilder;
	import eu.alebianco.air.extensions.analytics.api.IExceptionBuilder;
	import eu.alebianco.air.extensions.analytics.api.ISocialBuilder;
	import eu.alebianco.air.extensions.analytics.api.IEventBuilder;
	import eu.alebianco.air.extensions.analytics.api.ITracker;
	
	/**
	 * Enables Google Analytics tracking of a LaunchPad project, if the tracking id has been set up in the project config.xml and with the Google service.
	 * @author Ben Leffler
	 */
	
	public class Analytics2 extends EventDispatcher
	{
		private static var _analytics:eu.alebianco.air.extensions.analytics.Analytics;
		private static var _tracker:ITracker;
		
		/**
		 * Reports to Google Analytics that a user has viewed a specific screen
		 * @param	screen_name	The name of the screen to report back to GA
		 * @return	A boolean value to indicate if the call was successfully made
		 */
		
		public static function trackScreen( screen_name:String ):Boolean
		{
			if ( !screen_name || !screen_name.length )
			{
				trace( "LaunchPad", Analytics, "Call to trackScreen failed as a the screen_name was passed as an empty or nulled string" )
				return false;
			}
			
			var event:IViewBuilder = _tracker.buildView(screen_name);
			
			event.track();
			
			trace( "LaunchPad", Analytics, "Analytics screen event tracked: '" + screen_name + "'" );
			
			return true;
			
		}
		
		/**
		 * Reports a caught exception to Google Analytics
		 * @param	error	The error thrown by your app that needs reporting
		 * @return	A boolean value that indicates if the call was made successfully
		 */
		
		public static function trackException( error:Error ):Boolean
		{
			
			var event:IExceptionBuilder = _tracker.buildException(false);
			
			event.withDescription(error.message + "("+error.errorID+")");
			
			event.track();
			
			trace( "LaunchPad", Analytics, "Analytics exception event tracked: '" + error.message + "'" );
			
			return true;
			
		}
		
		/**
		 * Reports to Google Analytics that a social media interaction has been initiated from your app
		 * @param	network	The name of the social media service (eg. "facebook", "twitter", "linkedin" etc)
		 * @param	action	The type of social media interaction that occured. (eg. "postToWall", "like", "invite")
		 * @param	target	(DEPRECATED) The target url or target specific information contained within the interaction
		 * @return	A boolean value that indicates if the call was made successfully
		 */
		
		public static function trackSocialMedia( network:String = "facebook", action:String = "postToWall", target:String = "" ):Boolean
		{
			if ( !network || !network.length )
			{
				trace( "LaunchPad", Analytics, "Call to trackSocialMedia failed as a the network was passed as an empty or nulled string" )
				return false;
			}
			
			if ( !action || !action.length )
			{
				trace( "LaunchPad", Analytics, "Call to trackSocialMedia failed as a the action was passed as an empty or nulled string" )
				return false;
			}
			
			if ( target != "" )
			{
				trace( "LaunchPad", Analytics, "WARNING: target is deprecated for trackSocialMedia" )
				return false;
			}
			
			var event:ISocialBuilder = _tracker.buildSocial(network, action);
			
			event.track();
			
			trace( "LaunchPad", Analytics, "Analytics social event tracked: '" + network + "' : '" + action + "'" );
			
			return true;
			
		}
		
		/**
		 * Reports to Google Analytics that an event has occured. Handy for tracking in-app stats.
		 * @param	category	The category of the event. Best used to pass through the platform (eg. "AppIOS", "AppAndroid", "AppWeb" etc.)
		 * @param	action	The name of the event that has occured (eg. "GameLoaded", "ScoreSubmitted" etc.)
		 * @param	label	If a value is to be associated, this is the label to use for it (eg. "QuizQuestionAnsweredCorrect" )
		 * @param	value	The value of the label. (eg 1). GA increments source values by this value amount
		 * @return	A boolean value that indicates if the call was made successfully
		 */
		
		public static function trackEvent( category:String, action:String, label:String = "", value:Number = 0 ):Boolean
		{
			category = "";
			if ( !category || !category.length )
			{
				trace( "LaunchPad", Analytics, "Call to trackEvent failed as a the category was passed as an empty or nulled string" )
				return false;
			}
			
			if ( !action || !action.length )
			{
				trace( "LaunchPad", Analytics, "Call to trackEvent failed as a the action was passed as an empty or nulled string" )
				return false;
				
			}
			
			var event:IEventBuilder = _tracker.buildEvent(label, action);
			
/*			if ( label.length > 0 )
			{
				event.withLabel(label);
			}
			
			if ( value )
			{
				event.withValue(value);
			}*/
			
			
			event.track();
			
			trace( "LaunchPad", Analytics, "Analytics event tracked: '" + action + "'" );
			
			return true;
			
		}
		
		/**
		 * Sends a message to Google Analytics that the user's session has ended. This call is not necessary, as GA makes a calculated guess as to when a user session
		 * ends based on inactivity. But for more accurate tracking, this can be called when the app has been terminated or a user has logged off within the app.
		 * @deprecated
		 */
		
		public static function trackEndSession():void
		{
			trace( "LaunchPad", Analytics, "WARNING: trackEndSession is deprecated" )
			return void;
		}
		
		/**
		 * Initializes the Analytics tracking for the app. This is called during the LaunchPad.init process at the load of an app. This call also sends a payload
		 * to GA to flag a session start.
		 */
		
		public static function init():void
		{
			trace( "LaunchPad", Analytics, "Initializing Google Analytics with AppId:", LPSettings.ANALYTICS_TRACKING_ID );
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			trace( "===============================================================");
			if (!eu.alebianco.air.extensions.analytics.Analytics.isSupported()) {
				trace( "LaunchPad", Analytics, "Analytics not supported on this platform");
			}
			
			_analytics = eu.alebianco.air.extensions.analytics.Analytics.getInstance();
			_tracker = _analytics.getTracker(LPSettings.ANALYTICS_TRACKING_ID);
			
			trace( "LaunchPad"+ Analytics+ "APP VERSION:"+_tracker.appVersion);
		}
		
	}

}