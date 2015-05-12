package view.components.gameobjects.scenery 
{

	import ManagerClasses.AssetsManager;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_action;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_scenery;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class SceneryObject extends GameObject
	{
		private var _core:Core;
		public var type:String;
		private var _img:DisplayObject;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function SceneryObject() 
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null):void 
		{
			//trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_img = DSpriteSheet_scenery.dtm.getAssetByUniqueAlias(type);
			this.addChild(_img);
			//this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
/*		override public function onUpdate(e:Event = null):void  
		{
			
		}*/
		
		override public function trash():void
		{
			//trace(this+" trash()")
			
		}
		
		
	}

}