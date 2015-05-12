package net 
{
	import com.app.data.PlayerData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Ben Leffler
	 */
	
	public class LinkedInServices 
	{
		private static var instance:LinkedInServices;
		
		private const GATEWAY:String = "https://api.linkedin.com/v1/";
		private const TIMEOUT:int = 30000;
		
		private var pengin_call:Boolean = false;
		private var url_loader:URLLoader;
		private var onComplete:Function;
		private var timer:Timer;
		
		public function LinkedInServices() 
		{
			url_loader = new URLLoader();
			url_loader.dataFormat = URLLoaderDataFormat.TEXT;
			url_loader.addEventListener( Event.COMPLETE, this.responseHandler );
			url_loader.addEventListener( IOErrorEvent.IO_ERROR, this.responseHandler );
			url_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, this.responseHandler );
		}
		
		private function responseHandler(e:Event):void 
		{
			pengin_call = false;
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.responseHandler);
			
			var fn:Function = this.onComplete;
			this.onComplete = null;
			
			trace( this.url_loader.data as String );
			
			switch ( e.type )
			{
				case Event.COMPLETE:
					var data:Object = JSON.parse(this.url_loader.data);
					if ( data.errorCode == undefined )
					{
						fn( true, data );
					}
					else
					{
						fn( false, data );
					}
					break;
					
				case IOErrorEvent.IO_ERROR:
					fn ( false, { errorCode:RemoteServicesErrorCode.ERROR_IO, message:RemoteServicesErrorCode.getErrorMessage( { code:RemoteServicesErrorCode.ERROR_IO } ) } );
					break;
					
				case SecurityErrorEvent.SECURITY_ERROR:
					fn ( false, { errorCode:RemoteServicesErrorCode.ERROR_SECURITY, message:RemoteServicesErrorCode.getErrorMessage( { code:RemoteServicesErrorCode.ERROR_SECURITY } ) } );
					break;
					
				case TimerEvent.TIMER_COMPLETE:
					try
					{
						this.url_loader.close();
					}
					catch ( e:* )
					{
						//
					}
					fn ( false, { errorCode:RemoteServicesErrorCode.ERROR_REQUEST_TIMEOUT, message:RemoteServicesErrorCode.getErrorMessage( { code:RemoteServicesErrorCode.ERROR_REQUEST_TIMEOUT } ) } );
					break;
			}
		}
		
		private function executeCall( call:String, method:String = "GET", onComplete:Function = null ):Boolean
		{
			if ( this.pengin_call && onComplete != null ) return false;
			
			this.onComplete = onComplete;
			
			var url:String = GATEWAY + call + "?oauth2_access_token=" + PlayerData.getCurrent().linkedin_accessToken + "&format=json";
			var url_request:URLRequest = new URLRequest( url );
			url_request.method = method;
			
			if ( onComplete != null )
			{
				this.timer = new Timer( TIMEOUT, 1 );
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.responseHandler);
				this.timer.start();
				
				this.url_loader.load( url_request );
				pengin_call = true;
				
			}
			else
			{
				sendToURL( url_request );
			}
			
			return true;
		}
		
		private function kill():void
		{
			url_loader.removeEventListener( Event.COMPLETE, this.responseHandler );
			url_loader.removeEventListener( IOErrorEvent.IO_ERROR, this.responseHandler );
			url_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, this.responseHandler );
			try
			{
				this.url_loader.close();
			}
			catch ( e:* )
			{
				//
			}
			instance = null;
		}
		
		public static function init():void
		{
			if ( instance )
			{
				instance.kill();
			}
			
			instance = new LinkedInServices();
		}
		
		public static function getUser( onComplete:Function ):Boolean
		{
			var call:String = "people/~:(id,first-name,last-name,email-address)";
			return instance.executeCall( call, URLRequestMethod.GET, onComplete );
		}
		
		public static function getConnections( onComplete:Function ):Boolean
		{
			var call:String = "people/~/connections:(id)";
			return instance.executeCall( call, URLRequestMethod.GET, onComplete );
		}
	}

}