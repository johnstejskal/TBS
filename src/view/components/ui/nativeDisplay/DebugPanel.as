package view.components.ui.nativeDisplay 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import staticData.GameData;
	/**
	 * ...
	 * @author john
	 */
	public class DebugPanel extends FL_DebugPanel
	{
		
		public function DebugPanel() 
		{
			if (stage)
			init()
			else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
			
		}
		
		private function init():void 
		{
			this.$mcSpeedUp.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			this.$mcSpeedDown.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			this.$mcSpeedUp.mouseChildren = false;
			this.$mcSpeedDown.mouseChildren = false;
						
			$txSpeed.text = String(GameData.currentSpeed);
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch(e.target)
			{
				case $mcSpeedUp:
				trace("Speed up");
				GameData.currentSpeed ++;
				break;		
				
				case $mcSpeedDown:
				trace("Speed down");
				GameData.currentSpeed --;
				break;
			}
			
			$txSpeed.text = String(GameData.currentSpeed);
			
		}
		
	}

}