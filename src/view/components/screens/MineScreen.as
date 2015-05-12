package view.components.screens
{
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import starling.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import interfaces.iScreen;
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
	public class MineScreen extends SuperScreen implements iScreen
	{
		private const DYNAMIC_TA_REF:String = getQualifiedClassName(this);
		private var _mcPlayButton:starling.display.MovieClip;

		
		
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
			trace(this + "loaded():"+DYNAMIC_TA_REF);
			
		   //add play button
		   var mc:* = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "MC_playButton") as flash.display.MovieClip;
		   TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "MC_playButton", null, 1, 2, null, 0)
		   _mcPlayButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "MC_playButton").getMovieClip();
		   _mcPlayButton.x = AppData.deviceResX / 2;
		   _mcPlayButton.y = AppData.deviceResY / 2;
		   this.addChild(_mcPlayButton);
		   
		   _mcPlayButton.addEventListener(TouchEvent.TOUCH, onTouch)
		}
		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{

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
					starling.display.MovieClip(touch.target).currentFrame = 1;
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					starling.display.MovieClip(touch.target).currentFrame = 0;
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
			
			//dispose texture maps
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		

		
		//==========================================o
		//------ Getters and Setters 
		//==========================================o			
		
	}
	
}