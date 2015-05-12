package view.components.screens
{


	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Power1;
	import com.greensock.easing.Quart;
	import com.greensock.plugins.DynamicPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import com.johnstejskal.keyboard.KeyObject;
	import com.johnstejskal.keyboard.StarlingKeyObject;
	import com.johnstejskal.Maths;
	import flash.display.Stage;
	import flash.geom.Point;
	import interfaces.iScreen;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_action;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_GenericUI;
	import ManagerClasses.dynamicAtlas.DSpriteSheet_scenery;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.AppData;
	import staticData.Constants;
	import staticData.dataObjects.PlayerData;
	import staticData.GameData;
	import staticData.Maps;
	import staticData.settings.PublicSettings;
	import treefortress.sound.SoundAS;
	import view.components.gameobjects.Background;
	import view.components.gameobjects.cars.Car;
	import view.components.gameobjects.cars.Car1;
	import view.components.gameobjects.collectables.Coin;
	import view.components.gameobjects.collectables.CoinStack;
	import view.components.gameobjects.collectables.Collectable;
	import view.components.gameobjects.collectables.Magnet;
	import view.components.gameobjects.collectables.Nitro;
	import view.components.gameobjects.obstacles.DitchLong;
	import view.components.gameobjects.obstacles.DitchShort;
	import view.components.gameobjects.obstacles.Obstacle;
	import view.components.gameobjects.obstacles.OilSlick;
	import view.components.gameobjects.obstacles.PotHole;
	import view.components.gameobjects.obstacles.SpeedHump;
	import view.components.gameobjects.superClass.GameObject;
	import view.components.gameobjects.terrainTiles.TerrainTile;
	import view.components.gameobjects.terrainTiles.TileGreenA;
	import view.components.gameobjects.terrainTiles.TileGreenB;
	import view.components.gameobjects.terrainTiles.TileOrangeA;
	import view.components.gameobjects.terrainTiles.TileOrangeB;
	import view.components.gameobjects.terrainTiles.TileRoad;
	import view.components.ui.gameHud.Hud;


	
	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	public class PlayScreen extends SuperScreen implements iScreen
	{

		
		private var _nativeStage:Stage;
		
		//game layers
		private var _layerUnderlay:Sprite; //items beneath player
		private var _layerAction:Sprite;  //player layer
		private var _layerOverlay:Sprite; //effects overlay
		private var _layerHUD:Sprite; //effects overlay
		
		private var _stateMachine:StateMachine;
		
		
		//Assets
		private var _oBackground:Background;
	
		
		private var _iDistCount:int = 0; // how often the distance updates
		private var _iDistCap:int = 30;
		
		//------------------------------------------------------o
		
		private var _arrActionObj:Array;
		private var _roadStartX:Number;
		private var _dir:Number;
		
		private var destinationX:Number;
		private var destinationY:Number;
		private var roadHolder:Sprite;
		private var _tileHeight:Number;
		private var _angle:Number;
		private var _xOffset:Number;
		private var _yOffset:Number;
		private var _xTileOffset:Number;
		private var _xTileOffsetR:Number;
		private var _arrLeftTerrain:Array;
		
		private var terrainLeftSlot1:Point;
		private var terrainLeftSlot2:Point;
		private var terrainLeftSlot3:Point;
		private var terrainLeftSlot4:Point;
		private var terrainLeftSlot5:Point;
		private var terrainLeftSlot6:Point;
				
		private var terrainRightSlot1:Point;
		private var terrainRightSlot2:Point;
		private var terrainRightSlot3:Point;
		private var terrainRightSlot4:Point;
		private var terrainRightSlot5:Point;
		private var terrainRightSlot6:Point;
		
		
		
		private var _isAlternateTerrainL:Boolean = true;
		private var _isAlternateTerrainR:Boolean = true;
		private var _oCar:Car;
		private var _oKeyObject:KeyObject;
		private var _layerWorld:Sprite;
		private var _isChangingLanes:Boolean = false;
		private var _distanceCount:Number = 0;
		
		private var _baseScreenWidth:Number;
		private var _layerTerrainLeft:Sprite;
		private var _layerTerrainRight:Sprite;
		
		private var _ptActionSlot1:Point;
		private var _ptActionSlot2:Point;
		private var _ptActionSlot3:Point;
		private var _ptActionSlot4:Point;
		private var _ptActionSlot5:Point;
		private var _iGen:Number = 0;
		private var _oHud:Hud;
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o
		public function PlayScreen():void 
		{
			trace(this + " PlayScreen()");
			TweenPlugin.activate([DynamicPropsPlugin]);
			core = Core.getInstance();
			core.refPlayScreen = this;
			_nativeStage = Starling.current.nativeStage;
			
			StateMachine._oPlayScreen = this;

		}
		
		//------------------------------------------------------------------------------o
		//------ Public API 
		//------------------------------------------------------------------------------o		
		public override function activate():void
		{


		}
		

		//----------------------------------------o
		//------ AssetLoad Callback
		//----------------------------------------o
		public override function loaded():void
		{
			trace(this + "loaded()");
			if (PublicSettings.ENABLE_ANALYTICS)
			{

			}
			
			fillObjectPools();	
			_arrLeftTerrain = new Array();
			
			DSpriteSheet_action.init(function():void{
				DSpriteSheet_scenery.init(function():void {
					DSpriteSheet_GenericUI.init(init);
					
				});	
			});
			
			
			
		}
		
		//----------------------------------------o
		// init complete called once all the assets are on stage are ready
		//----------------------------------------o
		public override function initComplete():void
		{
			trace(this + "initComplete()");
			
			TweenMax.delayedCall(.1, function():void
			{
				core.controlBus.appUIController.removeLoadingScreen();
				GameData.isGameInPlay = true; 
				//_oPlayer.isMovable = true;
				
			})
			
		}
		

		
		private function fillObjectPools():void 
		{
	
			
		}
		
		//------------------------------------------------------------------------------o
		//------ Private  API 
		//------------------------------------------------------------------------------o	
		//------------------------------------------o
		//-- Setup and position all the components
		//------------------------------------------o
		public override function init():void 
		{
			
			trace(this + "init()");	
			this.alpha = 0.99;
			
			_oKeyObject = new KeyObject(core.main.stage);
			_roadStartX = 186;
			
			_layerWorld = new Sprite();
			this.addChild(_layerWorld)
			
			roadHolder = new Sprite();
			_layerWorld.addChild(roadHolder);			
			
			_layerTerrainLeft = new Sprite();
			_layerWorld.addChild(_layerTerrainLeft)
			
			_layerAction = new Sprite();
			_layerWorld.addChild(_layerAction);
			
			_layerTerrainRight = new Sprite();
			_layerWorld.addChild(_layerTerrainRight)
			
			_layerHUD = new Sprite();
			this.addChild(_layerHUD);
			_oHud = new Hud();
			Starling.current.stage.addChild(_oHud);
			
			
			//_xOffset = (AppData.deviceScaleX * 224);
			_xOffset = (AppData.deviceScaleX * 222);
			//_yOffset = (AppData.deviceScaleX * 462);
			_yOffset = (AppData.deviceScaleX * 460);
			_xTileOffset = (AppData.deviceScaleX * 840);
			_xTileOffsetR = (AppData.deviceScaleX * 515);
		
			
			//road tiles
			var tile1:TileRoad = new TileRoad();
			tile1.x = 0;
			tile1.y = 0;
			roadHolder.addChild(tile1);
			
			var tile2:TileRoad = new TileRoad();
			tile2.x = tile1.x - _xOffset;
			tile2.y = tile1.y + _yOffset;
			roadHolder.addChild(tile2);
										
			var tile3:TileRoad = new TileRoad();
			tile3.x = tile2.x - _xOffset;
			tile3.y = tile2.y + _yOffset;
			roadHolder.addChild(tile3);
												
			var tile4:TileRoad = new TileRoad();
			tile4.x = tile3.x - _xOffset;
			tile4.y = tile3.y + _yOffset;
			roadHolder.addChild(tile4);
															
			var tile5:TileRoad = new TileRoad();
			tile5.x = tile4.x - _xOffset;
			tile5.y = tile4.y + _yOffset;
			roadHolder.addChild(tile5);
															
			var tile6:TileRoad = new TileRoad();
			tile6.x = tile5.x - _xOffset;
			tile6.y = tile5.y + _yOffset;
			roadHolder.addChild(tile6);
			
			
			_tileHeight = tile1.height;
			roadHolder.pivotY = roadHolder.height;
			roadHolder.pivotX = -(_xOffset * 5);
			resetRoad();
			
			destinationX =  - (_xOffset*2);
			destinationY =  AppData.deviceResY + _yOffset*2;
			
			
			_layerAction.x = roadHolder.x;
			_layerAction.y = roadHolder.y;
			
			//add starting left terrain
			//added from bottom to top
			var tileOA5:TileOrangeA = new TileOrangeA();
			tileOA5.side = "left";
			tileOA5.x = roadHolder.x - _xTileOffset;
			tileOA5.y = roadHolder.y - AppData.deviceScaleX *786;
			_layerTerrainLeft.addChild(tileOA5);
			tileOA5.activate();
			
			var tileOA4:TileOrangeB = new TileOrangeB();
			tileOA4.side = "left";
			tileOA4.x = tileOA5.x + _xOffset;
			tileOA4.y = tileOA5.y - _yOffset;
			_layerTerrainLeft.addChildAt(tileOA4, 0);
			tileOA4.activate();
			
			var tileOA3:TileOrangeA = new TileOrangeA();
			tileOA3.side = "left";
			tileOA3.x = tileOA4.x + _xOffset;
			tileOA3.y = tileOA4.y - _yOffset;
			_layerTerrainLeft.addChildAt(tileOA3, 0);
			tileOA3.activate();
			
			var tileOA2:TileOrangeB = new TileOrangeB();
			tileOA2.side = "left";
			tileOA2.x = tileOA3.x + _xOffset;
			tileOA2.y = tileOA3.y - _yOffset;
			_layerTerrainLeft.addChildAt(tileOA2, 0);
			tileOA2.activate();
			
			var tileOA1:TileOrangeA = new TileOrangeA();
			tileOA1.isLeader = true;
			tileOA1.side = "left";
			tileOA1.x = tileOA2.x + _xOffset;
			tileOA1.y = tileOA2.y - _yOffset;
			_layerTerrainLeft.addChildAt(tileOA1, 0);
			tileOA1.activate();
			
			var tileOA0:TileOrangeB = new TileOrangeB();
			tileOA0.isLeader = true;
			tileOA0.side = "left";
			tileOA0.x = tileOA1.x + _xOffset;
			tileOA0.y = tileOA1.y - _yOffset;
			_layerTerrainLeft.addChildAt(tileOA0, 0);
			tileOA0.activate();			
			
			tileOA5.leader = null;
			tileOA4.leader = tileOA5;
			tileOA3.leader = tileOA4;
			tileOA2.leader = tileOA3;
			tileOA1.leader = tileOA2;
			tileOA0.leader = tileOA1;
			
			//define exit position
			GameData.ptExitSlotL = new Point(tileOA5.x - _xOffset, tileOA5.y + _yOffset);
		
			GameData.arrRoadTilesL = [tileOA0, tileOA1, tileOA2, tileOA3, tileOA4, tileOA5];
		
			//add starting Right terrain
			//added from bottom to top
			var tileROA5:TileOrangeA = new TileOrangeA();
			tileROA5.side = "right";
			tileROA5.x = roadHolder.x + _xTileOffsetR;
			tileROA5.y = roadHolder.y - AppData.deviceScaleX *455;
			_layerTerrainRight.addChild(tileROA5);
			tileROA5.activate();
			
			var tileROA4:TileOrangeB = new TileOrangeB();
			tileROA4.side = "right";
			tileROA4.x = tileROA5.x + _xOffset;
			tileROA4.y = tileROA5.y - _yOffset;
			_layerTerrainRight.addChildAt(tileROA4, 0);
			tileROA4.activate();

			var tileROA3:TileOrangeA = new TileOrangeA();
			tileROA3.side = "right";
			tileROA3.x = tileROA4.x + _xOffset;
			tileROA3.y = tileROA4.y - _yOffset;
			_layerTerrainRight.addChildAt(tileROA3, 0);
			tileROA3.activate();
			
			var tileROA2:TileOrangeB = new TileOrangeB();
			tileROA2.side = "right";
			tileROA2.x = tileROA3.x + _xOffset;
			tileROA2.y = tileROA3.y - _yOffset;
			_layerTerrainRight.addChildAt(tileROA2, 0);
			tileROA2.activate();
			
			var tileROA1:TileOrangeA = new TileOrangeA();
			tileROA1.side = "right";
			tileROA1.x = tileROA2.x + _xOffset;
			tileROA1.y = tileROA2.y - _yOffset;
			_layerTerrainRight.addChildAt(tileROA1, 0);
			tileROA2.activate();
						
			var tileROA0:TileOrangeB = new TileOrangeB();
			tileROA0.side = "right";
			tileROA0.x = tileROA1.x + _xOffset;
			tileROA0.y = tileROA1.y - _yOffset;
			_layerTerrainRight.addChildAt(tileROA0, 0);
			tileROA0.activate();
			
			//define exit position
			GameData.ptExitSlotR = new Point(tileROA5.x - _xOffset, tileROA5.y + _yOffset);
		
			//create array stream
			GameData.arrRoadTilesR = [tileROA0, tileROA1, tileROA2, tileROA3, tileROA4, tileROA5];
			
			_oCar = new Car(PlayerData.carUpgradeLevel);
			_layerAction.addChild(_oCar);
			
			
			//_oCar.x = AppData.deviceResX / 2 - (AppData.deviceScale * 80);
			//_oCar.y = -AppData.deviceScale * 600;
						
			_oCar.x = AppData.deviceResX / 2 + (AppData.deviceScale * 20);
			_oCar.y = -AppData.deviceScale * 600;
						
			
		
			
			_ptActionSlot1 = new Point(AppData.deviceScale * 1230, AppData.deviceScale * -2550);
			_ptActionSlot2 = new Point(AppData.deviceScale * 1365, AppData.deviceScale * -2515);
			_ptActionSlot3 = new Point(AppData.deviceScale * 1495, AppData.deviceScale * -2485);
			_ptActionSlot4 = new Point(AppData.deviceScale * 1625, AppData.deviceScale * -2445);
			

			
			
			/*

			
			initComplete();*/
			
			_baseScreenWidth = this.width;
			
			addEventListener(Event.ENTER_FRAME, onUpdate)
			GameData.isGameInPlay = true;
			generateActionMap();
			
			_oCar.startMovingCar();
		}	
		
		private function onUpdate(e:Event):void 
		{
			if (!GameData.isGameInPlay)
			return;
			
			core.animationJuggler.advanceTime(.02);
			
			_angle = Math.atan2(destinationY - roadHolder.y, destinationX - roadHolder.x)
			var xOffset:Number = (Math.cos(_angle) *  GameData.currentSpeed);
			roadHolder.x += xOffset;
			roadHolder.y += (Math.sin(_angle) *  GameData.currentSpeed);
			
			_iGen += Math.abs(xOffset);
			
			if (_iGen >= 50)
			{
			_iGen = 0;	
			generateActionMap();
			}

			if (int(roadHolder.x) <= int(destinationX))
			resetRoad();
			
			if (_oKeyObject.isDown(37))
			{
				changeLanes("left");
			}
			else if (_oKeyObject.isDown(39))
			{ 
				changeLanes("right");
			}
			
			
			var speedScaleOffset:Number = (GameData.currentSpeed / PublicSettings.BASE_GAME_SPEED);
			
			if (speedScaleOffset > 1)
			{
				speedScaleOffset -= 1;
				speedScaleOffset = (speedScaleOffset / 10);
				
				var _scale:Number =  1 - speedScaleOffset;
				var _y:Number = (speedScaleOffset * _baseScreenWidth)/4;
				TweenMax.to(this, .5, {scaleX:_scale, scaleY:_scale, y:_y, ease:Linear.easeNone })
			}
			
		}
		
		private function generateActionMap():void 
		{
		
			if(GameData.currMapCount >= Maps.MAP.length)
			GameData.currMapCount = 0;
			
			var currMapLine:Array = Maps.MAP[GameData.currMapCount];
			
		
			for (var i:int = 0; i < 4; i++) 
			{
				var obj:GameObject;
				var type:String = currMapLine[i];
				switch(type)				
				{
					case Maps.O1:
					obj = new OilSlick();
					break;	
					
					case Maps.O2:
					obj = new PotHole();
					break;		
					
					case Maps.O3:
					obj = new DitchShort();
					break;	
										
					case Maps.O4:
					obj = new DitchLong();
					break;	
															
					case Maps.O5:
					obj = new SpeedHump();
					break;	
					
					//---------------------------
					
					case Maps.C1:
					obj = new Coin();
					break;	
																				
					case Maps.C2:
					obj = new CoinStack();
					break;	
																									
					case Maps.C3:
					obj = new Magnet();
					break;	
																														
					case Maps.C4:
					obj = new Nitro();
					break;	
					
					default:
					obj = null;
					break;
					
				}
				
				trace("obj "+i+" " + obj);
				
				if (obj != null)
				{
				var slot:Point = this["_ptActionSlot" + (i + 1)];
				
				trace("slot :"+i+" - " + slot);
				obj.startSlot = slot;
				obj.x = slot.x;
				obj.y = slot.y;
				obj.destinationX = obj.x + (AppData.deviceScaleY * 3000) * Math.cos(2.0204343445345962);
			    obj.destinationY = obj.y + (AppData.deviceScaleY * 3000) * Math.sin(2.0204343445345962);
				_layerAction.addChildAt(obj, 0);
				
				}
				
				
			}
			
			GameData.currMapCount ++;
/*			var ditch:DitchLong = new DitchLong();
			ditch.startSlot = _ptActionSlot1;
			ditch.x = _ptActionSlot1.x;
			ditch.y = _ptActionSlot1.y;
			*/			
/*			var ditch2:DitchLong = new DitchLong();
			ditch2.startSlot = _ptActionSlot2;
			ditch2.x = _ptActionSlot2.x;
			ditch2.y = _ptActionSlot2.y;*/
									
/*			var ditch3:DitchLong = new DitchLong();
			ditch3.startSlot = _ptActionSlot3;
			ditch3.x = _ptActionSlot3.x;
			ditch3.y = _ptActionSlot3.y;
												
			var ditch4:DitchLong = new DitchLong();
			ditch4.startSlot = _ptActionSlot4;
			ditch4.x = _ptActionSlot4.x;
			ditch4.y = _ptActionSlot4.y;*/
			
			/*					
			var coin:Coin = new Coin();
			coin.startSlot = _ptActionSlot1;
			coin.x = _ptActionSlot1.x;
			coin.y = _ptActionSlot1.y;
						
			var coin2:Coin = new Coin();
			coin2.startSlot = _ptActionSlot2;
			coin2.x = _ptActionSlot2.x;
			coin2.y = _ptActionSlot2.y;
									
			var coin3:Coin = new Coin();
			coin3.startSlot = _ptActionSlot3;
			coin3.x = _ptActionSlot3.x;
			coin3.y = _ptActionSlot3.y;
												
			var coin4:Coin = new Coin();
			coin4.startSlot = _ptActionSlot4;
			coin4.x = _ptActionSlot4.x;
			coin4.y = _ptActionSlot4.y;*/
			
			//ditch.destinationX = ditch.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			//ditch.destinationY = ditch.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
						
			//ditch2.destinationX = ditch2.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			//ditch2.destinationY = ditch2.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
/*						
			ditch3.destinationX = ditch3.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			ditch3.destinationY = ditch3.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
						
			ditch4.destinationX = ditch4.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			ditch4.destinationY = ditch4.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
			*/
/*		
			coin2.destinationX = coin2.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			coin2.destinationY = coin2.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
			
			coin3.destinationX = coin3.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			coin3.destinationY = coin3.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
			
			coin4.destinationX = coin4.x + (AppData.deviceScaleY * 2500) * Math.cos(2.0204343445345962);
			coin4.destinationY = coin4.y + (AppData.deviceScaleY * 2500) * Math.sin(2.0204343445345962);
			*/
/*			_layerAction.addChildAt(coin4, 0);
		    _layerAction.addChildAt(coin3, 0);
			_layerAction.addChildAt(coin2, 0);
			*/
			
			//_layerAction.addChildAt(ditch, 0);
			//_layerAction.addChildAt(ditch2, 0);
			//_layerAction.addChildAt(ditch3, 0);
			//_layerAction.addChildAt(ditch4, 0);
			
		}
		
		private function changeLanes(direction:String):void 
		{
			if (_isChangingLanes || !_oCar.isGrounded)
			return;
			
			_isChangingLanes = true
			if (direction == "left")
			{
				
				//TweenMax.to(_layerWorld, .4, { x:"45", y:"10", ease:Power1.easeOut, onComplete:laneChangeComplete } )
				//TweenMax.to(_oCar, .4, { x:"-89", y:"-20", ease:Power1.easeOut, onComplete:laneChangeComplete } )
				_oCar.doRotation("left")
				TweenMax.to(_layerWorld, GameData.currLaneChangeSpeed , { x:"134", y:"30", ease:Power1.easeOut } )
				TweenMax.to(_oCar, GameData.currLaneChangeSpeed, { x:"-134", y:"-30", ease:Power1.easeOut, onComplete:laneChangeComplete } )

			}
			else if (direction == "right")
			{
				//TweenMax.to(_layerWorld, .4, { x:"-45", y:"-10", ease:Power1.easeOut, onComplete:laneChangeComplete }) 
				//TweenMax.to(_oCar, .4, { x:"89", y:"20", ease:Power1.easeOut, onComplete:laneChangeComplete } )
		    	_oCar.doRotation("right")	
				TweenMax.to(_layerWorld, GameData.currLaneChangeSpeed, { x:"-134", y:"-30", ease:Power1.easeOut }) 
				TweenMax.to(_oCar, GameData.currLaneChangeSpeed, { x:"134", y:"30", ease:Power1.easeOut, onComplete:laneChangeComplete }) 
			}
			
			
		}
		
		private function laneChangeComplete():void 
		{
			_isChangingLanes = false
		}
		
		
		public function generateTerrainTile(side:String):void 
		{
			trace(this + "generateTerrainTile()");
			var tile:TerrainTile;
			
		if (side == "left")
		{
			//set a new leader for the stack
			GameData.arrRoadTilesL.pop();
			TerrainTile(GameData.arrRoadTilesL[GameData.arrRoadTilesL.length - 1]).leader = null;
		
			//define staring pos for new tile based on last in line
			var _x:Number = GameData.arrRoadTilesL[0].x + _xOffset;
			var _y:Number = GameData.arrRoadTilesL[0].y - _yOffset;
		
			
			if (!_isAlternateTerrainL)
			{
				if(_distanceCount <= 10.5)
				tile = new TileOrangeA();
				else
				tile = new TileGreenA();
				
				tile.side = "left";
				tile.leader = GameData.arrRoadTilesL[0];
				_isAlternateTerrainL = true;
				GameData.arrRoadTilesL.unshift(tile);
			}
			else
			{
				if(_distanceCount <= 10.5)
				tile = new TileOrangeB();
				else
				tile = new TileGreenB();
				
				tile.side = "left";
				tile.leader = GameData.arrRoadTilesL[0];
				_isAlternateTerrainL = false;
				GameData.arrRoadTilesL.unshift(tile);
			}
			_layerTerrainLeft.addChildAt(tile, 0);			
		}
		else if (side == "right")
		{
			//set a new leader for the stack
			GameData.arrRoadTilesR.pop();
			TerrainTile(GameData.arrRoadTilesR[GameData.arrRoadTilesR.length - 1]).leader = null;
		
			//define staring pos for new tile based on last in line
			var _x:Number = GameData.arrRoadTilesR[0].x + _xOffset;
			var _y:Number = GameData.arrRoadTilesR[0].y - _yOffset;
			
			if (!_isAlternateTerrainR)
			{
				if(_distanceCount <= 10.5)
				tile = new TileOrangeA();
				else
				tile = new TileGreenA();
				
				tile.side = "right";
				tile.leader = GameData.arrRoadTilesR[0];
				_isAlternateTerrainR = true;
				GameData.arrRoadTilesR.unshift(tile);
			}
			else
			{
				if(_distanceCount <= 10.5)
				tile = new TileOrangeB();
				else
				tile = new TileGreenB();

				tile.side = "right";
				tile.leader = GameData.arrRoadTilesR[0];
				_isAlternateTerrainR = false;
				GameData.arrRoadTilesR.unshift(tile);
			}
			
			_layerTerrainRight.addChildAt(tile, 0);
		}
		
		tile.x = _x;
		tile.y = _y;
		
		tile.activate();
		_distanceCount += .5;
		
		GameData.currDistance = _distanceCount;
		_oHud.oDistanceHud.update();	
		
		if (_distanceCount % 1 == 0)
		{
			GameData.currDistance = _distanceCount;
			_oHud.oDistanceHud.update();	
		}
		
		
		if (_distanceCount % 10 == 0)
		GameData.showRoadSign = true;	
		
		if (GameData.currentSpeed <= PublicSettings.MAX_SPEED)
		{
			if (_distanceCount % 10 == 0)
			GameData.currentSpeed += .5;
		}
		
		}
		
		private function resetRoad():void 
		{
			roadHolder.x = -_xOffset;
			roadHolder.y = AppData.deviceResY + _yOffset;
						
			//roadHolder.x = -200//-_xOffset;
			//roadHolder.y = 3000//AppData.deviceResY + _yOffset;
			
			//remove last tiles and create new ones
		}

		//------------------------------------------o
		//-- Start Game Play
		//------------------------------------------o
		private function startGameplay():void 
		{
			
		}
		
// This can be done faster but this is to show you how it works.
    public function moveObject(obj:Sprite, targetPT:Point):void
    {
		
		var speed:Number = .1;
        // We start by getting the distances along the x and y axis
        var dx:Number = targetPT.x - obj.x;
        var dy:Number = targetPT.y - obj.y;

        // Basic distance check with pythagorean theorem. We don't need
        // to get the Square Roots because if it is smaller squared it
        // will still be smaller once we get the square roots and thus
        // will just be a waste of time.
/*        if (dx * dx + dy * dy < speed * speed)
        {
            // Since we are within one time step of speed we will go past it
            // if we keep going so just lock the position in place.
            obj.x = targetPT.x;
            obj.y = targetPT.y;
        }*/
       // else
       // {
            // we aren't there yet so lets rock.

            // get the angle in radians given the distance along the x and y axis.
            var angleRads:Number = Math.atan2(dy, dx);
          
            // get our velocity along the x and y axis
            // NOTE: remember how the flash coordinate system is laid out.
            // we need to calc cos along the x and sin along the y.
            var vx:Number = Math.cos(angleRads) * speed;
            var vy:Number = Math.sin(angleRads) * speed;

            // now that we have our speeds we can add it to the objects 
            // current position and thus create a nice smooth movement per
            // frame.
            obj.x += vx;
            obj.y += vy;

            // This will lock the rotation of the object to the direction
            // the object is traveling in.
            // NOTE: don't forget when you make your objects that for flash
            // rotation of Zero = pointing to the right (+x)
            obj.rotation = angleRads * 180 / Math.PI;
        //}
    }

		//=========================================o
		//-- pause game
		//=========================================o
		public function pause():void
		{
/*			core.controlBus.powerupController.pausePowerup();
			AppData.isFreezePlay = true;
			GameData.isGameInPlay = false;
			_oPlayer.isMovable = false;
			AppData.isBoosting = false;*/

		}
		
		//=========================================o
		//-- unpause game
		//=========================================o
		public function unpause():void
		{
/*			core.controlBus.powerupController.resumePowerup();
			AppData.isFreezePlay = false;
			GameData.isGameInPlay = true;
			_oPlayer.isMovable = true;
			AppData.isBoosting = false;
			_oPlayer.stopBoost()*/
			
		}		
		
		public function stopBoost():void 
		{
/*			AppData.isBoosting = false;
			AppData.currSpeed = _currBaseSpeed;

			if(Sounds.currentMusic != null)
			SoundAS.fadeFrom(Sounds.currentMusic, .5, 1, 200)
					
			_moveOffset = _moveOffsetNorm;
			_mouseSpeed = _mouseSpeedNorm;
			_oPlayer.stopBoost();
			_oBackground.stopBoostFlash();
			hideSpeedLined();
					
			resetAfterShake();
			
			_isThrusting = false;
					
			SoundAS.getSound(Sounds.THURST_LOOP).stop();
			
			if(Sounds.currentWindLoop != null)
			SoundAS.getSound(Sounds.currentWindLoop).stop();	*/
			
		}
		
		private function shake(minNum:Number, maxNum:Number):void 
		{
			_layerHUD.x = Math.random() * (maxNum - minNum + 1)
			_layerHUD.y = Math.random() * (maxNum - minNum + 1)
						
			_layerAction.x = Math.random() * (maxNum - minNum + 1)
			_layerAction.y = Math.random() * (maxNum - minNum + 1)
			
		}
		
		private function resetAfterShake():void 
		{
			_layerHUD.x = 0
			_layerHUD.y = 0
			_layerAction.x = 0
			_layerAction.y = 0
		}
		
		

		//------------------------------------o
		//-- Enter Frame - Main Game Loop
		//------------------------------------o
		private function update_gameLoop(e:Event):void 
		{
			
			if(AppData.isFreezePlay)
			return;
			
			if (GameData.isGameInPlay)
			{
				
				//_iGenCount++;
				//trace("_iGenCount :" + _iGenCount);
				if (AppData.isBoosting) 
				{
					

				}
				//if Not boosting
				else 
				{

				}
				
				_iDistCount++;
				

				
				if (_iDistCount >= _iDistCap)
				{

						
				}
					
				
				

				core.animationJuggler.advanceTime(.02);
			};
				//_oPlayer.onUpdate();
				//_oForeground.onUpdate();
		}
		
		
		//=======================================o
		//-- Generate Map item
		//=======================================o
		public function generate():void 
		{
			

			
		}


		//=======================================o
		//-- OVERRIDE - Trash/Dispose/Kill/Anihliate
		//=======================================o	
		public override function trash():void
		{
			trace(this + "trash()");
			
			SoundAS.stopAll();
		    this.removeEventListeners();
			
			TweenMax.killAll();
			
			//trashActionObjects();
			
			//core.controlBus.powerupController.stopALLPowerupTimers();
		    //core.controlBus.powerupController.trash();
	  	    //core.controlBus.gameHUDController.trash();
			//core.controlBus.mapsController.trash();
			
			//_oPlayer.trash();
			_oBackground.trash();
			
			this.removeFromParent();
			
		}
		
		//========================================o
		//-- player die, last life taken, start land
		//========================================o
		public function endGame():void
		{
			trace(this + "endGame()");
			
			 GameData.isGameInPlay = false;
			 
			 deactivateActionObjects();

		}
		
		
		//========================================o
		//-- Deactivates Action Objects, with optional exceptions
		//--  except([ClassName])
		//========================================o	
		public function deactivateActionObjects(except:Array = null, callback:Function = null):void 
		{
/*			var type:Class;
			var lngth:int = AppData.arrActionObjects.length;
			
			while (AppData.arrActionObjects.length > 0) 
			{
				trace("deactivateActionObjects" +  AppData.arrActionObjects.length);
				var obj:Sprite = Sprite(AppData.arrActionObjects[0]);
				TweenLite.killTweensOf(obj)
				trace("obj :" + obj);
				obj["deactivate"]();
			}
			
			if (callback != null)
			callback();
			
			trace("ObjPool_Coin:" + ObjPool_Coin.pool.length);
			trace("ObjPool_Obstacle:" + ObjPool_Obstacle.pool.length);
			trace("ObjPool_Misc:" + ObjPool_Misc.pool.length);*/
		}
		
		//========================================o
		//-- remove all Action Objects
		//========================================o	
		public function trashActionObjects():void
		{
/*			while (AppData.arrActionObjects.length > 0) 
			{
				var obj:Sprite = Sprite(AppData.arrActionObjects[0]);
				TweenLite.killTweensOf(obj)
				obj["trash"]();
			}
		
			trace("trashActionObjects() completed ActionObjects array is now:" + AppData.arrActionObjects);*/
		}

		
		//========================================o
		//-- COLLISION
		//========================================o	
		public function doCollision(type:String = null):void 
		{
			if (!_oCar.isGrounded)
			return;
			
			if (type == Obstacle.TYPE_OIL_SLICK)
			{
				_oCar.doSlide();
			}
			if (type == Obstacle.TYPE_SPEED_HUMP)
			{
				_oCar.doJump();
			}
			else
			{
			//GameData.isGameInPlay = false;
			GameData.currentSpeed = 0;
			}
			
			//StarlingUtil.shake(_layerAction, 1000, 30, 10);
			//core.controlBus.gameHUDController.shake(1000);	
		
		}
		
		//========================================o
		//-- ITEM COLLECTED
		//========================================o	
		public function onItemCollected(type:String):void 
		{
			if (type == Collectable.TYPE_NITRO)
			{
				_oCar.doNitro();
			}
			else if (type == Collectable.TYPE_MAGNET)
			{
				_oCar.doMagnet();
			}
			else if (type == Collectable.TYPE_COIN)
			{
				GameData.currCoins ++;
				_oHud.oCoinHud.update();	
			}
		}
		

		//========================================o	
		//------ Getters and Setters 
		//========================================o				

		
	}

		
	
	
}