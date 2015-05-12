package ManagerClasses.ObjectPools 
{

	import com.johnstejskal.StringFunctions;
	import starling.display.DisplayObject;
	import view.components.gameobjects.Coin;
	import view.components.gameobjects.enemy.Block;
	import view.components.gameobjects.superClass.ActionObjSuper;
	import view.components.gameobjects.superClass.Enemy;
	import view.components.gameobjects.superClass.EnemySuper;
	import view.components.gameobjects.superClass.GameObject;
	/**
	 * ...
	 * @author john
	 */
	public class ObjPool_Misc 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		
		
		public function ObjPool_Misc() 
		{
			
		}
		
		
		//===============================================o
		//-- Populate an object pool by Class ie Block , Bird
		//===============================================o	
		public static function populate(targClass:Class, amount:int = 0):void 
		{

			for (var i:int = 0; i < amount; i++) 
			{
				var obj:GameObject = new targClass();
				addToPool(obj);
			}
			
			trace(ObjPool_Misc+"populate() OP has been populated:" + pool.length);
		}
				

		
		//===============================================o
		//-- add an object ie Block , Bird
		//===============================================o		
		public static function addToPool(obj:GameObject):void
		{
			pool.push(obj);
			//trace(obj + " was ADDED to ObjectPool - pool is now:" + pool.length);
		}
		
		//===============================================o
		//-- Populate an object pool by Class ie Block , Bird
		//===============================================o	
		public static function populateAndReturnOne(targClass:Class, amount:int = 0):GameObject 
		{
			var o:GameObject;
			for (var i:int = 0; i < amount; i++) 
			{
				var obj:GameObject = new targClass();
				
				if(i == 0)
				o = obj
				else
				addToPool(obj);
			}
		
			return o;
		}
		
		//===============================================o
		//-- Retrieve an item by Class type ie Block , Bird
		//===============================================o
/*		public static function getFromPool(targClass:Class):GameObject
		{
			var item:GameObject;
			var lngth:int = pool.length;
			
			if (pool.length == 0)
			populate(targClass, 10)
			
			for (var i:int = 0; i < lngth; i ++)
			{
				
				if (targClass == StringFunctions.getClass(pool[i]))
				{
					item = pool[i];
					pool.splice(i,1);
					return item;
				}	
			}
			return item;
		}	*/
		
		//===============================================o
		//-- Retrieve an item by Class type ie Block , Bird
		//===============================================o
		public static function getFromPool(targClass:Class):GameObject
		{
			var item:GameObject;
			var lngth:int = pool.length;

			var found:Boolean = false;
			loop :for (var i:int = 0; i < lngth; i ++)
			{
				
				if (targClass == StringFunctions.getClass(pool[i]))
				{
					item = pool[i];
					pool.splice(i, 1);
					found = true;
					break loop;
				}
				
			}
			
			if (!found)
			item = populateAndReturnOne(targClass, 10);
			
			return item;
		}
		
		
		//-----------------------o
		//-- empty pool
		//
		static public function empty():void 
		{
			trace(ObjPool_Misc + "empty()");
			pool.length = 0;
			pool = [];
		}
		
	}

}