package com.thirdsense.utils
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.settings.Profiles;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	
	/**
	 * Allows remote loading of images in to a bitmap instance utilising dynamic smoothing. Also acts as a load cue manager for multiple image loads.
	 */
	
	public class SmoothImageLoad {
		
		private var urlrequest:URLRequest;
		private var target:DisplayObjectContainer;
		private var maxwidth:Number;
		private var maxheight:Number;
		private var requiresPolicyFile:Boolean;
		private var scaletype:String;
		private var bmpdata:BitmapData;
		private var cache:Boolean;
		
		/**
		 * Constrains an image to a maximum width or maximum height while retaining the ratio of width to height (Only applies if the loaded image is larger than the max_width or max_height values)
		 */
		public static const CONSTRAIN:String = "constrain";
		
		/**
		 * The image is cropped to the maximum width and height from the center of the image
		 */
		public static const CROP_TO_CENTER:String = "cropToCenter";
		
		/**
		 * The image is cropped to the maximum width and height from the top left of the image
		 */
		public static const CROP_TO_TOP_LEFT:String = "cropToTopLeft";
		
		/**
		 * If the image is wider than the maximum width, it is set at the maximum width. The same applies to the height of the image
		 */
		public static const STRETCH:String = "stretch";
		
		/**
		 * No matter what, the image will be displayed at the exact width and height of the max_width and max_height values
		 */
		public static const EXACT:String = "exact";
		
		/**
		 * The event type that gets thrown if a call to killCue gets made while the cue is populated. This event gets dispatched to each object in the cue.
		 */
		public static const CANCEL_LOAD:String = "cancelLoad";
		
		/**
		 * The event type that gets thrown when a call to load exceeds the allowed timed response.
		 */
		public static const TIMED_OUT_LOAD:String = "timedOutLoad";
		
		private static var myLoader:Loader;
		private static var myURLRequest:URLRequest;
		private static var queue:Vector.<SmoothImageLoad>;
		private static var cache:Array;
		private static var _timeout:Number = 20000;
		private static var timer:Timer;
		
		/**
		 * The progress of the current image being loaded (between 0 and 1)
		 */
		public static var progress:Number = 0;
		
		public function SmoothImageLoad():void
		{
			
		}
		
		/**
		 * Loads an image from a specified url
		 * @param	myURL	The url to load the image from
		 * @param	target	The target container to place a bitmap copy of the loaded image
		 * @param	maxwidth	The maximum width of the image. Leave as 0 for the native size to be used
		 * @param	maxheight	The maximum height of the image. Leave as 0 for the native size to be used
		 * @param	scale_type	Determines the scale type to be used. Defaults to SmoothImageLoad.CONSTRAIN.
		 * @param	requiresPolicyFile	If a crossdomain load is required, pass this as true and ensure you have loaded the appropriate security context policy first.
		 * @param	cacheImage	If the image should be cached for later use in the session, pass this as true. Defaults to false.
		 * @see	flash.system.Security
		 * @example	<p>The following example starts the load of 3 separate image urls, and places them in individual movieclips, warps their size to 100x100 and caches
		 * the resulting BitmapData of each image for instant loading for the remainder of the session.</p>
		 * <listing>
		 * var image_urls:Array = [ "http://www.mydomain.com/image1.jpg", "http://www.mydomain.com/image2.jpg", "http://www.mydomain.com/image3.jpg" ];
		 * 
		 * for ( var i:uint = 0; i &lt; image_urls.length; i++ )
		 * {
		 * 	var mc:MovieClip = new MovieClip();
		 * 	mc.x = i &#42; 100;
		 * 	mc.y = 50;
		 * 	this.addChild( mc );
		 * 
		 * 	mc.addEventListener( Event.COMPLETE, this.imageLoadHandler );
		 * 	mc.addEventListener( SmoothImageLoad.CANCEL_LOAD, this.imageLoadHandler );
		 * 	SmoothImageLoad.imageLoad( image_urls[i], mc, 100, 100, SmoothImageLoad.EXACT, false, true );
		 * }
		 * 
		 * function imageLoadHandler( evt:Event ):void
		 * {
		 * 	var mc:MovieClip = evt.currentTarget as MovieClip;
		 * 	mc.removeEventListener( Event.COMPLETE, this.imageLoadHandler );
		 * 	mc.removeEventListener( SmoothImageLoad.CANCEL_LOAD, this.imageLoadHandler );
		 * 
		 * 	switch ( evt.type )
		 * 	{
		 * 		case SmoothImageLoad.CANCEL_LOAD:
		 * 			// SmoothImageLoad.killCue() was called and the cue load was cancelled. Any code that needs to be executed to handle the cancellation can be placed here
		 * 			break;
		 * 
		 * 		case Event.COMPLETE:
		 * 			// The load was completed and a Bitmap instance has been placed in to the container
		 * 			var bmp:Bitmap = mc.getChildAt( mc.numChildren-1 ) as Bitmap;
		 * 			break;
		 * 	}
		 * }
		 * </listing>
		 */
		
		public static function imageLoad(myURL:String, target:DisplayObjectContainer, maxwidth:Number=0, maxheight:Number=0, scale_type:String="constrain", requiresPolicyFile:Boolean=false, cacheImage:Boolean=false ):void {
			
			myURLRequest = new URLRequest(myURL);
			
			if ( !queue )
			{
				queue = new Vector.<SmoothImageLoad>;
			}
			
			var sml:SmoothImageLoad = new SmoothImageLoad();
			sml.urlrequest = myURLRequest;
			sml.target = target;
			sml.maxwidth = maxwidth;
			sml.maxheight = maxheight;
			sml.requiresPolicyFile = requiresPolicyFile;
			sml.scaletype = scale_type;
			sml.bmpdata = null;
			sml.cache = cacheImage;
			
			queue.push(sml);
			
			if ( cacheImage )
			{
				if ( !cache )
				{
					cache = new Array();
				}
				
			}
			
			// target.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler, false, 0, true);
			
			if ( queue.length == 1 ) {
				BTween.callOnNextFrame( loadNextSlot );
			}
			
			if ( sml.target.hasEventListener(SmoothImageLoad.TIMED_OUT_LOAD) )
			{
				startTimer();
			}
		}
		
		private static function startTimer():void
		{
			if ( timer )
			{
				timer.stop();
				timer.reset();
				timer.start();
			}
			else if ( _timeout > 0 )
			{
				timer = new Timer( _timeout, 1 );
				timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerHandler, false, 0, true );
				timer.start();
			}
		}
		
		private static function stopTimer():void
		{
			if ( timer )
			{
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerHandler );
				timer = null;
			}
		}
		
		/**
		 * Reports on if a specified url is currently sitting in the load cue (waiting to be loaded)
		 * @param	url	The source url of the image
		 * @return	boolean value
		 */
		
		public static function urlExistsInCue( url:String ):Boolean
		{
			if ( queue )
			{
				for ( var i:uint = 0; i < queue.length; i++ )
				{
					if ( queue[i].urlrequest.url == url )
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Clears the session cache of images
		 */
		
		public static function killCache():void
		{
			if ( cache )
			{
				while ( cache.length )
				{
					cache[0].bmpdata.dispose();
					cache[0].bmpdata = null;
					cache.shift();
				}
			}
			
			cache = null;
		}
		
		/**
		 * Kills the current cue of images waiting to be loaded. An event type SmoothImageLoad.CANCEL_LOAD gets dispatched to every target
		 * DisplayObjectContainer remaining in the cue when this call is made.
		 */
		
		public static function killCue():void
		{
			trace( "LaunchPad", SmoothImageLoad, "Called killCue()" );
			
			if ( myLoader && myLoader.contentLoaderInfo ) {
				
				try
				{
					if ( myLoader.contentLoaderInfo.bytesLoaded < myLoader.contentLoaderInfo.bytesTotal ) {
						myLoader.close();
					}
				}
				catch (e:*)
				{
					//
				}
				
				myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
				myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
				myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
				myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
				
				myLoader = null;
			}
			
			if ( queue && queue.length ) {
				for ( var i:uint = 0; i < queue.length; i++ ) {
					(queue[i].target as DisplayObjectContainer).dispatchEvent( new Event(SmoothImageLoad.CANCEL_LOAD) );
				}
			}
			queue = null;
			
			stopTimer();
		}
		
		/**
		 * Retrieves if the SmoothImageLoad class has files waiting in the load cue
		 * @return	True if the queue is populated. False otherwise.
		 */
		
		public static function hasCue():Boolean
		{
			if ( queue && queue.length ) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		
		private static function removeHandler(evt:Event):void
		{
			evt.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			for ( var i:uint = 0; i < queue.length; i++ ) {
				if ( queue[i].target == evt.currentTarget as MovieClip ) {
					queue.splice(i, 1);
					return void;
				}
			}
		}
		
		/**
		 * Retrieves a bitmapdata object from the session stored cache
		 * @param	url	The url of the source image
		 * @return	A bitmapdata instance of the cached object. If the object does not exist in the session cache, returns null.
		 */
		
		public static function getFromCache( url:String ):BitmapData
		{
			if ( cache )
			{
				for ( var i:uint = 0; i < cache.length; i++ )
				{
					if ( cache[i].url == url )
					{
						return cache[i].bmpdata.clone();
					}
				}
			}
			
			return null;
		}
		
		public static function removeFromCache( url:String ):Boolean
		{
			if ( cache )
			{
				var success:Boolean = false;
				
				for ( var i:int = 0; i < cache.length; i++ )
				{
					if ( cache[i].url == url )
					{
						cache[i].bmpdata.dispose();
						cache[i].bmpdata = null;
						cache.splice( i, 1 )
						i--;
						success = true;
					}
				}
				
				return success;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Retrieves if a url exists in the session cache
		 * @param	url	The url of the image to check against
		 * @return	True if it exists in cache.
		 */
		
		public static function existsInCache( url:String ):Boolean
		{
			if ( cache )
			{
				for ( var i:uint = 0; i < cache.length; i++ )
				{
					if ( cache[i].url == url )
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		
		private static function loadNextSlot():void
		{
			if ( !queue || !queue[0] )
			{
				stopTimer();
				return void;
			}
			
			myLoader = new Loader();
			
			queue[0].target.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			if ( queue[0].bmpdata || existsInCache(queue[0].urlrequest.url) )
			{
				BTween.callOnNextFrame( doneLoad );
				stopTimer();
				return void;
			}
			
			myLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, doneLoad, false, 0, true );
			myLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true );
			myLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, errorHandler, false, 0, true );
			myLoader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler, false, 0, true );
			
			if ( queue[0].requiresPolicyFile ) {
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;
				
				if ( LocalConnection.isSupported ) {
					var lc:LocalConnection = new LocalConnection();
					if ( lc.domain.toLowerCase().indexOf("app") ) {
						Security.allowDomain( (queue[0].urlrequest as URLRequest).url );
					}
				}
				myLoader.load( queue[0].urlrequest, context );
			} else {
				myLoader.load( queue[0].urlrequest );
			}
			
			startTimer();
		}
		
		private static function timerHandler( e:TimerEvent ):void
		{
			trace( "LaunchPad", SmoothImageLoad, "Image load timed out:", e );
			
			if ( myLoader )
			{
				try {
					myLoader.close();
				}
				catch ( e:* )
				{
					//
				}
				
				if ( myLoader.contentLoaderInfo )
				{
					myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
					myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
					myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
					myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
				}
				
				myLoader = null;
			}
			
			queue[0].target.dispatchEvent( new Event(SmoothImageLoad.TIMED_OUT_LOAD, false, true) );
			
			if ( queue.length > 1 )
			{
				queue.shift();
				loadNextSlot();
			}
			else
			{
				queue = null;
				stopTimer();
			}
		}
		
		/**
		 * @private
		 */
		
		private static function securityHandler( evt:SecurityErrorEvent ):void
		{
			trace( "LaunchPad", SmoothImageLoad, "Security Error loading image:", evt );
			
			myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
			myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
			myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
			
			queue[0].target.dispatchEvent( evt );
			
			if ( queue.length > 1 )
			{
				queue.shift();
				loadNextSlot();
			}
			else
			{
				queue = null;
				stopTimer();
			}
			
		}
		
		/**
		 * @private
		 */
		
		private static function errorHandler( evt:IOErrorEvent ):void
		{
			trace( "LaunchPad", SmoothImageLoad, "Error loading image:", evt );
			
			myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
			myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
			myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
			
			queue[0].target.dispatchEvent( evt );
			
			if ( queue.length > 1 )
			{
				queue.shift();
				loadNextSlot();
			}
			else
			{
				queue = null;
				stopTimer();
			}
			
		}
		
		/**
		 * @private
		 */
		
		private static function progressHandler( evt:ProgressEvent ):void
		{
			if ( queue && queue.length && queue[0].target )
			{
				queue[0].target.dispatchEvent( evt );
				progress = evt.bytesLoaded / evt.bytesTotal;
			}
			
		}
		
		/**
		 * @private
		 */
		
		private static function doneLoad(evt:Event=null):void {
			
			if ( evt && myLoader )
			{
				var BMPdata:BitmapData = new BitmapData(myLoader.width, myLoader.height, true, 0x00000000);
				var BMP:Bitmap = new Bitmap(BMPdata, "auto", true );
				
				try {
					BMPdata.draw(myLoader, null, null, null, null, true);
				} catch (e:Error) {
					
					trace( "LaunchPad", SmoothImageLoad, "ERROR", e );
					
					queue[0].target.dispatchEvent( new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR) );
					
					myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
					myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
					myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
					myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
					
					if ( queue.length > 1 ) {
						queue.shift();
						loadNextSlot();
					} else {
						queue = null;
						myLoader = null;
						stopTimer();
					}
					
					return void;
				}
			}
			else if ( !queue )
			{
				stopTimer();
				return void;
			}
			else
			{
				BMPdata = getFromCache( queue[0].urlrequest.url );
				if ( !BMPdata )
				{
					BMPdata = queue[0].bmpdata;
				}
				else
				{
					//trace( "OBJECT RETRIEVED FROM CACHE" );
				}
				BMP = new Bitmap( BMPdata, "auto", true );
			}
			
			if ( myLoader && queue && queue.length )
			{
				var scaletype:String = queue[0].scaletype;
				
				if ( evt )
				{
					var url:String = (queue[0].urlrequest as URLRequest).url;
					for ( var i:uint = 1; i < queue.length; i++ )
					{
						if ( queue[i].urlrequest.url == url )
						{
							queue[i].bmpdata = BMP.bitmapData.clone();
						}
					}
					
					if ( queue[0].cache && !existsInCache(queue[0].urlrequest.url) )
					{
						var obj:Object = {
							url:queue[0].urlrequest.url,
							bmpdata:BMP.bitmapData.clone()
						}
						cache.push( obj );
					}
				}
				
				if ( queue[0].maxwidth || queue[0].maxheight) {
					
					if ( scaletype == SmoothImageLoad.CONSTRAIN ) 
					{
						while ( BMP.height > queue[0].maxheight || BMP.width > queue[0].maxwidth ) {
							BMP.scaleX -= 0.005;
							BMP.scaleY -= 0.005;
						}
					}
					
					if ( scaletype == SmoothImageLoad.STRETCH ) 
					{
						if ( BMP.height > queue[0].maxheight ) {
							BMP.height = queue[0].maxheight;
						}
						if ( BMP.width > queue[0].maxwidth ) {
							BMP.width = queue[0].maxwidth;
						}					
					}
					
					if ( scaletype == SmoothImageLoad.CROP_TO_CENTER || scaletype == SmoothImageLoad.CROP_TO_TOP_LEFT ) 
					{					
						BMP.height = 1;
						BMP.width = 1;
						while ( BMP.height < queue[0].maxheight || BMP.width < queue[0].maxwidth ) {
							BMP.scaleX += 0.005;
							BMP.scaleY += 0.005;
						}
						
						if ( scaletype == SmoothImageLoad.CROP_TO_CENTER ) {
							BMP.x = (queue[0].maxwidth - BMP.width) / 2;
							BMP.y = (queue[0].maxheight - BMP.height) / 2;
						}
						if ( scaletype == SmoothImageLoad.CROP_TO_TOP_LEFT ) {
							BMP.x = 0;
							BMP.y = 0;
						}
						
						var bmpdata:BitmapData = new BitmapData( queue[0].maxwidth, queue[0].maxheight, true, 0 );
						var matrix:Matrix = BMP.transform.matrix;
						bmpdata.draw( BMP, matrix, null, null, null, true );
						BMP = new Bitmap( bmpdata, "auto", true );
						
					}
					
					if ( scaletype == SmoothImageLoad.EXACT ) {
						BMP.width = queue[0].maxwidth;
						BMP.height = queue[0].maxheight;
					}
				}
				
				queue[0].target.addChild(BMP);
				
				myLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, doneLoad );
				myLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
				myLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
				myLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityHandler );
				
				obj = queue[0];
			}
			
			
			
			if ( queue.length > 1 )
			{
				queue.shift();
				loadNextSlot();
			}
			else
			{
				queue = null;
				stopTimer();
			}
			
			if ( obj )
			{
				obj.target.dispatchEvent( new Event(Event.COMPLETE, false) );
			}
			
		}
		
		/**
		 * Sets the timeout period in seconds (Default is 20 seconds)
		 */
		static public function get timeout():Number { return Math.floor(_timeout / 1000) };		
		static public function set timeout(value:Number):void 
		{
			_timeout = value * 1000;
		}
		
	}
}