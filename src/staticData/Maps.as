package staticData 
{
	/**
	 * ...
	 * @author jhn
	 */
	public class Maps 
	{
		
		public function Maps() 
		{
			
		}
	
		
		static public const O:String = "o";	    //oblank
		
		static public const O1:String = "o1";	//obstacle 1 - 	oil Spill
		static public const O2:String = "o2";	//obstacle 2 - 	pot Hole
		static public const O3:String = "o3";	//obstacle 2 - 	short ditch
		static public const O4:String = "o4";	//obstacle 2 - 	long ditch
		static public const O5:String = "o5";	//obstacle 2 - 	speed hump
		
		
		static public const C1:String = "c1";	//Collectable 1 - Coin 1
		static public const C2:String = "c2";	//Collectable 1 - Coin Stack
		static public const C3:String = "c3";	//Collectable 1 - Magnet
		static public const C4:String = "c4";	//Collectable 1 - Nitro
		/*
		public static var MAP:Array = [[O3, O, O, O3],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O, O2, O, O],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O, O1, O, O],
									   [O, O, O, O],
									   [C1, O, O, O],
									   [C1, O, O, O],
									   [C1, O, O, O],
									   [C1, O, O2, O],
									   [C1, O, O, O],
									   [C1, O, O, O],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O4, C1, O, O],
									   [O, C1, O, O2],
									   [O, C1, O, O],
									   [O, C1, O, O],
									   [O, C1, O, O],
									   [O, O, O, O],
									   [O, O1, O, O],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O, O, O2, O],
									   [O, O, O, O],
									   [O, O, O, O],
									   [O, O, O, O]]
		*/							   
								
		public static var MAP:Array = [[C1, O5, C1, C1],
									   [C1, C1, C1, C1],
									   [C1,C1, C1, C1],
									   [C1, C1, C1, C1],
									   [O, O, O, O],
									   [O, O, O, C3],
									   [O, O, O, O],
									   [O, C1, O, O]
									   ]
									   
									   
									   
									   
		
	}

}