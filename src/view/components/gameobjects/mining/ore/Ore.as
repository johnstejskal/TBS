package view.components.gameobjects.mining.ore {

	import com.johnstejskal.Maths;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import staticData.dataObjects.PickAxeVO;
	import view.components.gameobjects.superClass.GameObject;


	
	//==================================================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==================================================================o
	public class Ore extends GameObject
	{
		public var type:String;
		static public const TYPE_TIN:String = "tin";
		static public const TYPE_COPPER:String = "copper";
		static public const TYPE_COAL:String = "coal";
		static public const TYPE_IRON:String = "iron";
		static public const TYPE_GOLD:String = "gold";
		static public const TYPE_MITHRIL:String = "mithril";
		static public const TYPE_ADAMANTITE:String = "adamantite";
		static public const TYPE_OBSIDIAN:String = "obsidian";
		static public const TYPE_DRAGON:String = "dragon";
		
		public var isDepleted:Boolean = false;
		public var strengthGrade:int = 0;
		//public var oreVO:OreVO
		public var coolDownRemaining:int = 0;
		public var swingsRequired:int = 1;
		private var _tmrCoolDown:Timer;

		//============================================o
		//-- Constructor  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		//============================================o
		public function Ore() 
		{
			
		}
		
		public function doMineOre():void 
		{
			if (isDepleted)
			return;
			
			_tmrCoolDown = new Timer(1000, 10)
			isDepleted = true;
			
			this.visible = false;
			_tmrCoolDown.addEventListener(TimerEvent.TIMER, onTimerTick)
			
			_tmrCoolDown.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_tmrCoolDown.start();
		}
		
		public function canMine():Boolean 
		{
			var val:Boolean = false;
			if (strengthGrade <= PickAxeVO.strengthGrade)
			val = true;
			
			return val;
		}
		
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			this.visible = true;
			isDepleted = false;
			_tmrCoolDown.removeEventListener(TimerEvent.TIMER, onTimerTick)
			_tmrCoolDown.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete)
			_tmrCoolDown = null;
		}
		
		private function onTimerTick(e:TimerEvent):void 
		{
			
		}
		
		
		
	}

}