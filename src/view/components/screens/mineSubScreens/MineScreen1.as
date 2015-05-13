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

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class MineScreen1 extends SuperScreen implements iScreen
	{
		private var _oBg:Quad;



		//==========================================o
		//------ Constructor 
		//==========================================o
		public function MineScreen1():void 
		{
			
		}

		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{
			_oBg = new Quad(AppData.deviceResX, AppData.deviceResY, 0x0000ff);
			this.addChild(_oBg);
			
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