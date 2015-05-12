package staticData.dataObjects 
{
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PrizeData 
	{

		static public var objPrizeMasterList:Object;
		static public var arrPrizeMasterList:Array = [];
		
		//Time stamp the data
		static public var lastRetrieved_masterList:Date;

		
		static public var objPrizeUserList:Object;
		static public var arrPrizeUserList:Array = [];
		
		//Time stamp the data
		static public var lastRetrieved_userList:Date;
		
		static public function reset():void 
		{

		}
		
		//===============================================o
		//-- Convert Array TO Object
		//===============================================o
/*		public function convertToObject():Object
		{
			var data:Object = new Object();
			
			var arr:Array = getClassVariables(this, AccessorType.NONE);
			
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				if ( arr[i] == "company" )
				{
					data.company = this.company.convertToObject();
				}
				else
				{
					data[ arr[i] ] = this[ arr[i] ];
				}
			}
			
			var data2:Object = new Object();
			for ( i = 0; i < arr.length; i++ )
			{
				if ( arr[i] == "company" )
				{
					CompressionController.recordToObject( data2, "PlayerData", arr[i], this.company.convertToObject() );
				}
				else
				{
					CompressionController.recordToObject( data2, "PlayerData", arr[i], this[arr[i]] );
				}
			}
			
			trace( JSON.stringify(data2) );
			
			return data;
		}
		
		public function convertFromObject( data:Object ):void
		{
			var arr:Array = getClassVariables(this, AccessorType.NONE);
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				if ( arr[i] == "company" )
				{
					this.company.convertFromObject( data.company );
				}
				else
				{
					this[ arr[i] ] = data[ arr[i] ];
				}
			}
		}*/

		
	}

}