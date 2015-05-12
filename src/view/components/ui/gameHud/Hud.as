package view.components.ui.gameHud 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_GenericUI;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.DeviceType;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.ui.CoinHud;
	import view.components.ui.DistanceHud;
	
	//==========================================o
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o	
	
	public class Hud extends Sprite
	{
		private var _oDistanceHud:DistanceHud;
		private var _oCoinHud:CoinHud;
		private var _imgBacking:DisplayObject;

		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function Hud() 
		{
			trace(this + "Constructed");
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);

			
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_imgBacking = DSpriteSheet_GenericUI.dtm.getAssetByUniqueAlias("hudBacking");
			_imgBacking.alpha = .5;
			this.addChild(_imgBacking);
			
			_oDistanceHud = new DistanceHud();
			_oDistanceHud.x = 22;
			_oDistanceHud.y = 22;
			this.addChild(_oDistanceHud);
			
			_oCoinHud = new CoinHud();
			_oCoinHud.x = 340;
			_oCoinHud.y = 22;
			this.addChild(_oCoinHud);
		}
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();

		}
		
		public function get oDistanceHud():DistanceHud 
		{
			return _oDistanceHud;
		}
		
		public function get oCoinHud():CoinHud 
		{
			return _oCoinHud;
		}
		
		
	}

}