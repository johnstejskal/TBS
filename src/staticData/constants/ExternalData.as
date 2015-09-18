package staticData.constants 
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
	 
	public class ExternalData 
	{

		//Texture Atlas/ Sprite Sheet
		
		//-------------------------------------------o
		//-------------------------o Tree's list
		//-------------------------------------------o
		[Embed(source = "../../../bin/lib/json/tree-list.json", mimeType="application/octet-stream")]
		public static var TreeList:Class; 		
					
		//-------------------------------------------o
		//-------------------------o Ore list
		//-------------------------------------------o
		[Embed(source = "../../../bin/lib/json/ore-list.json", mimeType="application/octet-stream")]
		public static var OreList:Class; 		
				
		//-------------------------------------------o
		//-------------------------o Metals list
		//-------------------------------------------o
		[Embed(source = "../../../bin/lib/json/metal-list.json", mimeType="application/octet-stream")]
		public static var MetalsList:Class; 		
		
	}

}