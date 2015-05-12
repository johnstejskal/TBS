package com.thirdsense.ui.starling 
{
	import com.thirdsense.utils.Trig;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Ben Leffler
	 */
	public class MultiTouchControl 
	{
		private var zoomTouches:Array;
		private var onZoomStart:Function;
		private var onZoom:Function;
		private var onZoomEnd:Function;
		private var touch_counter:int;
		private var touches:Vector.<Touch>;
		private var interacting:Boolean;
		
		public function MultiTouchControl() 
		{
			
		}
		
		public function startZoom( onStart:Function, onZoom:Function, onEnd:Function = null ):void
		{
			this.zoomTouches = [ null, null ];
			this.onZoomEnd = onEnd;
			this.onZoomStart = onStart;
			this.onZoom = onZoom;
			this.touch_counter = 0;
			this.interacting = false;
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, this.zoomHandler);
			Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, this.enterFrameHandler);
		}
		
		private function zoomHandler(e:TouchEvent):void 
		{
			if ( !touches )
			{
				touches = new Vector.<Touch>;
			}
			else
			{
				while ( touches.length )
				{
					touches.shift();
				}
			}
			
			touches = e.getTouches( Starling.current.stage );
			
			if ( touches && touches.length )
			{
				var end_flag:Boolean = false;
				
				for ( var i:uint = 0; i < touches.length; i++ )
				{
					var touch:Touch = touches[i];
					
					if ( touch.phase == TouchPhase.HOVER ) continue;
					if ( touch.phase == TouchPhase.BEGAN )
					{
						var obj:Object = { id:touch.id, opt:new Point(touch.globalX, touch.globalY), cpt:null };
						if ( !this.zoomTouches[0] )
						{
							this.zoomTouches[0] = obj;
							if ( this.zoomTouches[1] ) this.touch_counter = 2;
						}
						else if ( !this.zoomTouches[1] )
						{
							this.zoomTouches[1] = obj;
							if ( this.zoomTouches[0] ) this.touch_counter = 2;
						}
						
						if ( this.zooming )
						{
							this.onZoomStart(); 
						}
					}
					
					if ( touch.phase == TouchPhase.MOVED )
					{
						if ( this.zoomTouches[0] && this.zoomTouches[0].id == touch.id ) this.zoomTouches[0].cpt = new Point(touch.globalX, touch.globalY);
						else if ( this.zoomTouches[1] && this.zoomTouches[1].id == touch.id ) this.zoomTouches[1].cpt = new Point(touch.globalX, touch.globalY);
						
						if ( touches.length > 1 )
						{
							this.interacting = true;
						}
					}
					
					if ( touch.phase == TouchPhase.ENDED )
					{
						var tid:int = -1;
						
						if ( this.zoomTouches[0] && this.zoomTouches[0].id == touch.id )
						{
							tid = 0;
						}
						else if ( this.zoomTouches[1] && this.zoomTouches[1].id == touch.id )
						{
							tid = 1;
						}
						if ( tid >= 0 && this.zoomTouches[0] && this.zoomTouches[1] )
						{
							end_flag = true;
						}
						
						this.zoomTouches[tid] = null;
						
						if ( !this.zoomTouches[0] && !this.zoomTouches[1] )
						{
							this.touch_counter = 0;
						}
						
						if ( end_flag && this.onZoomEnd != null )
						{
							//this.onZoomEnd();
						}
					}
				}
				
			}
		}
		
		private function enterFrameHandler():void
		{
			if ( this.zoomTouches[0] && this.zoomTouches[1] && this.zoomTouches[0].cpt && this.zoomTouches[1].cpt )
			{
				var dist1:Number = Trig.findDistance( this.zoomTouches[0].opt, this.zoomTouches[1].opt );
				var dist2:Number = Trig.findDistance( this.zoomTouches[0].cpt, this.zoomTouches[1].cpt );
				
				if ( onZoom.length == 1 )
				{
					this.onZoom( dist2 / dist1 );
				}
				else if ( onZoom.length == 2 )
				{
					var pt:Point = new Point();
					pt.x = this.zoomTouches[0].opt.x + (this.zoomTouches[1].opt.x - this.zoomTouches[0].opt.x >> 1);
					pt.y = this.zoomTouches[0].opt.y + (this.zoomTouches[1].opt.y - this.zoomTouches[0].opt.y >> 1);
					this.onZoom( dist2 / dist1, pt );
				}
				else if ( onZoom.length == 3 )
				{
					this.onZoom( dist2 / dist1, this.zoomTouches[0].opt, this.zoomTouches[1].opt );
				}
			}
			
			if ( this.onZoomEnd != null && interacting && touches )
			{
				var valid:Boolean = true;
				var at_least_one_ended:Boolean = false;
				for ( var i:int = 0; i < touches.length; i++ )
				{
					if ( touches[i].phase != TouchPhase.HOVER && touches[i].phase != TouchPhase.ENDED )
					{
						valid = false;
					}
					else if ( touches[i].phase == TouchPhase.ENDED || (touches.length == 1 && touches[i].phase == TouchPhase.HOVER) )
					{
						at_least_one_ended = true;
					}
				}
				
				//trace( touches, valid, at_least_one_ended );
				
				if ( valid && at_least_one_ended )
				{
					interacting = false;
					this.onZoomEnd();
				}
			}
		}
		
		public function get zooming():Boolean
		{
			if ( (this.zoomTouches[0] && this.zoomTouches[1]) || this.touch_counter >= 2 ) return true;
			return false;
		}
		
		public function kill():void
		{
			var stage:Stage = Starling.current.stage;
			stage.removeEventListener(TouchEvent.TOUCH, this.zoomHandler);
			stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		}
		
	}

}