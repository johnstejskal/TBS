package staticData 
{
	import flash.utils.ByteArray;


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	 
	 /*
	  * Store all the Sprite sheet referencing info here to be passed into the AssetManager
	  * 
	  */
	 
	public class XMLData 
	{

		//Texture Atlas/ Sprite Sheet
		
		//-------------------------------------------o
		//-------------------------o Achievement list
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/achievements-au.json", mimeType="application/octet-stream")]
		public static var AchievementList_AU:Class; 		
				
		//-------------------------------------------o
		//-------------------------o Achievement list NZ
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/achievements-nz.json", mimeType="application/octet-stream")]
		public static var AchievementList_NZ:Class; 		
		
		//-------------------------------------------o
		//-------------------------o local Stores xml Embed
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/store-list-au.json", mimeType="application/octet-stream")]
		public static var StoresList_AU:Class; 
		
		//-------------------------------------------o
		//-------------------------o local Stores xml Embed
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/store-list-nz.json", mimeType="application/octet-stream")]
		public static var StoresList_NZ:Class; 
		
		//-------------------------------------------o
		//-------------------------o Labels data
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/labels_au.json", mimeType="application/octet-stream")]
		public static var Labels_AU:Class; 
		
		//-------------------------------------------o
		//-------------------------o Labels data
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/json/labels_nz.json", mimeType="application/octet-stream")]
		public static var Labels_NZ:Class; 

		//-------------------------------------------o
		//-------------------------o game Shop items xml
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/xml/shop-items-au.xml", mimeType="application/octet-stream")]
		public static var ShopItemList_AU:Class; 
			
		//-------------------------------------------o
		//-------------------------o game Shop items xml
		//-------------------------------------------o
/*		[Embed(source = "../../bin/lib/xml/shop-items-nz.xml", mimeType="application/octet-stream")]
		public static var ShopItemList_NZ:Class; 
		*/											
		//-------------------------------------------o
		//-------------------------o swear filter
		//-------------------------------------------o
		[Embed(source = "../../bin/lib/txt/badwords.txt", mimeType="application/octet-stream")]
		public static var BadWords:Class; 
													

	}

}