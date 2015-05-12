package ManagerClasses 
{
	import com.johnstejskal.keyboard.KeyObject;
	import com.johnstejskal.keyboard.StarlingKeyObject;
	import singleton.Core;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class KeyboardManager 
	{
		
		private var _core:Core;
		
		private var _key:KeyObject;
		
		private var _isLeftPress:Boolean = false;
		private var _isRightPress:Boolean = false;
		private var _isUpPress:Boolean = false;
		private var _isDownPress:Boolean = false;
		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function KeyboardManager() 
		{
			_core = Core.getInstance();
			
			
			
		}
		
		public function init():void
		{
			_key = new KeyObject(_core.main.stage)
			if (_key.isDown(_key.LEFT)) { 
				_isLeftPress = true;}else{_isLeftPress = false}
			
			if (_key.isDown(_key.RIGHT)) { 
				_isRightPress = true; } else { _isRightPress = false }	
				
				
			
		}
		
		public function get isLeftPress():Boolean 
		{
			return _isLeftPress;
		}
		
		public function get isRightPress():Boolean 
		{
			return _isRightPress;
		}
		
		

		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o	
		
		
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o		
		
	}

}