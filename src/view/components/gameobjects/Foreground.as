package view.components.gameobjects 
{

	import com.johnstejskal.Maths;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
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
	public class Foreground extends Sprite
	{
		private var _core:Core;
		private var DYNAMIC_TA_REF:String = "Foreground";
		private var _collisionArea:Image;
		
		//images
		private var _imgSomeImage:Image;
		private var _quFill1:Quad;
		private var _quFill2:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		private var _type:String;
		private var _imgBGtile1:Image;
		private var _imgBGtile2:Image;
		private var _spMoveHolder:Sprite;
		private var _min:Number;
		private var _isMovable:Boolean;
		
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Foreground(type:String = null) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_type = type;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_min = -AppData.deviceResY;
			_spMoveHolder = new Sprite();
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_bgTexture") as MovieClip;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_bgTexture", null, 1, 1, null, 0)
			_imgBGtile1 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_bgTexture").getImage();
			_spMoveHolder.addChild(_imgBGtile1);
			_imgBGtile1.width = AppData.deviceResX;
			_imgBGtile1.height = AppData.deviceResY;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_bgTexture", null, 1, 1, null, 0)
			_imgBGtile2 = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_bgTexture").getImage();
			_spMoveHolder.addChild(_imgBGtile2);	
			_imgBGtile2.width = AppData.deviceResX;
			_imgBGtile2.height = AppData.deviceResY;
			_imgBGtile2.y = AppData.deviceResY
			
			_spMoveHolder.flatten();
			_spMoveHolder.y = 0;
			this.addChild(_spMoveHolder);
			
		}
		
		public function onUpdate():void
		{
			if (AppData.isFreezePlay || !_isMovable)
			return;
			
			if(!AppData.isBoosting)
			_spMoveHolder.y -= AppData.currSpeed * 3.5;// 1.5;
			else
			_spMoveHolder.y -= AppData.currSpeed * 3.5//1.8;
			
			if (_spMoveHolder.y <= _min)
			_spMoveHolder.y = 0;
		}
		

		public  function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF);
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		public function get isMovable():Boolean 
		{
			return _isMovable;
		}
		
		public function set isMovable(value:Boolean):void 
		{
			_isMovable = value;
		}
		
		
	}

}