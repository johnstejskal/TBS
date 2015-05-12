package view.components.examples.obstacles 
{

	import com.johnstejskal.ArrayUtil;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.gameobjects.superClass.EnemySuper;

	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Obstacle1 extends EnemySuper
	{
		
		private var _collisionArea:Quad;
		
		//images
		private var _quFill:Quad;
		private var _core:Core;


		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Obstacle1() 
		{
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);

		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_quFill = new Quad(100, 100, 0x000000);
			_quFill.x -= _quFill.width / 2;
			_quFill.alpha = 1;
			addChild(_quFill);
			
			_collisionArea = new Quad(50, 50, 0x00FF00);
			_collisionArea.alpha = .1;
			_collisionArea.x -= _collisionArea.width / 2;
			addChild(_collisionArea);
			
			
		}
		
		
		

		
		
	}

}