package com.thirdsense 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.controllers.MobilityControl;
	import com.thirdsense.core.Preload;
	import com.thirdsense.data.LPAsset;
	import com.thirdsense.data.LPValue;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.settings.Profiles;
	import com.thirdsense.utils.FlashVars;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import starling.core.Starling;
	
	/**
	 * <p>LaunchPad application framework and asset management toolset. For mobile, desktop and web based projects.</p>
	 * 
	 * <p>The following example shows how to initialize the framework from within the base constructor class of your project:</p>
	 * 
	 * <listing>
	 * package {
	 * 	import flash.display.MovieClip;
	 * 	import com.thirdsense.LaunchPad;
	 * 	
	 * 	public class Example extends MovieClip {
	 * 		private var launchpad:LaunchPad;
	 * 		
	 * 		public function Example() {
	 * 			this.launchpad = new LaunchPad();
	 * 			this.launchpad.init( this, this.onLaunchPadInit );
	 * 		}
	 * 
	 * 		private function onLaunchPadInit() {
	 * 			trace( "LaunchPad has loaded my assets and now I'm ready to rumble!" );
	 * 		}
	 * 	}
	 * }</listing>
	 * 
	 * @author Ben Leffler
	 * @version 1.0.0
	 */
	
	public class LaunchPad
	{
		/**
		 * Singleton instance of the LaunchPad framework
		 */
		public static var instance:LaunchPad;
		
		private var _target:MovieClip;
		private var onCompleteInit:Function;
		private var _starling:Starling;
		private var custom_config:XML;
		
		/**
		 * The base constructor of the LaunchPad framework. Where all good things must come from.
		 * @param	custom_config	Rather than LaunchPad loading the project config.xml file from a hosted location, you can embed the config.xml file
		 * and pass it through as a parameter
		 */
		
		public function LaunchPad( custom_config:XML=null ) 
		{
			// Allows a user to pass through an embedded configuration file for a self-contained project
			if ( custom_config != null ) this.custom_config = custom_config;
			
			this.loadLaunchPadLibrary();
		}
		
		/**
		 * @private
		 */
		
		private function loadLaunchPadLibrary():void
		{
			var mc:MovieClip = new lp_button1();
			mc = new lp_loadingicon();
			var spr:Sprite = new lp_launchpadlight();
			spr = new lp_launchpaddark();
			var font:Font = new ArialRounded();
			var bmd:BitmapData = new lp_starlinglight();
			bmd = new lp_starlingdark();
			
		}
		
		/**
		 * Initializes and starts application load procedure.
		 * @param	root	The root class for the application. This can be accessed from calling LaunchPad.root
		 * @param	onComplete	The function to call once the application has completed initializing
		 * @param	preloader	The MoveiClip to use for the preloading user interface. Pass as null to use the default generic loader.
		 * @param	profile	The profile of the device to use for this build.
		 */
		
		public function init( target:MovieClip, onComplete:Function, preloader:MovieClip=null ):void
		{
			trace( "LaunchPad", LaunchPad, "Launching..." );
			
			instance = this;
			
			this._target = target;
			this._target.stop();
			
			this.onCompleteInit = onComplete;
			
			// Check for an alternate path to the lib folder through use of flashvars
			FlashVars.init( target );
			var live_extension:String = FlashVars.getVar( "lib_path" );
			if ( live_extension != null ) LPSettings.LIVE_EXTENSION = String(live_extension);
			
			// Call a start to the engine
			this._target.addEventListener(Event.ENTER_FRAME, this.processEngine, false, 0, true);
			
			// Call the preload on the next frame (because the stage size has to initialize first)
			BTween.callOnNextFrame( Preload.load, [preloader, this.onPreloadComplete, this.custom_config] );
		}
		
		/**
		 * Callback to the completion function as passed through to init
		 */
		
		private function onPreloadComplete():void
		{
			Profiles.CURRENT_DEVICE = Profiles.DEVICE_DETECT;
			
			if ( Profiles.mobile )
			{
				MobilityControl.initAudioMode();
			}
			
			this.onCompleteInit();
			this.onCompleteInit = null;
		}
		
		/**
		 * The root movieclip that was passed through in the LaunchPad.init call
		 */
		
		public function get target():MovieClip 
		{
			return this._target;
		}
		
		/**
		 * Returns the root clips native stage
		 */
		
		public function get nativeStage():Stage
		{
			return this._target.stage;
		}
		
		/**
		 * Returns the starling instance if startStarlingSession has previously been called.
		 */
		
		public function get starling():Starling 
		{
			return _starling;
		}
		
		public function set starling( value:Starling )
		{
			this._starling = value;
		}
		
		/**
		 * Function called on an EnterFrame event to process the core engine (such as tweens)
		 * @param	evt	EnterFrame event called on the launchpad target
		 */
		
		private function processEngine(evt:Event):void
		{
			if ( Profiles.mobile && getValue("debug") == "true" )
			{
				try
				{
					BTween.processCue();
				}
				catch ( e:Error )
				{
					reportError( e );
					throw( e );
				}
			}
			else
			{
				BTween.processCue();
			}
		}
		
		public static function reportError( e:Error = null, message:String = "" ):void 
		{
			var spr:Sprite = LaunchPad.instance.nativeStage.getChildByName("LPErrorReport") as Sprite;
				
			if ( !spr )
			{
				var spr:Sprite = new Sprite();
				spr.graphics.beginFill( 0x000000, 0.8 );
				spr.graphics.drawRect( 0, 0, LaunchPad.instance.nativeStage.stageWidth, LaunchPad.instance.nativeStage.stageHeight );
				spr.graphics.endFill();
			
				var txt:TextField = new TextField();
				txt.width = spr.width - 40;
				txt.height = spr.height - 40;
				txt.x = 20;
				txt.y = 20;
				txt.defaultTextFormat = new TextFormat(null, 20);
				txt.textColor = 0xFFFFFF;
				txt.multiline = true;
				txt.wordWrap = true;
				spr.addChild( txt );
				
				spr.name = "LPErrorReport";
				spr.mouseChildren = false;
				spr.mouseEnabled = true;
				spr.addEventListener( MouseEvent.CLICK, reportClickHandler, false, 0, true );
				
				LaunchPad.instance.nativeStage.addChild( spr );
			}
			else
			{
				txt = spr.getChildAt( spr.numChildren - 1 ) as TextField;
			}
			
			if ( e ) txt.text += e.getStackTrace() + "\n";
			else txt.text += message + "\n";
		}
		
		static private function reportClickHandler(e:MouseEvent):void 
		{
			var spr:Sprite = e.currentTarget as Sprite;
			spr.removeEventListener(MouseEvent.CLICK, reportClickHandler);
			spr.parent.removeChild(spr);
		}
		
		/**
		 * Starts a Starling framework session (v1.4) - It is still recommended that you add the starling.swc to your project for access to all Starling classes
		 * @param	rootClass	The root class of the starling container that gets called upon initialisation
		 * @param	handleLostContext	Handles the device losing Stage3D context (requires more device memory)
		 * @param	showStats	Show a stats dialogue in the top-left corner of the stage
		 * @param	enableMultiTouch	Enable multitouch within the project
		 * @param	profile	The Context3DProfile to use with the project
		 * @return	The resulting Starling instance.
		 * @see	flash.display3D.Context3DProfile
		 */
		
		public final function startStarlingSession( rootClass:Class, handleLostContext:Boolean=false, showStats:Boolean=false, enableMultiTouch:Boolean=false, profile:String = "baselineConstrained" ):Starling
		{
			trace( "LaunchPad", LaunchPad, "Starling session started." );
			Starling.handleLostContext = handleLostContext;
			Starling.multitouchEnabled = enableMultiTouch;
			
			this._starling = new Starling( rootClass, this.nativeStage, new Rectangle(0, 0, this.nativeStage.stageWidth, this.nativeStage.stageHeight), null, "auto", profile );
			this._starling.showStats = showStats;
			this._starling.start();
			
			return this._starling;
		}
		
		/**
		 * Obtains a value as defined by the LaunchPad config.xml
		 * @param	name	The name of the value to retrieve
		 * @return	The value as a String
		 * @example	<p>Firstly you must have appropriate values established in your project config.xml file:</p>
		 * <listing>
		 * &lt;data&gt;
		 *  &lt;value name="firstName" value="Ben" &#47;&gt;
		 *  &lt;value name="lastName" value="Leffler" &#47;&gt;
		 * &lt;&#47;data&gt;
		 * </listing>
		 * <p>The values set out above will then become available through your project by calling getValue as follows:</p>
		 * <listing>
		 * var firstName:String = LaunchPad.getValue( "firstName" );
		 * var lastName:String = LaunchPad.getValue( "lastName" );
		 * </listing>
		 */
		
		public static function getValue( name:String ):String
		{
			var lpvalue:LPValue = LPValue.getValue( name );
			if ( lpvalue != null )
			{
				return lpvalue.value;
			}
			
			return null;
		}
		
		/**
		 * Obtains an asset that has been loaded in to the LaunchPad framework during the preload (and postload) stage.
		 * @param	id	(Optional) Designates which asset library to retrieve (or to retrieve from)
		 * @param	linkage	(Optional) Designates the specific linkage name of an asset, if the source library instance is a zip or a swf that has been set up with the LPAssetClient class
		 * @return	Null if item unfound. Otherwise it will return a variety of object types
		 * @example	<p>The assets to be loaded (both pre and post load) need to be set up in the project config.xml file as follows:</p>
		 * <listing>
		 * &lt;data&gt;
		 *  &lt;asset url="lib/swf/mySWFAsset1.swf" label="Loading Asset 1" id="first_asset" postload="false" &#47;&gt;
		 *  &lt;asset url="lib/swf/mySWFAsset2.swf" label="Loading Asset 2" id="second_asset" postload="true" &#47;&gt;
		 *  &lt;asset url="lib/swf/myZipAsset.zip" label="Loading Asset 3" id="third_asset" postload="false" &#47;&gt;
		 *  &lt;asset url="lib/swf/myXMLAsset.xml" label="Loading Asset 4" id="fourth_asset" postload="true" &#47;&gt;
		 *  &lt;asset url="lib/swf/myJSONAsset.json" label="Loading Asset 5" id="fifth_asset" postload="false" &#47;&gt;
		 * &lt;&#47;data&gt;
		 * </listing>
		 * <p>Notice that some assets aren't labelled as post-load, therefore these assets will get loaded in to memory during the LaunchPad.init call at the start
		 * and will be availble to call with the LaunchPad.getAsset call at any point. The other assets will need to be loaded with the LaunchPad.loadLibrary call 
		 * before you can access them.</p>
		 * <p>To load the asset with id 'first_asset' as a MovieClip (as the source asset is a swf), simply call:</p>
		 * <listing>
		 * var mc:MovieClip = LaunchPad.getAsset( "first_asset" ) as MovieClip;
		 * </listing>
		 * <p>However if 'first_asset' has it's own library items (set up with Actionscript linkage identifiers) that you wish to access, the source library 
		 * (ie mySWFAsset1.swf) will need to be compiled with a reference to the LPAssetClient class on it's main timeline as follows:</p>
		 * <listing>
		 * var client:LPAssetClient = new LPAssetClient(this);
		 * </listing>
		 * <p>You can now call upon any linkage within it's library from your LaunchPad project as follows:</p>
		 * <listing>
		 * var mc:MovieClip = LaunchPad.getAsset( "first_asset", "asset_linkage_name" );
		 * </listing>
		 * <p>You can also search your entire LaunchPad asset library for the linkage name, without knowing the id of the asset library. The first encountered match 
		 * will always be returned:</p>
		 * <listing>
		 * var mc:MovieClip = LaunchPad.getAsset( "", "asset_linkage_name" );
		 * </listing>
		 * <p>This call handles a multitude of different asset types. If you wanted to call on the library marked with id 'fifth_asset' (a JSON object):</p>
		 * <listing>
		 * var obj:Object = LaunchPad.getAsset( "fifth_asset" );
		 * </listing>
		 * <p>LaunchPad can also handle compressed library files such as zip and 3rd (same as zip, but with an altered extension). These libs are handy when you want
		 * to combine sound, images and movieclips in to a single compressed file without having to use Flash to compile the assets in to a swf library. File types 
		 * within the zip file should be limited to swf, mp3, jpg, png and gif</p>
		 * <p>The following example takes the asset marked with id 'third_asset' above and retrieves various assets from the zip file.</p>
		 * <listing>
		 * var mc:MovieClip = LaunchPad.getAsset( "third_asset", "my_swf.swf" );
		 * var sound:Sound = LaunchPad.getAsset( "third_asset", "my_sound.mp3" );
		 * var bmpdata1:BitmapData = LaunchPad.getAsset( "third_asset", "my_image.jpg" );
		 * var bmpdata2:BitmapData = LaunchPad.getAsset( "third_asset", "my_image.png" );
		 * var bmpdata3:BitmapData = LaunchPad.getAsset( "third_asset", "my_image.gif" );
		 * </listing>
		 */
		
		public static function getAsset( id:String = "", linkage:String = "" ):*
		{
			return LPAsset.getAsset( id, linkage );
		}
		
		/**
		 * Starts a post load procedure of LaunchPad library assets
		 * @param	id_array	An array of library id's to load one-by-one
		 * @param	onComplete	The callback function once the procedure has reached it's end
		 * @param	preloader	The preloader ui element to use. If left as null, the LaunchPad generic loader element is used. For no loader bar, pass this as an empty movieclip.
		 * @example	<p>When an asset has been tagged in the project config.xml as a postload asset, it will not be loaded by the framework until you call this function. So firstly,
		 * make sure that the asset has been correctly referenced in the config.xml</p>
		 * <listing>
		 * &lt;data&gt;
		 *  &lt;asset url="lib/swf/mySWFAsset1.swf" label="Loading Asset 1" id="first_asset" postload="false" &#47;&gt;
		 *  &lt;asset url="lib/swf/mySWFAsset2.swf" label="Loading Asset 2" id="second_asset" postload="true" &#47;&gt;
		 *  &lt;asset url="lib/swf/myZIPAsset.3rd" label="Loading Asset 3" id="third_asset" postload="true" &#47;&gt;
		 * &lt;&#47;data&gt;
		 * </listing>
		 * <p>As you can see, there are three assets that have been referenced above. The first has a postload value of 'false' which means it will load in to the LaunchPad asset
		 * library during the LaunchPad.init phase at the start of your application. However, the other assets are marked for postload and can be loaded in to the LaunchPad asset
		 * library as follows:</p>
		 * <listing>
		 * var asset_ids:Array = [ "second_asset", "third_asset" ] // Array of asset id's to be loaded
		 * 
		 * LaunchPad.loadLibrary( asset_ids, this.onAssetLoadComplete );
		 * 
		 * function onAssetLoadComplete():void
		 * {
		 *  // You can now access the postload marked assets that you have just loaded
		 * 
		 *  var mc:MovieClip = LaunchPad.getAsset( "second_asset" );
		 *  this.addChild( mc );
		 * }
		 * </listing>
		 * <p>The above example uses the generic LaunchPad loader bar as the 'preloader' param was left as null (by default). You can use your own custom loader ui by passing 
		 * through your own MovieClip. Or, if you prefer to not have any ui show during this load process, pass through an empty MovieClip:</p>
		 * <listing>
		 * LaunchPad.loadLibrary( asset_ids, this.onAssetLoadComplete, new MovieClip() );
		 * </listing>
		 */
		
		public static function loadLibrary( id_array:Array, onComplete:Function=null, preloader:MovieClip=null ):void
		{
			Preload.postLoad( id_array, onComplete, preloader );
		}
		
	}

}