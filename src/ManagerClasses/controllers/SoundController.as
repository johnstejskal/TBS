package ManagerClasses.controllers 
{
	import com.johnstejskal.Maths;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.sound.SoundStream;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import ManagerClasses.supers.SuperController;
	import staticData.dataObjects.PlayerData;
	import staticData.LocalDataKeys;
	import staticData.SharedObjectKeys;
	import staticData.SoundData;
	import staticData.Sounds;
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	import treefortress.sound.SoundManager;

	
	//================================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//================================================o
	
	public class SoundController extends SuperController
	{
		private var sndthrust:SoundChannel;
		private var _soundGroup_music:SoundManager;
		private var _soundGroup_sfx:SoundManager;
		
		
		//================================================o
		//------ Constructor
		//================================================o			
		public function SoundController() 
		{
			trace("SettingsController constructed");
			
		}
		
		//================================================o
		//------ init
		//================================================o				
		public function init():void
		{
			restoreSettings();
			
			//impacts
			SoundAS.loadSound("lib/mp3/blade.mp3", Sounds.SFX_BLADE);
			SoundAS.loadSound("lib/mp3/electric_zap.mp3", Sounds.SFX_ZAP);
			SoundAS.loadSound("lib/mp3/goat.mp3", Sounds.SFX_GOAT);
			SoundAS.loadSound("lib/mp3/weight.mp3", Sounds.SFX_CACTUS);
			SoundAS.loadSound("lib/mp3/toast_missile.mp3", Sounds.SFX_MISSILE);
			SoundAS.loadSound("lib/mp3/metal_hit.mp3", Sounds.SFX_METAL_HIT);
			SoundAS.loadSound("lib/mp3/duck.mp3", Sounds.SFX_DUCK);
			SoundAS.loadSound("lib/mp3/echidna.mp3", Sounds.SFX_ECHIDNA);
			
			SoundAS.loadSound("lib/mp3/doors_close.mp3", Sounds.DOOR_CLOSE);
			SoundAS.loadSound("lib/mp3/dubLoop.mp3", Sounds.MUSIC_NUGZONE);
			SoundAS.loadSound("lib/mp3/splat3.mp3", Sounds.SPX_SPLAT);
			
			SoundAS.loadSound("lib/mp3/nug_2.mp3", "nug_2");
			SoundAS.loadSound("lib/mp3/nug_3.mp3", "nug_3");
			SoundAS.loadSound("lib/mp3/portal_open.mp3", Sounds.PORTAL_OPEN);
			SoundAS.loadSound("lib/mp3/portal_close.mp3", Sounds.PORTAL_CLOSE);
			
			SoundAS.loadSound("lib/mp3/pickup_coin1.mp3", "coin1");
			SoundAS.loadSound("lib/mp3/pickup_coin2.mp3", "coin2");
			SoundAS.loadSound("lib/mp3/pickup_coin3.mp3", "coin3");
			SoundAS.loadSound("lib/mp3/start_jump_after_blimp_go.mp3", Sounds.SFX_INITIAL_THRUST);
			SoundAS.loadSound("lib/mp3/no_fuel.mp3", Sounds.SFX_NO_FUEL);
			SoundAS.loadSound("lib/mp3/blimp_countdown_beep.mp3", Sounds.SFX_BEEP);
			SoundAS.loadSound("lib/mp3/blimp_countdown_go.mp3", Sounds.SFX_GO);
			
			SoundAS.loadSound("lib/mp3/woo_hoo1.mp3", Sounds.SFX_HOO_1);
			SoundAS.loadSound("lib/mp3/woo_hoo2.mp3", Sounds.SFX_HOO_2);
			SoundAS.loadSound("lib/mp3/woo_hoo3.mp3", Sounds.SFX_HOO_3);
						
			SoundAS.loadSound("lib/mp3/woo_bond.mp3", Sounds.SFX_HOO_PENGUIN);
			SoundAS.loadSound("lib/mp3/woo_headHoncho.mp3", Sounds.SFX_HOO_LIFE_SAVER);
			SoundAS.loadSound("lib/mp3/woo_fonz.mp3", Sounds.SFX_HOO_COOL_DUDE);
			SoundAS.loadSound("lib/mp3/woo_pirate.mp3", Sounds.SFX_HOO_PIRATE);
			SoundAS.loadSound("lib/mp3/woo_santa.mp3", Sounds.SFX_HOO_SANTA);
			SoundAS.loadSound("lib/mp3/woo_astronaut.mp3", Sounds.SFX_HOO_ASTRONAUT);
			SoundAS.loadSound("lib/mp3/woo_steakSuit.mp3", Sounds.SFX_HOO_STEAK_SUIT);
			SoundAS.loadSound("lib/mp3/woo_invisible.mp3", Sounds.SFX_HOO_INVISIBLE);
			SoundAS.loadSound("lib/mp3/woo_karate.mp3", Sounds.SFX_HOO_KARATE);
			
			
			SoundAS.loadSound("lib/mp3/achievement.mp3", Sounds.SFX_ACHIEVEMENT);
			SoundAS.loadSound("lib/mp3/whistle.mp3", Sounds.SFX_WHISTLE);
			
			
			SoundAS.loadSound("lib/mp3/hooray.mp3", Sounds.SFX_HOORAY);
			
			SoundAS.loadSound("lib/mp3/prize_won.mp3", Sounds.SFX_PRIZE_WON);
			SoundAS.loadSound("lib/mp3/impact.mp3", Sounds.SFX_IMPACT);
			SoundAS.loadSound("lib/mp3/death_impact.mp3", Sounds.SFX_DEATH_IMPACT);
			SoundAS.loadSound("lib/mp3/cash_register.mp3", Sounds.SFX_CASH_REGISTER);
			
			SoundAS.loadSound("lib/mp3/power_out_1.mp3", Sounds.SFX_POWER_DOWN_1);
			SoundAS.loadSound("lib/mp3/power_out_2.mp3", Sounds.SFX_POWER_DOWN_2);
			SoundAS.loadSound("lib/mp3/power_out_3.mp3", Sounds.SFX_POWER_DOWN_3);
			
			SoundAS.loadSound("lib/mp3/powerup_1.mp3", Sounds.SFX_POWERUP_1);
			SoundAS.loadSound("lib/mp3/powerup_2.mp3", Sounds.SFX_POWERUP_2);
			SoundAS.loadSound("lib/mp3/powerup_3.mp3", Sounds.SFX_POWERUP_3);
			
			SoundAS.loadSound("lib/mp3/powerup_horse.mp3", Sounds.SFX_HORSE);
			SoundAS.loadSound("lib/mp3/powerup_voodoo.mp3", Sounds.SFX_VOODOO);
			SoundAS.loadSound("lib/mp3/powerup_sloth.mp3", Sounds.SFX_SLOTH);
			SoundAS.loadSound("lib/mp3/powerup_vacuum.mp3", Sounds.SFX_VACUUM);
			SoundAS.loadSound("lib/mp3/powerup_pig.mp3", Sounds.SFX_PIG);
			
			SoundAS.loadSound("lib/mp3/code_redeemed.mp3", Sounds.SFX_CLAIM);
			SoundAS.loadSound("lib/mp3/wind.mp3", Sounds.SFX_WIND_1);
			SoundAS.loadSound("lib/mp3/wind2.mp3", Sounds.SFX_WIND_2);
			SoundAS.loadSound("lib/mp3/landing_intro.mp3", Sounds.SFX_LANDING_INTRO);
			SoundAS.loadSound("lib/mp3/coin_drop.mp3", Sounds.SFX_COIN_DROP);
			
			SoundAS.loadSound("lib/mp3/music_shop.mp3", Sounds.MUSIC_SHOP);

			
			SoundAS.loadSound("lib/mp3/thrust_loop.mp3", Sounds.THURST_LOOP);
			
			SoundAS.loadSound("lib/mp3/music_slow.mp3", Sounds.MUSIC_SLOW);
			SoundAS.loadSound("lib/mp3/music_intro.mp3", Sounds.INTRO_MUSIC);
			SoundAS.loadSound("lib/mp3/music_intro2.mp3", Sounds.INTRO_MUSIC_2);
			SoundAS.loadSound("lib/mp3/music_menu_long.mp3", Sounds.MENU_MUSIC_LONG);
			SoundAS.loadSound("lib/mp3/music_loop1.mp3", Sounds.MUSIC_LOOP_1);
			SoundAS.loadSound("lib/mp3/music_loop.mp3", Sounds.MUSIC_LOOP_2);
			SoundAS.loadSound("lib/mp3/menu_music.mp3", Sounds.MUSIC_MENU);
			SoundAS.loadSound("lib/mp3/music_end_long.mp3", Sounds.MUSIC_END);
			SoundAS.loadSound("lib/mp3/music_end_short.mp3", Sounds.MUSIC_END_SHORT);
			SoundAS.loadSound("lib/mp3/coinCountUp.mp3", Sounds.COIN_COUNT);

		}

		//================================================o
		//------ Restore Settings from SharedObjects
		//================================================o	
		private function restoreSettings():void 
		{
			trace(this+"restoreSettings():"+SoundData.isSFXMuted);
			if (SoundData.isSFXMuted)
			{
				SoundAS.mute = true;
			}
		}

		//================================================o
		//------ Enable Sound effects
		//================================================o		
		public function enableSoundFX():void
		{
			
		}
				
		//================================================o
		//------ Disable Sound effects
		//================================================o		
		public function disableSoundFX():void
		{

		}
		
		//================================================o
		//------ toggle Sound effects
		//================================================o		
		public function toggleSoundFX():void
		{
			if (!SoundData.isSFXMuted)
			{
				SoundAS.mute = true;
				SoundData.isSFXMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_SFX_MUTED, true);
			}
			else
			{
				SoundAS.mute = false;	
				SoundData.isSFXMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_SFX_MUTED, false);
			}
			
			trace(this + "toggleSoundFX()" + SharedObjects.getProperty(SharedObjectKeys.IS_SFX_MUTED));
		}
		
		
		//================================================o
		//------ Enable Music
		//================================================o		
		public function enableMusic():void
		{
			SoundAS.mute = false;	
		}
				
		//================================================o
		//------ Disable Music
		//================================================o		
		public function disableMusic():void
		{
			SoundAS.mute = true;	
		}
		
		//================================================o
		//------ toggle Music
		//================================================o		
		public function toggleMusic():void
		{
			if (!SoundData.isMusicMuted)
			{
				SoundData.isMusicMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_MUSIC_MUTED, true);
			}
			else
			{
				SoundData.isMusicMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_MUSIC_MUTED, false);
			}
		}


		//================================================o
		//------ trash/kill/dispose
		//================================================o		
		public function trash():void
		{
			
		}
		
		
		public function playSpecialZoneMusic():void
		{
			
		}
		public function playMusicLoop(num:int = 1):void 
		{
			
			if (Sounds.currentMusic != null)
			SoundAS.getSound(Sounds.currentMusic).stop();
			
			//fail safe------o
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_1).isPlaying)
			SoundAS.getSound(Sounds.MUSIC_LOOP_1).stop();
									
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_2).isPlaying)
			SoundAS.getSound(Sounds.MUSIC_LOOP_2).stop();
			//------o
			
			Sounds.currentMusic = "musicLoop" + num;
			SoundAS.play(Sounds.currentMusic, .8).soundCompleted.addOnce(function(si:SoundInstance):void { 
				
				playMusicLoop(Maths.rn(1, 2));
				
			})	
		}
		
		public function checkIfMusicFailed():void 
		{
			
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_1).isPlaying)
			{
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_2).isPlaying)
			playMusicLoop(1);
			}
			
		}
		


		
		//================================================o
		//------ Getters and Setters
		//================================================o			


		
	}

}