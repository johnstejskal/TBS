package view.components.screens
{
	import com.thirdsense.animation.TexturePack;
	import flash.display.MovieClip;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import starling.display.MovieClip;
	import interfaces.iScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.AppData;
	import staticData.settings.PublicSettings;
	import view.components.screens.mineSubScreens.MineScreen1;
	import view.components.screens.mineSubScreens.MineScreen2;
	import view.components.screens.mineSubScreens.MineScreen3;

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class MineScreen extends SuperScreen implements iScreen
	{
		private var _oBg:Quad;
		private var _spMineSeriesHolder:Sprite;
		
		private var _oMineScreen1:MineScreen1;
		private var _oMineScreen2:MineScreen2;
		private var _oMineScreen3:MineScreen3;


		//==========================================o
		//------ Constructor 
		//==========================================o
		public function MineScreen():void 
		{
			
		}

		//==========================================o
		//------ Assets loaded callback 
		//==========================================o
		public override function loaded():void 
		{

			DSpriteSheet_mining.init(init);
		}
		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{

			_spMineSeriesHolder = new Sprite();
			
			_oMineScreen1 = new MineScreen1();
			_oMineScreen2 = new MineScreen2();
			_oMineScreen3 = new MineScreen3();
			
			_spMineSeriesHolder.addChild(_oMineScreen1);
			_spMineSeriesHolder.addChild(_oMineScreen2);
			_spMineSeriesHolder.addChild(_oMineScreen3);
			
			this.addChild(_spMineSeriesHolder);
			
			
		}

		//==========================================o
		//------ Event Handlers 
		//==========================================o		
		//==========================================o
		//------ Touch Handlers 
		//==========================================o
		private function onTouch(e:TouchEvent):void 
		{
			
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
                if(touch.phase == TouchPhase.BEGAN)
                {				
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
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
		

		
		//==========================================o
		//------ Getters and Setters 
		//==========================================o			
		
	}
	
}