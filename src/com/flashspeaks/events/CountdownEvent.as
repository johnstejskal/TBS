package com.flashspeaks.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Angel Romero
	 */
	public class CountdownEvent extends Event 
	{
		public static const COUNTDOWN_UPDATE:String = "countdownUpdate";
		public static const COUNTDOWN_COMPLETE:String = "countdownComplete";
		
		public function CountdownEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new CountdownEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CountdownEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
}