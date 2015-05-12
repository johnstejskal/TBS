package view.components.gameobjects 
{

	import com.greensock.TweenLite;
	import com.johnstejskal.Maths;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class Background extends Sprite
	{
		private var _core:Core;
		
		private var _collisionArea:Image;
		private var _hexColour:uint;
		private var _type:String;
		
		private var _imgTransition1:Image;
		private var _imgTransition2:Image;
		private var _imgTransition3:Image;
		private var _imgTransition4:Image;
		private var _quBGFill:Quad;
		private var _currTransObj:Image;
		private var _currBGState:String;
		private var _quBoostFlash:Quad;

		
		public static var STATE_DEFAULT:String = "default";
		public static var STATE_POWER_1:String = "headGear";
		public static var STATE_POWER_2:String = "slowDown";
		public static var STATE_POWER_3:String = "coinDouble";
		public static var STATE_POWER_4:String = "coinMagnet";	
		static public const STATE_SPECIAL:String = "stateSpecial";
		

		//====================================o
		//-- Constructor
		//====================================o
		public function Background(type:String, isPlayScreen:Boolean = true) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_currBGState = type;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			if (isPlayScreen)
			{
			//_imgTransition1 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_BG_TRANSITIONS).getTexture("TA_bgTransition10000"));
			//_imgTransition2 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_BG_TRANSITIONS).getTexture("TA_bgTransition20000"));
			//_imgTransition3 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_BG_TRANSITIONS).getTexture("TA_bgTransition30000"));
			//_imgTransition4 = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_BG_TRANSITIONS).getTexture("TA_bgTransition40000"));
			
			}
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_quBGFill = new Quad(AppData.deviceResX, AppData.deviceResY, 0x000000);
			this.addChild(_quBGFill);
			updateBGFill(_currBGState);
			
			
			_quBoostFlash = new Quad(AppData.deviceResX, AppData.deviceResY, 0x76EACE)
		}
		
		//called from powerup controller
		public function transitionIn(type:String = null):void
		{
			
			trace(this + "transitionIn(" + type + ")");
			
			if (type == STATE_POWER_1)
			return;
			
			if (type == STATE_POWER_2)
			_currTransObj = _imgTransition2;
			else if (type == STATE_POWER_3)
			_currTransObj = _imgTransition3;	
			else if (type == STATE_POWER_4)
			_currTransObj = _imgTransition4;	

			this.addChild(_currTransObj)
			
			_currTransObj.width = 100;
			_currTransObj.height = 100;
			
			_currTransObj.pivotX = _currTransObj.width/2;
			_currTransObj.pivotY = _currTransObj.height / 2;
			
			_currTransObj.x = AppData.deviceResX / 2;
			_currTransObj.y = AppData.deviceResY / 2;
			
			_currTransObj.width = 100;
			_currTransObj.height = 100;
			_currTransObj.alpha = 0;
			
			TweenLite.to(_currTransObj, .5, { delay: 1, width:AppData.deviceResY + 300, height:AppData.deviceResY + 300, onStart:function():void{ _currTransObj.alpha = 1  },  onComplete:function():void {

			}})
			
		}
		
		//called from powerup controller
		public function transitionOut():void
		{
			trace(this + "transitionOut()");
			if (_currTransObj)
			_currTransObj.alpha = 0;
			//removeChild(_currTransObj);
		}
		
		
		public function updateBGFill(type:String):void
		{
			trace(this + "updateBGFill("+type+")");
			
			if (type == STATE_DEFAULT)
			_quBGFill.color  = 0x9BFBF8;
			else if (type == STATE_POWER_1)
			_quBGFill.color  = 0xd94252;
			else if (type == STATE_POWER_2)
			_quBGFill.color  = 0xFFB3A2;
			else if (type == STATE_POWER_3)
			_quBGFill.color = 0xF4ECA2;
			else if (type == STATE_POWER_4)
			_quBGFill.color = 0xC4FC9B;			
			else if (type == STATE_SPECIAL)
			_quBGFill.color = 0x000054;
		
			_currBGState = type;
		}
		
		public  function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		public function makeFlash():void
		{
			
		}
		
		public function doBoostFlash():void 
		{
			if (AppData.isFreezePlay)
			return;
			
			trace("doBoostFlash");
			this.addChild(_quBoostFlash);
		}
				
		public function stopBoostFlash():void 
		{
			this.removeChild(_quBoostFlash)
		}
		

		
		
	}

}