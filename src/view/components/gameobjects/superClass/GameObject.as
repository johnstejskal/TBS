package view.components.gameobjects.superClass 
{

	import flash.geom.Point;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class GameObject extends Sprite
	{
		public var isActive:Boolean = false;
		public var speed:Number = 0;
		private var _core:Core;
		public var collisionArea:Quad;
		public var destinationX:int;
		public var destinationY:int;
		public var angle:Number;
		public var startSlot:Point;		
		public var vectors:Array;

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function GameObject() 
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
		
		}
		
		//-----------------------------o
		//-- init
		//-----------------------------o		
		private function init(e:Event):void 
		{

			
		}
		
		//-----------------------------o
		//-- Event Handler
		//-----------------------------o
		public function onUpdate(e:Event = null):void 
		{
			//trace(this + "onUpdate()");
			
			
			
		}
		
		//-----------------------------o
		//-- Event Handler
		//-----------------------------o
		public function initialize():void 
		{
			//trace(this + "onUpdate()");
		}
				
		
		//-----------------------------o
		//-- Activate - wake up object
		//-----------------------------o
		public function activate():void
		{
			trace(this + "activate1()");
			isActive = true;
			
		}
		//-----------------------------o
		//-- Deactivate - put object to sleep
		//-----------------------------o
		public function deactivate():void
		{
			isActive = false;
			
		}
		
		//-----------------------------o
		//-- trash/dispose/anihliate
		//-----------------------------o		
		public function trash():void
		{
			trace(this+" trash()")
			this.removeEventListeners();
		}
		
		
		//-----------------------------o
		//-- Getters | Setters
		//-----------------------------o			

		
		
	}

}