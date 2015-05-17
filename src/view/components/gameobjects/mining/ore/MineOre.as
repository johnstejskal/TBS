package view.components.gameobjects.mining.ore {
	import ManagerClasses.dynamicAtlas.DSpriteSheet_mining;
	import singleton.EventBus;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.dataObjects.PickAxeVO;
	import view.components.screens.mineSubScreens.MineSubScreen;


	
	//==================================================================o
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==================================================================o
	public class MineOre extends Ore
	{

		public var _variation:int;



		private var _img:DisplayObject;
		

		//============================================o
		//-- Constructor  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\
		//============================================o
		public function MineOre(oreType:String, variation:int, mine:MineSubScreen) 
		{
			type = oreType;
			_variation = variation;
			
			if (type == TYPE_TIN)
			strengthGrade = 1;
			else if (type == TYPE_COPPER)
			strengthGrade = 1;
			else if (type == TYPE_COAL)
			strengthGrade = 1;			
			else if (type == TYPE_IRON)
			strengthGrade = 2;				
			else if (type == TYPE_GOLD)
			strengthGrade = 2;					
			else if (type == TYPE_MITHRIL)
			strengthGrade = 3;					
			else if (type == TYPE_OBSIDIAN)
			strengthGrade = 4;				
			else if (type == TYPE_DRAGON)
			strengthGrade = 5;		
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null ):void 
		{
			this.removeEventListeners();
			_img = DSpriteSheet_mining.dtm.getAssetByUniqueAlias("mine_ore_"+type+"_"+_variation);
			this.addChild(_img);
			
			swingsRequired = 10 - (PickAxeVO.strengthGrade - strengthGrade) 
			if (swingsRequired <= 1)
			swingsRequired = 1;			
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
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
					//criteria is met ,  correct pick axe
					if(super.canMine())
					EventBus.getInstance().sigOnOreClicked.dispatch(this, true);
					//criteria not met,
					else
					EventBus.getInstance().sigOnOreClicked.dispatch(this, false);
					
                }
                else if(touch.phase == TouchPhase.ENDED)
                {
					
                }
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		override public function trash():void
		{
			
			//trace(this+" trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		public function doDepleteOre():void 
		{
			this.alpha = .3;
		}
		

		
		
	}

}