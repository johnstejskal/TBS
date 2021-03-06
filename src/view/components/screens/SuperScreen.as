package view.components.screens
{

	import com.greensock.TweenLite;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import starling.display.MovieClip;
	import flash.text.StageText;
	import interfaces.iScreen;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppData;
	import staticData.AppFonts;
	import staticData.Constants;
	import staticData.DeviceType;
	import staticData.DynamicAtlasValues;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.valueObjects.ValueObject;
	import view.components.ui.CustomTextField;
	import view.components.ui.FormField;
	import view.components.ui.MenuIcon;

	import view.components.ui.TitleBar;


	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class SuperScreen extends Sprite implements iScreen
	{
		static public const TRANSITION_TYPE_RIGHT:String = "transitionRight";
		static public const TRANSITION_TYPE_LEFT:String = "transitionLeft";
		static public const TRANSITION_TYPE_NONE:String = "transitionNone";
			
		
		public var core:Core = Core.getInstance();
		private var _imgBG:Image;
		private var _imgTitleLogo:Image;
		private var _imgButton:Image;
		private var _quFill:Quad;
		private var _quBGFill:Quad;
		private var _bgHexColour:uint = HexColours.NAVY_BLUE;
		private var _qtitleBarBacking:Quad;
		public var oMenuIcon:MenuIcon;
		
		public var showMenuIcon:Boolean = true;
		public var showTitleBar:Boolean = true;
		public var showBackButton:Boolean = true;
		public var showLoadingScreen:Boolean = false;
		
		public var isTransParentTitle:Boolean = false;
		
		public var subTitleBarState:Boolean;
		private var _displayName:String = "";

		public var spTitleText:Sprite;
		
		public var manualRemoveDim:Boolean = false;
		public var isTransitioning:Boolean = false;
		public var enableTimeOutPopup:Boolean = false;
		
		public var trueTouch:TrueTouch;
		
		public var currMenuLevel:int = 1;
		public var prevSubScreenState:String;
		public var currSubScreenState:String;
		public var arrScreenStates:Array = [];
		//public var oPanel:SuperPanel;

		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function SuperScreen():void 
		{
			// No addedToStage Events are used here as there is a loading sequence 
			// Init is called after the loaded method executes
		}
		
		//-----------------------------------------------------------------------o
		//------ Assets loaded callback 
		//-----------------------------------------------------------------------o
		public function loaded():void 
		{
			init()
			
		}
		
		//----------------------------------------------------------------------o
		//------ init 
		//----------------------------------------------------------------------o		
		public function init():void 
		{
			core.controlBus.appUIController.removeLoadingScreen();
			
		}
		
		public function initComplete():void 
		{
			//this is used to handle optionally handle the
			// delays that are created with intensive GPU load
			// based on large object creation ie objectPool polulation

			
			core.controlBus.appUIController.removeFillOverlay();
		}

		//----------------------------------------o
		//------ dispose/kill/terminate/
		//----------------------------------------o	
		public function trash():void
		{
		

		}
		
		//----------------------------------------o
		//------ activate
		//----------------------------------------o	
		public function activate():void
		{
			this.touchable = true;
		}	
		
		//----------------------------------------o
		//------ de-activate
		//----------------------------------------o	
		public function deactivate():void
		{
			trace(this + "deactivate()");

			this.touchable = false;
		}
		
		

		
		
		public  function changeSubScreen(newState:String, vo:ValueObject = null, transitionType:String = "none"):void 
		{
			
		}
		


		
		
	}
	
}