package view.components.gameobjects.terrainTiles 
{

	import com.johnstejskal.Maths;
	import flash.geom.Point;
	import ManagerClasses.AssetsManager;
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
	import staticData.GameData;
	import view.components.gameobjects.scenery.DesertGrass;
	import view.components.gameobjects.scenery.DesertShrub;
	import view.components.gameobjects.scenery.SceneryRock1;
	import view.components.gameobjects.scenery.SceneryRock2;
	import view.components.gameobjects.scenery.SceneryTree1;
	import view.components.gameobjects.scenery.SceneryTree2;
	import view.components.gameobjects.scenery.Sign1;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.AppData;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TerrainTile extends GameObject
	{
		public var type:String;
		
		private var _core:Core;
		private var _ptTargetSlot:Point;
		private var _destinationSlotIndex:int;
		private var _img:DisplayObject;
		private var _angle:Number;
		private var _side:String;
		public var environment:String;
		private var _isLeader:Boolean = false;
		private var _leader:TerrainTile;
		private var _roadTile:TileRoad;
		private var _objects:Array;
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function TerrainTile() 
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
			
			
		}
		
		public function init():void 
		{
			//trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_objects = new Array();
			if(environment == "desert")
			_objects = [SceneryRock1, SceneryRock2, DesertShrub, DesertGrass];
			else
			_objects = [SceneryTree1, SceneryTree2];
			
			
			_img = DSpriteSheet_scenery.dtm.getAssetByUniqueAlias("tile_terrain_"+type);
			this.addChild(_img);
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
		}
		public override function activate():void
		{
			createScenery();
			
		}
		private function createScenery():void 
		{
			
			var lngth:int = _objects.length - 1;
			var cl:Class 
			var hasSign:Boolean = false;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 6 ; j++) 
				{
					
					var randIndex:int = Maths.rn(0, lngth);
					cl = _objects[randIndex];
					
					var chance:int = Maths.rn(1, 10);
					if(chance > 5)
					{
						var obj:* = new cl();
						
						if (GameData.showRoadSign && !hasSign)
						{
							if (_side == "left")
							{
								if (j == 5)
								{
									obj = new Sign1();
									hasSign = true;
									GameData.roadSignCount ++;
								}
							}
							//right
							else
							{
								if (j == 0)
								{
									obj = new Sign1();
									hasSign = true;
									GameData.roadSignCount ++;
								}
								
							}
							
							if (GameData.roadSignCount == 2)
							{
								GameData.showRoadSign = false;
								GameData.roadSignCount = 0;
							}
						}
						
						obj.x = AppData.deviceScale * (((j * 130) + 290) - i * 55);
						obj.y = AppData.deviceScale * (((i * 120) + 72)  + j * 34);
						
						this.addChild(obj);
					}
				}
			}
			
		}
		
		override public function onUpdate(e:Event = null):void  
		{
			if (!GameData.isGameInPlay)
			return;
			
			if (_leader)
			{
				this.x = _leader.x + AppData.deviceScale * 222;
				this.y = _leader.y - AppData.deviceScale * 460;
			}
			//no leader set for tile, this tile is the main leader
			else
			{
				var pt:Point;
				if (_side == "left")
				pt = GameData.ptExitSlotL
				else
				pt = GameData.ptExitSlotR;
				
				_angle = Math.atan2(pt.y - this.y, pt.x - this.x)
				this.x += Math.cos(_angle) * GameData.currentSpeed;
				this.y += Math.sin(_angle) * GameData.currentSpeed;
					
				if (int(this.x) <= int(pt.x))
				{
					reset();	
				}
			}
			

		}
		
		private function reset():void 
		{
			_core.refPlayScreen.generateTerrainTile(_side);
			trash(); 
			
			if (_isLeader)
			{
				
			}
			else
			{
				
			}
			
			
/*			_destinationSlotIndex ++;
			if (_destinationSlotIndex < 6)
			{
				if (_side == "left")
				_ptTargetSlot = GameData.arrDestinationSlots[_destinationSlotIndex];
				else if (_side == "right")
				_ptTargetSlot = GameData.arrDestinationSlotsR[_destinationSlotIndex];
			}
			else
			{
				_core.refPlayScreen.generateTerrainTile(_side);
				trash(); 
			}
			*/
		}
		
		override public function trash():void
		{
			//trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		public function get ptTargetSlot():Point 
		{
			return _ptTargetSlot;
		}
		
		public function set ptTargetSlot(value:Point):void 
		{
			_ptTargetSlot = value;
		}
		
		public function get destinationSlotIndex():int 
		{
			return _destinationSlotIndex;
		}
		
		public function set destinationSlotIndex(value:int):void 
		{
			_destinationSlotIndex = value;
		}
		
		public function get side():String 
		{
			return _side;
		}
		
		public function set side(value:String):void 
		{
			_side = value;
		}
		
		public function get isLeader():Boolean 
		{
			return _isLeader;
		}
		
		public function set isLeader(value:Boolean):void 
		{
			_isLeader = value;
		}
		
		public function get leader():TerrainTile 
		{
			return _leader;
		}
		
		public function set leader(value:TerrainTile):void 
		{
			_leader = value;
		}
		
		public function get roadTile():TileRoad 
		{
			return _roadTile;
		}
		
		public function set roadTile(value:TileRoad):void 
		{
			_roadTile = value;
		}
		
		
	}

}