package staticData.dataObjects 
{

	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	import com.thirdsense.utils.StringTools;
	import com.thirdsense.utils.Trig;
	import flash.display.MovieClip;
	import starling.display.Image;
	/**
	 * ...
	 * @author Ben Leffler
	 */
	
	public class ShopItems 
	{
		public var name:String = "My Company Inc.";
		private var _capital:Number = 20000000;
		public var defence_points:int;
		public var level:int;
		public var mood:Number;
		public var sector:String = "";
		public var primary_sector:String;
		public var history:CompanyHistory;
		public var base_value:Number;
		private var _avatar_dna:AvatarDNA;
		public var ceo_name:String;
		public var year:int = 0;
		public var quarter:int = 0;
		public var isBoss:Boolean = false;
		public var hasTaunted:Boolean = false;
		public var xp:Number = 0;
		public var rank:Number = 0;
		public var listed_price:Number = 0;
		public var listed_quarters:int = 0;
		public var from_merger:Boolean = false;
		
		private var ceo_skills:Array;
		
		public function get public_value():Number	{	return this.history.getLastPublicValue()	};
		public function get actual_value():Number	{	return this.history.getLastActualValue()	};
		
		public function ShopItems() 
		{
			this.initSkills();
		}
		
		public function convertToObject():Object
		{
			var data:Object = new Object();
			var arr:Array = getClassVariables( this, AccessorType.NONE );
			
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				if ( arr[i] == "history" )
				{
					if ( this.history )
					{
						data.history = this.history.convertToObject();
					}
				}
				else
				{
					data[ arr[i] ] = this[ arr[i] ];
				}
			}
			
			data.capital = this.capital;
			data.avatar_dna_string = this.avatar_dna.toDNAString();
			data.ceo_skills = this.ceo_skills;
			
			return data;
		}
		
		public function processEndOfQuarter():void
		{
			if ( this.listed_price > 0 )
			{
				this.listed_quarters++;
			}
			else
			{
				this.listed_quarters = 0;
			}
			
			PlayerData.getCurrent().company.capital += this.history.getLastProfit() / 4;
			
			this.quarter++;
			if ( this.quarter == 4 )
			{
				this.quarter = 0;
				this.year++;
				this.processEndOfYear();
				this.history.event_multiplier = 1;
			}
			
			//this.history.createIndexVariance();
		}
		
		public function processEndOfYear():void
		{
			CompanyEngineV2.processEndOfYear(this);
		}
		
		public function convertFromObject( data:Object ):void
		{
			for ( var str:String in data )
			{
				if ( str == "history" )
				{
					this.history = new CompanyHistory();
					this.history.convertFromObject( data[str] );
				}
				else if ( str == "avatar_dna_string" )
				{
					this._avatar_dna = new AvatarDNA();
					this._avatar_dna.fromDNAString( data[str] );
				}
				else
				{
					this[str] = data[str];
				}
			}
		}
		
		private function initSkills():void 
		{
			this.ceo_skills = new Array();
			var skill_types:Array = CEOSkills.getAllSkills();
			for ( var i:uint = 0; i < skill_types.length; i++ )
			{
				this.ceo_skills.push( 0 );
			}
		}
		
		public function randomizeSkills( points_to_allocate:int ):void
		{
			var skill_types:Array = CEOSkills.getAllSkills();
			while ( points_to_allocate > 0 )
			{
				this.ceo_skills[ Math.floor(Math.random() * skill_types.length) ]++;
				points_to_allocate--;
			}
		}
		
		public function addToSkillValue( skill:String, amount:int ):void
		{
			var types:Array = CEOSkills.getAllSkills();
			this.ceo_skills[ types.indexOf(skill) ] += amount;
		}
		
		public function getSkillValue( skill:String ):int
		{
			var types:Array = CEOSkills.getAllSkills();
			return this.ceo_skills[ types.indexOf(skill) ];
		}
		
		public function getTotalSkillPointsUsed():int
		{
			var types:Array = CEOSkills.getAllSkills();
			var len:int = types.length;
			var counter:int = 0;
			for ( var i:uint = 0; i < len; i++ )
			{
				counter += this.getSkillValue( types[i] );
			}
			
			return counter;
		}
		
		public function get ceoFirstName():String
		{
			if ( this.isPlayer ) return PlayerData.getCurrent().firstName;
			else return this.ceo_name.substr( 0, ceo_name.indexOf(" ") );
		}
		
		public function get ceoLastName():String
		{
			if ( this.isPlayer ) return PlayerData.getCurrent().lastName;
			else return this.ceo_name.substr( ceo_name.indexOf(" ") + 1 );
		}
		
		public function randomize( sector:String, level:int = 1, boss:Boolean = false ):void
		{
			this.level = Math.min(level, 10);
			this.sector = sector;
			
			this.name = BusinessNames.getCompanyName( this.sector );
			this.avatar_dna = new AvatarDNA();
			if ( Trig.flipCoin() )
			{
				var gender:String = AvatarDNA.GENDER_MALE;
			}
			else
			{
				gender = AvatarDNA.GENDER_FEMALE;
			}
			this.avatar_dna.randomize( gender );
			this.ceo_name = RandomNames.getRandomName( gender, true, true, 1 );
			
			CompanyEngineV2.generate( this, this.level );
			
			var points_to_allocate:int = 6 + this.level;
			this.randomizeSkills( points_to_allocate );
			
			if ( boss )
			{
				this.isBoss = true;
				this.mood *= 0.5;
				if ( !SectorRival.getRival(sector) )
				{
					SectorRival.addRival(this);
				}
			}
			
			if ( this.mood <= 0.33 ) this.avatar_dna.mood = AvatarDNA.MOOD_ANGRY;
			else if ( this.mood <= 0.66 ) this.avatar_dna.mood = AvatarDNA.MOOD_NEUTRAL;
			else this.avatar_dna.mood = AvatarDNA.MOOD_HAPPY;
			
			
		}
		
		public function getAvatarImage( scale:Number = 1 ):Image
		{
			var tp:TexturePack = TexturePack.getTexturePack("Avatar", "circle");
			
			if ( !tp )
			{
				var mc:MovieClip = new MovieClip();
				mc.graphics.beginFill( AppColors.GREEN, 1 );
				mc.graphics.drawCircle( 70, 70, 70 );
				mc.graphics.endFill();
				mc.scaleX = mc.scaleY = AppSettings.scale_width * scale;
				var tp:TexturePack = TexturePack.createFromMovieClip( mc, "Avatar", "circle", null, 0, 0, null, 0 );
			}
			
			return tp.getImage();
		}
		
		public function get staff():int
		{
			return (this.actual_value / 179530) * this.level;
			//return this.history.getLastStaff();
		}
		
		public function get locations():int
		{
			return Math.ceil(this.staff / 100) * this.level;
		}
		
		/**
		 * Checks if this company is the primary player company
		 */
		
		public function get isPlayer():Boolean
		{
			if ( PlayerData.getCurrent() && PlayerData.getCurrent().company == this )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function get avatar_dna():AvatarDNA 
		{
			if ( Portfolio.containsCompany(this) )
			{
				return PlayerData.getCurrent().company.avatar_dna;
			}
			
			return _avatar_dna;
		}
		
		public function set avatar_dna(value:AvatarDNA):void 
		{
			_avatar_dna = value;
		}
		
		public function get capital():Number 
		{
			return _capital;
		}
		
		public function set capital(value:Number):void 
		{
			_capital = Math.max(value, 0);
		}
		
		/**
		 * Returns an array of sectors the player has unlocked
		 * @return
		 */
		
		public function getAvailableSectors():Array
		{
			var arr:Array = SectorRival.getAllBeatenSectors();
			if ( arr.indexOf(this.sector) < 0 )
			{
				arr.push( this.sector );
			}
			
			return arr;
		}
		
		/**
		 * Returns an array of sectors the player is yet to unlock
		 * @return
		 */
		
		public function getUnavailableSectors():Array
		{
			var arr:Array = Sectors.getAllSectors();
			var sectors:Array = this.getAvailableSectors();
			if ( sectors )
			{
				for ( var i:uint = 0; i < sectors.length; i++ )
				{
					arr.splice( arr.indexOf(sectors[i]), 1 );
				}
				return arr;
			}
			else
			{
				return [];
			}
		}
		
		/**
		 * Checks if a specific sector has been unlocked by the player
		 * @param	sector	The sector to check
		 * @return	true if unlocked
		 */
		
		public function checkSectorAvailability( sector:String ):Boolean
		{
			var sectors:Array = this.getAvailableSectors();
			
			if ( sectors && sectors.indexOf(sector) >= 0 )
			{
				return true;
			}
			
			return (this.sector == sector);
		}
		
		/**
		 * Checks if the player is now ready to unlock a new sector
		 * @return
		 */
		
		public function checkSectorUnlockReady():Boolean
		{
			var sectors:Array = this.getAvailableSectors();
			if ( sectors ) return ( sectors.length == SectorRival.getAllBeatenSectors().length );
			else return true;
		}
		
		public function isAffordable():Boolean
		{
			return ( PlayerData.getCurrent().company.capital > this.actual_value * 1.1 && PlayerData.getCurrent().company.capital > this.public_value * 1.1 );
		}
	}

}