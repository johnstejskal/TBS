package net 
{
	import com.adobe.crypto.SHA256;
	import com.adobe.utils.StringUtil;
	import com.probertson.utils.GZIPBytesEncoder;
	import com.probertson.utils.GZIPEncoder;
	import com.probertson.utils.GZIPFile;
	import com.thirdsense.LaunchPad;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	
	public class RemoteServices extends EventDispatcher 
	{
		public static var instance:RemoteServices;

		
		private var _request_timeout:int;
		private var gateway:String;
		private var timer:Timer;
		private var url_loader:URLLoader;
		private var url_request:URLRequest;
		private var _result:*;
		private var _success:Boolean;
		private var penginCall:String;
		private var onResponse:Function;
		private var _isBusy:Boolean = false;
		
		public static function init():void
		{
			instance = new RemoteServices();
		}
		
		public function RemoteServices() 
		{
			this.gateway = LaunchPad.getValue( "gateway" ) as String;
			
			this.timer = new Timer( this.request_timeout );
			this.timer.addEventListener( TimerEvent.TIMER, this.responseHandler );
			
			this.url_loader = new URLLoader();
			this.url_loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			this.url_loader.addEventListener( Event.COMPLETE, this.responseHandler );
			this.url_loader.addEventListener( IOErrorEvent.IO_ERROR, this.responseHandler );
			this.url_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, this.responseHandler );
			
			this.url_request = new URLRequest();
			this.url_request.method = URLRequestMethod.POST;
			
			this.request_timeout = 20000;
		}
		
		public function get success():Boolean
		{
			return this._success;
		}
		
		public function get result():*
		{
			return this._result;
		}
		
		public function get request_timeout():int
		{
			return this._request_timeout;
		}
		
		public function set request_timeout(val:int):void
		{
			this._request_timeout = val;
		}
		
		public function get isBusy():Boolean 
		{
			return _isBusy;
		}
		
		public function customCall( call:String, onResponse:Function = null ):Boolean
		{
			if ( this.penginCall && onResponse != null )
			{
				return false;
			}
			else
			{
				this.onResponse = onResponse;
			}
			
			if ( onResponse != null )
			{
				this.penginCall = call;
			}
			
			this.url_request.url = this.gateway + call;
			
			if ( onResponse == null )
			{
				sendToURL(this.url_request);
			}
			else
			{
				this.timer.delay = this.request_timeout;
				this.timer.start();
				this.url_loader.load( this.url_request );
			}
			
			return true;
		}
		
		public function executeCall( call:String, data:Object = null, onResponse:Function = null, useGZip:Boolean = false ):Boolean
		{
			_isBusy = true;
			
			if ( this.penginCall && onResponse != null )
			{
				return false;
			}
			else
			{
				this.onResponse = onResponse;
			}
			
			//var json:String = JSON.stringify( data );
			//data = { data:json };
			
			var myDate:Date = new Date();
			if (data == null)
			{
				data = {};
			}
			data.timestamp = Math.round(myDate.getTime());
			var json:String = JSON.stringify( data );
			var checksum:String = SHA256.hash("b4378fg43f43674326d4872364789324f23" + json + "fb323448fn43u8dfb23732rf32");
			
			json = json.substr(0,json.length-1);
			json = json.concat(",\"checksum\":\"" + checksum + "\"}");
			data = { data:json };
			
			if ( useGZip )
			{
				if ( this.url_request.requestHeaders.length == 0 )
				{
					this.url_request.requestHeaders.push(new URLRequestHeader("Accept-Encoding", "gzip"));
				}
				
				this.url_loader.dataFormat = URLLoaderDataFormat.BINARY;
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject( data );
				bytes.position = 0;
				bytes.compress( CompressionAlgorithm.DEFLATE );
				var gzip:GZIPBytesEncoder = new GZIPBytesEncoder();
				var gResult:ByteArray = gzip.compressToByteArray( bytes );
			}
			else
			{
				while ( this.url_request.requestHeaders.length >= 1 )
				{
					this.url_request.requestHeaders.pop();
				}
				
				this.url_loader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			
			var urlVars:URLVariables = new URLVariables();
			
			if ( onResponse != null )
			{
				this.penginCall = call;
			}
			
			if ( data )
			{
				if ( useGZip )
				{
					//this.url_request.data = gResult;
				}
				else if ( data is String )
				{
					this.url_request.data = data;
				}
				else
				{
					for ( var str:String in data )
					{
						urlVars[ str ] = data[ str ];
					}
					this.url_request.data = urlVars;
				}
			}
			
			this.url_request.url = this.gateway + call;
			
			
			if ( onResponse == null )
			{
				sendToURL(this.url_request);
			}
			else
			{
				this.timer.delay = this.request_timeout;
				this.timer.start();
				this.url_loader.load( this.url_request );
				
			}
			
			return true;
		}
		
		private function responseHandler( evt:Event ):void
		{
			trace("RESPONSE HANDLER");
			this.timer.stop();
			var end:Boolean = false;
			if ( !this.penginCall ) 
			{
				return void;
			}
			
			trace( evt.toString() );
			
			if ( evt.type == Event.COMPLETE )
			{
				try
				{
					trace( "DATA FORMAT TYPE:", this.url_loader.dataFormat );
					trace("RENSPONSE SERVICE CALL ==========================================================================");
					trace( "RESPONSE TO CALL:", "'" + this.penginCall + "' -\n" + this.url_loader.data );
					
					if (this.url_loader.data == "")
					{
						trace("IS EMPTY");
						this._result = { message:RemoteServicesErrorCode.getErrorMessage({code:RemoteServicesErrorCode.ERROR_IO}), code:RemoteServicesErrorCode.ERROR_IO };
						this._success = false;
						
						end = true;
						
					}
					
					
					//if gzip response
					if ( this.url_loader.dataFormat == URLLoaderDataFormat.BINARY )
					{
						//var raw_data:ByteArray = this.url_loader.data as ByteArray;
						//var encoder:GZIPEncoder = new GZIPEncoder();
						//var gzipFile:GZIPFile = encoder.parseGZIPData( raw_data );
						//var uncompressed_data:ByteArray = gzipFile.getCompressedData();
						//uncompressed_data.uncompress( CompressionAlgorithm.DEFLATE );
						//this._result = JSON.parse( uncompressed_data.toString() );
					}
					else
					{
						this._result = JSON.parse(this.url_loader.data);
					}
				}
				catch (e:*)
				{
					this._result = { code:RemoteServicesErrorCode.ERROR_MALFORMED_JSON }
				}
				
				if ( this._result is Number || (this._result.result && this._result.result.toLowerCase() == "error") )
				{
					this._success = false;
				}
				else
				{
					if(!end)
					this._success = true;
				}
				
				if (this._success)
				{
					// Check the checksum and reject if no match
					//trace("CHECKSUM: Starting Check");
					var check_result:*;
					check_result = this.url_loader.data;
					check_result = check_result.replace(",\"checksum\":\"" + this._result.checksum + "\"", "");
					//trace("CHECKSUM: String to hash = " + check_result);
					check_result = StringUtil.trim(check_result);
					var checksum:String = SHA256.hash("b4378fg43f43674326d4872364789324f23" + check_result + "fb323448fn43u8dfb23732rf32");
					
					//trace("CHECKSUM: Calculated = " + checksum);
					//trace("CHECKSUM: Expected =  " + this._result.checksum);
					//trace("CHECKSUM: HAS CHECK =  " + "b4378fg43f43674326d4872364789324f23"+check_result+ "fb323448fn43u8dfb23732rf32");
					if(this._result.checksum != checksum) {
						trace("CHECKSUM: Failed Match");
						this._success = false;
						this._result = { code:RemoteServicesErrorCode.ERROR_CHECKSUM_FAILED }
					}
					//trace("CHECKSUM: Ending Check");
				}
			}
			else
			{
				this._success = false;
				
				if ( evt.type == TimerEvent.TIMER )
				{
					this._result = { message:RemoteServicesErrorCode.getErrorMessage({code:RemoteServicesErrorCode.ERROR_REQUEST_TIMEOUT}), code:RemoteServicesErrorCode.ERROR_REQUEST_TIMEOUT };
					try
					{
						this.url_loader.close();
					}
					catch ( e:* )
					{
						//
					}
				}
				else if ( evt.type == IOErrorEvent.IO_ERROR )
				{
					this._result = { message:RemoteServicesErrorCode.getErrorMessage({code:RemoteServicesErrorCode.ERROR_IO}), code:RemoteServicesErrorCode.ERROR_IO };
				
				}
				else if ( evt.type == SecurityErrorEvent.SECURITY_ERROR )
				{
					this._result = { message:RemoteServicesErrorCode.getErrorMessage({code:RemoteServicesErrorCode.ERROR_SECURITY}), code:RemoteServicesErrorCode.ERROR_SECURITY };
				}
				else
				{
					this._result = { message:RemoteServicesErrorCode.getErrorMessage({code:RemoteServicesErrorCode.ERROR_UNKNOWN}), code:RemoteServicesErrorCode.ERROR_UNKNOWN };
				}
				
			}
			
			this.penginCall = null;
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			trace(" this._result :"+ this._result+ " this._success:"+this._success)
			trace(" END SERVICE CALL ==========================================================================");
			
			//TODO somethign here
			//if ( this.onResponse )
		//	{
				_isBusy = false;
				var fn:Function = this.onResponse;
				this.onResponse = null;
				fn( this._success, this._result );
			//}
			
		}
		
		public function dispose():void
		{
			this.timer.removeEventListener(TimerEvent.TIMER, this.responseHandler);
			this.timer.stop();
			
			this.url_loader.removeEventListener( Event.COMPLETE, this.responseHandler );
			this.url_loader.removeEventListener( IOErrorEvent.IO_ERROR, this.responseHandler );
			this.url_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, this.responseHandler );
			
			try
			{
				if ( this.penginCall )
				{
					this.url_loader.close();
				}
			}
			catch ( e:* )
			{
				//
			}
		}
		
	}

}