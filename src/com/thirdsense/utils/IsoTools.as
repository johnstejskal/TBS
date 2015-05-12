package com.thirdsense.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.thirdsense.utils.Trig;
	
	/**
	 * Isometric Tools for use with game design
	 * @author Ben Leffler
	 */
	
	public class IsoTools 
	{
		
		// ==============================================================================================
		
		/**
		 * Sorts the depth of all children in a display object container based on isometric principals (y position, then x position);
		 * @param	container	Display object container housing the display objects that are to be sorted.
		 * @param	excludeClipsWithProperty	If a display object is to be excluded from the sort function, it should contain a property named as per this parameter and it must not equal 0, null or void.
		 */
		
		public static function sortIsometricDepth( container:DisplayObjectContainer, excludeClipsWithProperty:String="" ):void
		{
			var children:int = container.numChildren;
			var siblings:Vector.<Object> = new Vector.<Object>;
			
			for ( var i:uint = 0; i < children; i++ ) {
				
				if ( excludeClipsWithProperty != "" ) {
					var mc:MovieClip = container.getChildAt(i) as MovieClip;
					if ( !mc[excludeClipsWithProperty] ) {
						var dispObj:DisplayObject = container.getChildAt(i);
					} else {
						continue;
					}
				} else {
					dispObj = container.getChildAt(i);
				}
				var sibling_data:Object = {
					mc:dispObj,
					x:dispObj.x,
					y:dispObj.y
				};
				siblings.push( sibling_data );
			}
			
			siblings.sort( sortFn );
			
			for ( i = 0; i < siblings.length; i++ ) {
				container.setChildIndex( siblings[i].mc, i );
			}
			
			function sortFn( o1:*, o2:* ):Number
			{
				if ( o1.y > o2.y ) {
					return 1;
				} else if ( o1.y < o2.y ) {
					return -1;
				} else {
					
					if ( o1.x > o2.x ) {
						return 1;
					} else if ( o1.x < o2.x ) {
						return -1;
					} else {
						return 0;
					}
				}
			}
			
		}
		
		
		// ==============================================================================================
		
		/**
		 * Converts an X and a Y co-ordinate to an Isometric co-ordinate (assuming a 45 degree clockwise rotation of the 2D space making {x:0, y:0} the upper-most isometric point)
		 * @param	xpos	X co-ordinate to convert
		 * @param	ypos	Y co-ordinate to convert
		 * @return	Top-down 2D co-ordinate converted to an Isometric Point
		 */
		
		public static function toIsometric(xpos:Number, ypos:Number, pt:Point = null ):Point 
		{
			// Converts a top down co-ordinate to an isometric co-ordinate (rotating clockwise)
			
			if (!xpos && !ypos) {
				if ( !pt )
				{
					return new Point(0, 0);
				}
				else
				{
					pt.x = 0;
					pt.y = 0;
					return pt;
				}
			}
			
			var origin:Point = new Point(0, 0);
			var destin:Point = new Point(xpos, ypos);
			
			var dist:Number = Trig.findDistance(destin, origin);
			var ang:Number = Trig.findAngle(destin, origin) + 45;
			
			destin = Trig.findPoint(ang, dist);
			destin.y /= 2;
			
			if ( pt )
			{
				pt.x = destin.x;
				pt.y = destin.y;
				return pt;
			}
			
			return destin;
			
		}
		
		// ===============================================================================================
		
		/**
		 * Converts and X and Y co-ordinate from an Isometric plane to a regular grid( rotating 45 degrees counter-clockwise )
		 * @param	iso_x	X isometric co-ordinate to convert
		 * @param	iso_y	Y isometric co-ordinate to convert
		 * @return	Regular x,y co-ordinate converted from an Isometric plane.
		 */
		
		public static function fromIsometric( iso_x:Number, iso_y:Number):Point
		{
			if (!iso_x && !iso_y) {
				return new Point(0,0);
			}
			
			iso_y *= 2;
			
			var origin:Point = new Point(0, 0);
			var destin:Point = new Point(iso_x, iso_y);
			
			var dist:Number = Trig.findDistance( destin, origin );
			var ang:Number = Trig.findAngle( destin, origin ) - 45;
			
			destin = Trig.findPoint(ang, dist);
			
			return destin;
			
		}
		
		
	}

}