package com.thirdsense.sound 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.settings.Profiles;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * Static class that plays a sound from either LaunchPad asset library or the LaunchPad lib/mp3/ folder
	 * @author Ben Leffler
	 */
	
	public class SoundStream 
	{
		private static var _sound_volume:Number = 1;
		private static var _music_volume:Number = 1;
		
		/**
		 * The relative path to the folder containing your application sounds
		 */
		public static var sound_path:String = "lib/mp3/";
		
		public function SoundStream() 
		{
			
		}
		
		/**
		 * Plays a a designated sound. This function will first check the availability of a sound within the runtime loaded
		 * LaunchPad asset library - if one does not exist, it will attempt to load the sound from the lib/mp3/ folder (folder 
		 * location can be altered by changing the value of 'SoundStream.sound_path')
		 * @param	file	The asset name or the file name of the sound to play
		 * @param	volume	The volume at which to play the sound
		 * @param	loops	The number of loops to play the sound for
		 * @param	label	The type of sound this is labelled as (as defined by the SoundLabel class). The sound will be assigned a volume multiplier based on type
		 * @return	The SoundChannel object of the sound. This object can be used to apply a SoundShape to for fade effects and panning. Null will be returned if the volume or static sound_volume value is set to 0.
		 * @see	com.thirdsense.sound.SoundShape
		 * @see com.thirdsense.sound.SoundLabel
		 */
		
		public static function play( file:String, volume:Number = 1, loops:int = 0, label:String="sound" ):SoundChannel
		{
			if ( label == "sound" || label == "music" )
			{
				var vol:Number = volume * SoundStream[label + "_volume"];
				if ( vol == 0 ) return null;
			}
			else
			{
				vol = volume;
			}
			
			var st:SoundTransform = new SoundTransform( vol );
			
			var snd:Sound = LaunchPad.getAsset( "", file );
			if ( !snd )
			{
				var request:URLRequest = new URLRequest(LPSettings.LIVE_EXTENSION + sound_path + file);
				
				snd = new Sound( request );
			}
			
			if ( snd )
			{
				return snd.play( 0, loops, st );
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Sets the volume multiplier for a sound tagged with a SoundLabel.SOUND label
		 * @see	com.thirdsense.sound.SoundLabel
		 */
		
		static public function get sound_volume():Number 
		{
			return _sound_volume;
		}
		
		static public function set sound_volume(value:Number):void 
		{
			_sound_volume = value;
		}
		
		/**
		 * Sets the volume multiplier for a sound tagged with a SoundLabel.MUSIC label
		 * @see	com.thirdsense.sound.SoundLabel
		 */
		
		static public function get music_volume():Number 
		{
			return _music_volume;
		}
		
		static public function set music_volume(value:Number):void 
		{
			_music_volume = value;
		}
		
	}

}