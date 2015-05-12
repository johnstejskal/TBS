package view.components.ui 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
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
	public class CoinHud extends Sprite
	{
		private var _tf:TextField;


		//=======================================o
		//-- Constructor
		//=======================================o
		public function CoinHud() 
		{
			trace(this + "Constructed");
			_tf = new TextField(85, 40, String(0), AppFonts.FONT_ARIAL, 30, HexColours.WHITE);
			_tf.filter = BlurFilter.createDropShadow(2, 1, 0x000000, 0.2, 0, 0.5);
			
			
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
			
/*			var sim:Image = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_hudCoinBacking0000"));
			sim.x = -30, 
			sim.y = -30;
			this.addChild(sim);*/
			
			_tf.hAlign = HAlign.CENTER; 
			_tf.vAlign = VAlign.TOP;
			_tf.border = false;
			_tf.x = -4;// sim.x + sim.width + 10
			_tf.y = 5;

			this.addChild(_tf);

		}
		
		
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public  function trash():void
		{
			trace(this + " trash()")
			this.removeFromParent();

		}
		
		public function update():void 
		{
			_tf.text = String(GameData.currCoins);
		}
				
		public function get tf():TextField 
		{
			return _tf;
		}
		
		public function set tf(value:TextField):void 
		{
			_tf = value;
		}
		
	}

}