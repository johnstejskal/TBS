package view.components.screens.mineSubScreens
{
	import com.greensock.TweenMax;
	import com.thirdsense.animation.TexturePack;
	import flash.display.MovieClip;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import interfaces.iScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.dataObjects.PickAxeVO;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.mining.ore.MineOre;
	import view.components.gameobjects.mining.ore.Ore;
	import view.components.gameobjects.mining.PickAxe;
	import view.components.screens.SuperScreen;

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class MineSubScreen extends SuperScreen implements iScreen
	{
		private var _oPickAxe:PickAxe;

		//==========================================o
		//------ Constructor 
		//==========================================o
		public function MineScreen1():void 
		{
			
			init();
		}

		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{

			
		}
		
		
		
		public function mapEvents():void
		{

		}
		


		public override function activate():void
		{
			trace(this + "activate()");
			
		}

		public override function deactivate():void
		{
			
		}

		//==========================================o
		//------ Public functions 
		//==========================================o
		
		//==========================================o
		//------ dispose/kill/terminate/
		//==========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			
			this.removeFromParent();
		}
		
		public function setup():void 
		{
			mapEvents();

		}
		

		//==========================================o
		//------ Getters and Setters 
		//==========================================o			
		
	}
	
}