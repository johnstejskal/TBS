package view.components.ui 
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
	import staticData.GameData;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class DistanceHud extends Sprite
	{
		private var _tf:TextField;
		private var _img:DisplayObject;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function DistanceHud() 
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
			
			_img = DSpriteSheet_GenericUI.dtm.getAssetByUniqueAlias("distanceHud");
			this.addChild(_img);
			
			_tf = new TextField(AppData.deviceScaleX*150, AppData.deviceScaleX*40, String(Inventory.coins), AppFonts.FONT_ARIAL, AppData.deviceScaleX*30, HexColours.WHITE);
			_tf.hAlign = HAlign.RIGHT; 
			_tf.vAlign = VAlign.TOP;
			_tf.border = false;
			_tf.x =  20;
			this.addChild(_tf);
			
		}

		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public  function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();

		}
		
		public function update():void 
		{
			_tf.text = String(GameData.currDistance);
		}
		
		
	}

}