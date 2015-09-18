package view.components.ui.nativeDisplay 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import singleton.Core;
	import staticData.dataObjects.PlayerData;
	import staticData.GameData;
	/**
	 * ...
	 * @author john
	 */
	public class ProgressBar extends MC_progressBar
	{
		private var _discipline:String;
		private var _core:Core = Core.getInstance();
		private var _baseWidth:int;
		private var _disciplineVO:*
		
		public function ProgressBar(discipline:String) 
		{
			
			_discipline = discipline;
			if (stage)
			init()
			else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		public function update():void 
		{
			this.$mcBar.width = PlayerData.currMiningExp / _core.controlBus.playerController.nextMiningLevelExp * _baseWidth;
			if (this.$mcBar.width == _baseWidth)
			this.$mcBar.width = 1;
			
			this.$txLabel.text = String(PlayerData.currMiningLevel);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
			
		}
		
		private function init():void 
		{
			_baseWidth = this.$mcBar.width;
			
		}
		

		
	}

}