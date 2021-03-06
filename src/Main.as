package
{
	
	import com.johnstejskal.DateUtil;
	import com.Stats;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.Profiles;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.geom.Rectangle;
	import staticData.AppFonts;
	import staticData.AppData;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import treefortress.sound.SoundAS;
	import view.components.ui.nativeDisplay.DebugPanel;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.ResizeEvent;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import singleton.Core;
	import ManagerClasses.*;
	
	import view.*
	
	import staticData.Constants;
	
	/**
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Main extends MovieClip
	{
	
		private var _core:Core;
		private var context3D:Context3D;
		private var _starling:Starling;
		
		private var launchpad:LaunchPad;
		[SWF(frameRate="60")]
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			trace(this + "init()");
			
			var appFonts:AppFonts = new AppFonts();
			_core = Core.getInstance();
			_core.main = this;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;

			stage.scaleMode = StageScaleMode.NO_SCALE; //this one tested and working on android
			stage.quality = StageQuality.BEST;
			_core.main.stage.quality = StageQuality.HIGH;
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = true;
			
			_starling = new Starling(StarlingStage, stage, null, null, "auto", "auto");
			_starling.simulateMultitouch = true;
			_starling.antiAliasing = 1;
			_starling.enableErrorChecking = false;
			
			_starling.start();
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
						
			
			//-------------------------------------------------o
			//-- Setup Gestouch for Starling Based Gesture Support
			if (DeviceSettings.ENABLE_GESTURES)
			{
				Gestouch.inputAdapter ||= new NativeInputAdapter(stage);
				Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
				Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
			}
			
			if (PublicSettings.SHOW_STARLING_STATS)
			{
				_starling.showStats = true;
				_starling.showStatsAt(HAlign.LEFT, VAlign.TOP);
			}
			
			
			//_starling.addEventListener(ResizeEvent.RESIZE, onResize);
			_core.starling = _starling;
			
			
			var config:Config = new Config();
		
		}
		
		private function startLaunchPad():void 
		{
/*			init();
			return;*/
			this.launchpad = new LaunchPad( /*XML(new config_xml())*/ );
			this.launchpad.init( this, this.init, new MovieClip() );
		}
		
		
		private function onResize(e:ResizeEvent):void
		{
			trace(this + "onResize()");
			return;
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth;
		    viewPortRectangle.height = stage.stageHeight;
		
		   _starling.stage.stageWidth = stage.stageWidth;
		   _starling.stage.stageHeight = stage.stageHeight;
		   //Starling.current.viewPort = viewPortRectangle;
		   _starling.viewPort = viewPortRectangle;
		   _starling.stage.stageWidth = stage.stageWidth;
		  _starling.stage.stageHeight = stage.stageHeight;
		  AppData.deviceResX = stage.stageWidth;
		  AppData.deviceResY = stage.stageHeight;
		  
		  //currentScreen.resize();
		}
	
	}

}