package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;
	import staticData.AppData;
	/**
	 * ...
	 * @author 
	 */
	public class DSpriteSheet_GenericUI 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "genericUI";
		static public var onComplete:Function;
		
		public function DSpriteSheet_GenericUI() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			trace(DSpriteSheet_GenericUI + "init()");
			return;
			onComplete = complete;

	
								
						
			dtm = new DMTBasic(ref, false);

			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process();	

		}



			
			
		static private function onProcessComplete(e:Event):void 
		{
			dtm.removeEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			
			if (onComplete != null)
			onComplete();
		}
		
		
		public static function trash():void
		{
			if (dtm != null)
			{
				dtm.dispose();
				dtm = null;
			}
		}

		
	}

}