package com.thirdsense.data 
{
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	import com.thirdsense.utils.StringTools;
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * <p>LaunchPad shared object scaffold for locally stored app data. Data storage requirements differ on a project-by-project basis, so a typical implementation would
	 * see a developer creating an extension class for this LPLocalData class</p>
	 * 
	 * <p>Firstly a user will create a custom class that extends this LPLocalData class. Each variable will need to be made public.</p>
	 * 
	 * <listing>
	 * package classes {
	 * import com.thirdsense.data.LPLocalData;
	 * 
	 * 	public class AppData extends LPLocalData {
	 * 
	 * 		public var myVar1:String;
	 * 		public var myVar2:Number;
	 * 		public var myVar3:Array;
	 * 
	 * 		public function AppData() {
	 * 
	 * 		}
	 * 	}
	 * }</listing>
	 * 
	 * <p>Next, you will need to register this class for use with the framework from somewhere within the project (a good place would be in your root project class)</p>
	 * 
	 * <listing>
	 * import classes.AppData;
	 * 
	 * var appdata:AppData = LPLocalData.registerClass( AppData );</listing>
	 * 
	 * <p>If you have saved to local data previously, the appdata object above will be auto-populated with the appropriate values. You can retrieve these values as follows:</p>
	 * 
	 * <listing>
	 * // I can reference these values directly like this:
	 * 
	 * trace( appdata.myVar1, appdata.myVar2, appdata.myVar3 );
	 * 
	 * // Or I can call a static reference from anywhere in my project like this:
	 * 
	 * trace( LPLocalData.retrieve("myVar1"), LPLocalData.retrieve("myVar2"), LPLocalData.retrieve("myVar3") );</listing>
	 * 
	 * <p>If you want to save new values to local data, you can do it as follows:</p>
	 * 
	 * <listing>
	 * // I can record new data to a local shared object like this:
	 * 
	 * LpLocalData.record( "myVar1", "My new data" );
	 * LPLocalData.record( "myVar2", 1234567890 );
	 * LPLocalData.record( "myVar3", ["My", "New", "Data"] );</listing>
	 * 
	 * <p>Alternatively you can make a batch record call if you have multiple variables that need recording:</p>
	 * 
	 * <listing>
	 * var appdata:AppData = LPLocalData.getInstance();
	 * appdata.myVar1 = "My newer data";
	 * appdata.myVar2 = 987654321;
	 * appdata.myVar3 = [ "My", "Newer", "Data" ];
	 * LPLocalData.recordAll();</listing>
	 * 
	 * <p>You can also retrieve a timestamp of when a data packet was saved to a local shared object like this:</p>
	 * 
	 * <listing>
	 * var time:Number = LPLocalData.getTimestamp( "myVar1" );</listing>
	 * 
	 * <p>You can even retrieve how much time (in milliseconds) has elapsed since the last save on a variable</p>
	 * 
	 * <listing>
	 * var elapsed:Number = LPLocalData.getTimeSinceSave( "myVar1" );</listing>
	 * 
	 * @author Ben Leffler
	 */
	
	public class LPLocalData extends Object
	{
		private var timestamps:Object;
		
		private static var instance:LPLocalData;
		
		/**
		 * The constructor for this scaffold. It's best practise for your app to extend this class with it's own variable structure, and to register that class with 
		 * a call to LPLocalData.registerClass()
		 */
		
		public function LPLocalData() 
		{
			
		}
		
		/**
		 * @private
		 */
		
		private function retrieveLocal():void
		{
			var so:SharedObject = SharedObject.getLocal( escape(LPSettings.APP_NAME) );
			
			if ( so && so.data.lp )
			{
				this.fromObject( so.data.lp );
				this.timestamps = so.data.timestamps;
			}
			else
			{
				so.data.lp = this.toObject();
				so.data.timestamps = this.timestamps;
				so.flush();
			}
			
		}
		
		/**
		 * @private
		 */
		
		private function toObject():Object
		{
			var arr:Array = getClassVariables( this, AccessorType.READ_WRITE );
			
			var obj:Object = new Object();			
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				obj[ arr[i] ] = this[ arr[i] ];
			}
			
			return obj;
		}
		
		/**
		 * @private
		 */
		
		private function fromObject( obj:Object ):void
		{
			for ( var str:String in obj )
			{
				this[str] = obj[str];
			}
		}
		
		/**
		 * Records a variable to the app local shared object
		 * @param	name	The name of the variable to save. It must be available as a var within your class that extends the LPLocalData class
		 * @param	value	The value of the variable
		 */
		
		private function record( name:String, value:* ):void
		{
			this[name] = value;
			this.timestamps[name] = new Date().getTime();
			
			var so:SharedObject = SharedObject.getLocal( escape(LPSettings.APP_NAME) );
			
			if ( so && so.data && !so.data.lp )
			{
				so.data.lp = new Object();
			}
			if ( so && so.data && !so.data.timestamps )
			{
				so.data.timestamps = new Object();
			}
			if ( so && so.data && so.data.lp && so.data.timestamps )
			{
				so.data.lp[name] = value;
				so.data.timestamps[name] = this.timestamps[name];
				so.flush();
			}
			
		}
		
		/**
		 * Records all data in this object to the locally stored object
		 */
		
		private function recordAll():void
		{
			for ( var str:String in this.timestamps )
			{
				this.timestamps[str] = new Date().getTime();
			}
			
			var so:SharedObject = SharedObject.getLocal( escape(LPSettings.APP_NAME) );
			so.data.lp = this.toObject();
			so.data.timestamps = this.timestamps;
			so.flush();
		}
		
		/**
		 * Retrieves a timestamp for when the designated variable was saved to the local shared object
		 * @param	name	The name of the variable to check.
		 * @return	The number of milliseconds representation of the Date object
		 */
		
		private function getTimestamp( name:String ):Number
		{
			if ( this.timestamps && this.timestamps[name] )
			{
				return this.timestamps[name];
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Deletes the app's local shared object, this object's variable values and associated timestamp data
		 */
		
		private function deleteAll():void
		{
			var arr:Array = getClassVariables(this, AccessorType.READ_WRITE);
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				this[ arr[i] ] = null;
			}
			
			this.timestamps = new Object();
			
			var so:SharedObject = SharedObject.getLocal( escape(LPSettings.APP_NAME) );
			so.clear();
		}
		
		/**
		 * @private
		 */
		
		public function toString():String
		{
			return StringTools.toString( this );
		}
		
		/**
		 * Gets the number of milliseconds that have elapsed since the designated variable was saved to a local shared object
		 * @param	name	The name of the variable to check
		 * @return	The number of milliseconds since the object was saved locally
		 */
		
		private function getTimeSinceSave( name:String="" ):Number
		{
			var ms:Number = this.getTimestamp( name );
			var current_ms:Number = new Date().getTime();
			return current_ms - ms;
		}
		
		/**
		 * Deletes the all of the app's locally shared data, the instance object's variable values and associated timestamp data
		 */
		
		public static function deleteData():void
		{
			if ( instance )
			{
				instance.deleteAll();
			}
			else
			{
				var so:SharedObject = SharedObject.getLocal( escape(LPSettings.APP_NAME) );
				so.clear();
			}
		}
		
		/**
		 * Records a variable to the app local shared object
		 * @param	name	The name of the variable to save. It must be available as a var within your class that extends the LPLocalData class
		 * @param	value	The value of the variable
		 */
		
		public static function record( name:String, value:* ):void
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You must register an extended LPLocalData class before you can call LPLocalData.record()" );
			}
			else
			{
				instance.record( name, value );
			}
		}
		
		/**
		 * Records all variables in the registered class instance to the local shared object
		 */
		
		public static function recordAll():void
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You must register an extended LPLocalData class before you can call LPLocalData.recordAll()" );
			}
			else
			{
				instance.recordAll();
			}
		}
		
		/**
		 * Retrieves a timestamp for when the designated variable was saved to the local shared object
		 * @param	name	The name of the variable to check.
		 * @return	The number of milliseconds representation of the Date object
		 */
		
		public static function getTimestamp( name:String ):Number
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You must register an extended LPLocalData class before you can call LPLocalData.getTimestamp()" );
				return 0;
			}
			else
			{
				return instance.getTimestamp( name );
			}
		}
		
		/**
		 * Gets the number of milliseconds that have elapsed since the designated variable was saved to a local shared object
		 * @param	name	The name of the variable to check
		 * @return	The number of milliseconds since the object was saved locally
		 */
		
		public static function getTimeSinceSave( name:String ):Number
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You must register an extended LPLocalData class before you can call LPLocalData.getTimeSinceSave()" );
				return 0;
			}
			else
			{
				return instance.getTimeSinceSave( name );
			}
		}
		
		/**
		 * Registers the app specific class that extends a LPLocalData object. Only one class can be registered per app.
		 * @param	extended_class	The class that extends a LPLocalData object to use as the local data interface.
		 * @return	The resulting instance of the class that extends the LPLocalData object
		 */
		
		public static function registerClass( extended_class:Class ):*
		{
			var super_class:String = getQualifiedSuperclassName(extended_class);
			var class_name:String = getQualifiedClassName(extended_class);
			var split:Array = class_name.split("::");
			class_name = split[split.length - 1];
			
			if ( super_class.split("::")[1] != "LPLocalData" )
			{
				trace( "LaunchPad", LPLocalData, "Call to LPLocalData.registerClass() failed! '" + class_name + "' is not an extended branch of the LPLocalData class" );
				return null;
			}
			
			instance = new extended_class();
			instance.timestamps = new Object();
			instance.retrieveLocal();
			
			return instance;
		}
		
		/**
		 * Retrieves the value of a given variable within the locally saved data
		 * @param	name	The name of the variable to retrieve
		 * @return	The value of the variable
		 */
		
		public static function retrieve( name:String ):*
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You must register an extended LPLocalData class before you can call LPLocalData.retrieve()" );
				return null;
			}
			else
			{
				return instance[name];
			}
		}
		
		/**
		 * Retrieves the singleton instance of the class that was registered
		 * @return	The result instance of the class that extends the LPLocalData object
		 */
		
		public static function getInstance():*
		{
			if ( !instance )
			{
				trace( "LaunchPad", LPLocalData, "You have not registered an extended LPLocalData class. Returning null for your call to LPLocalData.getInstance()" );
				return null;
			}
			else
			{
				return instance;
			}
		}
	}

}