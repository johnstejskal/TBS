package view.components.screens.mineSubScreens
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
	import view.components.gameobjects.mining.ore.MineOre;
	import view.components.gameobjects.mining.ore.Ore;
	import view.components.screens.SuperScreen;

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class MineScreen3 extends MineSubScreen
	{
		private var _oBg:Quad;



		//==========================================o
		//------ Constructor 
		//==========================================o
		public function MineScreen3():void 
		{
			init();
		}

		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{
			_oBg = new Quad(AppData.deviceResX, AppData.deviceResY, 0xff00ff);
			this.addChild(_oBg);
			
			var ore:MineOre = new MineOre(Ore.TYPE_COAL, 1, this);
			ore.x = ore.y = 100;
			this.addChild(ore);
						
			var ore2:MineOre = new MineOre(Ore.TYPE_COAL, 2, this);
			ore2.x = ore2.y = 400;
			this.addChild(ore2);
									
			var ore3:MineOre = new MineOre(Ore.TYPE_COAL, 3, this);
			ore3.x = 600; ore3.y = 100;
			this.addChild(ore3);
			
						
			
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