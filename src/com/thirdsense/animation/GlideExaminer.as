package com.thirdsense.animation 
{
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.utils.DuplicateDisplayObject;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * <p>Timeline examiner class for use with GlideConstruct objects. This class examines and converts classic MovieClips and their tweens to Starling.</p>
	 * <p>Essentially this class cycles through every frame in a target MovieClip, capturing transformation matrix, colorTransform, clip index and creates
	 * a run-time spritesheet and texture atlas.</p>
	 * <p>Because Starling is yet to officially supporting masking, the GlideExaminer will not treat masks within the target clips timeline as desired.
	 * Also worth noting is that color transformations are psuedo-emulated by using the starling display object 'color' property, but it will not look
	 * exactly the same and it will cause an extra draw command per asset if you use tinting in the target clip's timeline (alternatively, set the GlideConstruct
	 * 'ignoreColorTransform' property to 'true' to ignore tinting transformations during render)</p>
	 * <p>The following example converts a traditional MovieClip for use in Starling. For example purpose, in the resulting construct we will also want to use
	 * an asset that is on the second frame of the target's child clip named "helmet", so passing 'true' for the constructor argument 'includeChildren' is needed</p>
	 * <listing>
	 * import com.thirdsense.animation.GlideExaminer;
	 * import com.thirdsense.animation.GlideConstruct;
	 * import starling.events.TouchEvent;
	 * import starling.events.Touch;
	 * import starling.events.TouchPhase;
	 * 
	 * var examiner:GlideExaminer = new GlideExaminer( new myAvatar_mc(), true );
	 * 
	 * var avatar:GlideConstruct = new GlideConstruct( examiner );
	 * avatar.x = 100;
	 * avatar.y = 100;
	 * avatar.helmet.currentFrame = 1;	// Can also be referenced with avatar.getChildByName("helmet") as starling.display.MovieClip
	 * this.addChild( avatar );
	 * this.avatar.play();
	 * 
	 * // When the user taps the avatar, remove it from the stage. Because we no longer need the examiner, we should dispose of it to free up GPU memory.
	 * avatar.addEventListener(TouchEvent.TOUCH, this.touchHandler);
	 * 
	 * function touchHandler(e:TouchEvent):void
	 * {
	 * 	var	target_avatar:GlideConstruct = e.currentTarget as GlideConstruct;
	 * 	var touch:Touch = e.getTouch( target_avatar, TouchPhase.ENDED );
	 * 	if ( touch )
	 * 	{
	 * 		var examiner:GlideExaminer = target_avatar.getExaminer();
	 * 		examiner.dispose();
	 * 		target_avatar.removeFromParent();
	 * 	}
	 * }</listing>
	 * 
	 * @author Ben Leffler
	 */
	
	public class GlideExaminer 
	{
		private var target:MovieClip;
		private var assets:Array;
		private var pool:String;
		private var transforms:Object;
		private var textures:Object;
		private var frame_labels:Object;		
		private var target_dimensions:Object;
		private var _totalFrames:int;
		private var helper:SpriteSheetHelper;
		private var texture_pack:TexturePack;
		private var generateTexturePack:Boolean;
		public var name:String = "";
		
		/**
		 * Constructor for the GlideExaminer
		 * @param	target	The MovieClip to analyse and convert for use with the GlideConstruct
		 * @param	includeChildren	If MovieClips within the target parameter contains multiple frames that need to be enabled for use, pass this as true.
		 * Otherwise a false value will only snapshot the first frame and the resulting asset in Starling will be of starling.display.Image type.
		 */
		
		public function GlideExaminer( target:MovieClip, includeChildren:Boolean = true, helper:SpriteSheetHelper = null, generateTexturePack:Boolean = true ) 
		{
			this.generateTexturePack = generateTexturePack;
			this.helper = helper;
			this.pool = String(target).substring(String(target).indexOf(" ") + 1, String(target).length - 1);
			this.target = target;
			this.target_dimensions = { width:target.width, height:target.height };
			this.examine( includeChildren );
			this._totalFrames = this.target.totalFrames;
			this.target = null;
		}
		
		/**
		 * @private	Starts the examination process for each child of the target clip
		 * @param	includeChildren
		 */
		
		private function examine( includeChildren:Boolean ):void
		{
			this.transforms = new Object();
			
			for ( var i:uint = 0; i < this.target.totalFrames; i++ )
			{
				this.target.gotoAndStop(i + 1);
				
				var children:int = this.target.numChildren;
				for ( var j:uint = 0; j < children; j++ )
				{
					var disp:DisplayObject = this.target.getChildAt(j);
					var str:String = disp.name;
					if ( !this.transforms[str] )
					{
						this.transforms[str] = new Array();
						this.recordAsset(disp);
					}
					this.transforms[str][this.target.currentFrame-1] = this.createTransformObject(disp, j);
				}
				
				if ( this.target.currentFrameLabel != null )
				{
					if ( !this.frame_labels ) this.frame_labels = new Object();
					this.frame_labels[ this.target.currentFrameLabel ] = [ this.target.currentFrame ];
					for ( str in this.frame_labels )
					{
						if ( str != this.target.currentFrameLabel && this.frame_labels[ str ].length == 1 )
						{
							this.frame_labels[ str ].push( this.target.currentFrame - 1 );
						}
					}
				}
			}
			
			if ( this.frame_labels )
			{
				for ( str in this.frame_labels )
				{
					if ( this.frame_labels[str].length == 1 )
					{
						this.frame_labels[str].push( this.target.totalFrames );
					}
				}
			}
			
			for ( i = 0; i < this.assets.length; i++ )
			{
				this.target.gotoAndStop( this.assets[i].frame );
				var temp_name:String = this.assets[i].name;
				disp = this.target.getChildByName( this.assets[i].name );
				if ( !disp )
				{
					var mc:MovieClip = DuplicateDisplayObject.duplicate(this.target) as MovieClip;
					mc.gotoAndStop( this.assets[i].frame );
					disp = mc.getChildAt( this.assets[i].index );
				}
				
				this.convertToTexture( disp, i, includeChildren, temp_name );
			}
			
			this.createHelper();
			this.assets = null;
		}
		
		/**
		 * @private
		 */
		
		private function createHelper():void 
		{
			var arr:Array = new Array();
			
			for ( var str:String in this.textures )
			{
				arr.push( this.textures[str].spritesequence );
			}
			
			if ( this.helper )
			{
				this.helper.addSpriteSequences( arr );
			}
			else
			{
				this.helper = SpriteSheetHelper.consolidateSprites( arr );
			}
			
			if ( this.generateTexturePack )
			{
				this.texture_pack = new TexturePack();
				this.texture_pack.pool = this.helper.pool;
				this.texture_pack.fromHelper( this.helper, false );
			}
			
		}
		
		/**
		 * @private	Snapshots and records transformation data of the current child at the current frame
		 * @param	disp
		 * @param	index
		 * @return
		 */
		
		private function createTransformObject( disp:DisplayObject, index:int ):Object
		{
			var obj:Object = new Object();
			obj.matrix = disp.transform.matrix.clone();
			obj.color_transform = disp.transform.colorTransform;
			obj.index = index;
			return obj;
		}
		
		/**
		 * @private	Keeps a local copy of the child asset for conversion to a texture pack at the end of the examiner process
		 * @param	disp
		 */
		
		private function recordAsset( disp:DisplayObject ):void
		{
			if ( !this.assets ) this.assets = new Array();
			this.assets.push( {name:disp.name, frame:this.target.currentFrame, index:disp.parent.getChildIndex(disp) } );
		}
		
		/**
		 * @private	Converts a child asset to a TexturePack object for use with reconstruction
		 * @param	disp
		 * @param	index
		 * @param	includeChildren
		 */
		
		private function convertToTexture(disp:DisplayObject, index:int, includeChildren:Boolean, temp_name:String ):void
		{
			if ( !disp ) return void;
			
			if ( !this.textures ) this.textures = new Object();
			
			var mc:MovieClip = new MovieClip();
			disp.transform = mc.transform;
			
			//var index2:int = this.target.getChildIndex(disp);
			
			if ( getQualifiedClassName(disp) == "flash.display::MovieClip" && includeChildren)
			{
				var mc2:MovieClip = disp as MovieClip;
				mc.addChild( mc2 );
			}
			else
			{
				mc2 = null;
				mc.addChild( disp );
			}
			
			if ( !this.textures[temp_name] )
			{
				var ss:SpriteSequence = SpriteSequence.create( mc, mc2 );
				ss.pool = this.pool;
				ss.sequence = temp_name;
				this.textures[temp_name] = { spritesequence:ss, index:index, id:this.totalElements };
			}
		}
		
		/**
		 * Obtains the total number of children encountered in the timeline
		 */
		
		public function get totalElements():int
		{
			var counter:int = 0;
			
			for ( var str:String in this.textures )
			{
				counter++;
			}
			
			return counter;
		}
		
		/**
		 * Retrieves an array of all available visual elements collected by the examiner instance
		 * @return	Array of strings
		 */
		
		public function getElementNames():Array
		{
			var arr:Array = new Array();
			for ( var str:String in this.textures )
			{
				arr.push(str);
			}
			
			return arr;
		}
		
		/**
		 * @private	Retrieves a TexturePack element based on child id
		 * @param	id	The child id of the element
		 * @return	TexturePack object
		 */
		
		public final function getElementAt( id:int ):Object
		{
			for ( var str:String in this.textures )
			{
				if ( this.textures[str].id == id )
				{
					var obj:Object = new Object();
					obj.name = str;
					if ( this.texture_pack ) obj.asset = this.texture_pack.getMovieClip(60, str);
					return obj;
				}
			}
			
			return null;
		}
		
		/**
		 * @private	Retrieves a TexturePack element based on the asset name
		 * @param	asset_name	The name of the asset
		 * @return	TexturePack object
		 */
		
		/*public final function getElementByName( asset_name:String ):TexturePack
		{
			for ( var str:String in this.textures )
			{
				if ( this.textures[str].texture_pack.sequence == asset_name )
				{
					var tp:TexturePack = this.textures[str].texture_pack;
				}
			}
			
			return tp;
		}*/
		
		/**
		 * Gets the transformation matrix of an asset at the desired frame
		 * @param	asset_name	The name of the asset
		 * @param	frame	The number of the frame
		 * @return	A Matrix object for use with asset transformation in the animation construct
		 */
		
		public final function getMatrix( asset_name:String, frame:int ):Matrix
		{
			var obj:Object = this.transforms[asset_name][frame-1];
			if ( obj ) 
			{
				return obj.matrix;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Retrieves the ColorTransform of an asset at the desired frame
		 * @param	asset_name	The name of the asset
		 * @param	frame	The number of the frame
		 * @return	A ColorTransform object for use with alpha and psuedo asset tinting in the animation construct
		 */
		
		public final function getColorTransform( asset_name:String, frame:int ):ColorTransform
		{
			var obj:Object = this.transforms[asset_name][frame-1];
			if ( obj ) 
			{
				return obj.color_transform;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Retrieves the index of an asset at the desired frame.
		 * @param	asset_name	The name of the asset
		 * @param	frame	The number of the frame to check
		 * @return	The index of the asset. If the asset does not exist on the timeline at the desired frame, a value of -1 is returned.
		 */
		
		public final function getIndex( asset_name:String, frame:int ):int
		{
			var obj:Object = this.transforms[asset_name][frame-1];
			if ( obj ) 
			{
				return obj.index;
			}
			else
			{
				return -1;
			}
		}
		
		/**
		 * Retrieves the total number of frames in the original timeline
		 */
		
		public function get totalFrames():int
		{
			return this._totalFrames;
		}
		
		/**
		 * Gets an array of available frame labels in the timeline
		 * @return	An array of strings
		 */
		
		public function getAllFrameLabels():Array
		{
			var arr:Array = new Array();
			for ( var str:String in this.frame_labels )
			{
				arr.push(str);
			}
			
			if ( arr.length )
			{
				return arr;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Disposes of all textures from the GPU and flags for garbage collection
		 */
		
		public function dispose():void
		{
			for ( var str:String in this.textures )
			{
				var ss:SpriteSequence = this.textures[str].spritesequence;
				ss.dispose();
				ss = null;
				this.textures[str] = null;
			}
			
			if ( this.texture_pack ) this.texture_pack.kill();
			if ( this.helper ) this.helper.dispose();
		}
		
		/**
		 * Obtains the original dimensions of the MovieClip that was processed.
		 * @return	An object representation of the width and height. eg { width:100, height:100 }
		 */
		
		public final function getDimensions():Object
		{
			return this.target_dimensions;
		}
		
		/**
		 * Obtains the initial frame number value of a frame label stanza
		 * @param	label	The name of the frame label to check for
		 * @return	The number of the first frame. If the frame label hasn't been found on the timeline, a value of -1 is returned.
		 */
		
		public final function getFrameLabelStart( label:String ):int
		{
			if ( this.frame_labels && this.frame_labels[label] )
			{
				return this.frame_labels[label][0];
			}
			else
			{
				return -1;
			}
		}
		
		/**
		 * Obtains the end frame number value of a frame label stanza
		 * @param	label	The name of the frame label to check for
		 * @return	The number of the end frame. If the frame label hasn't been found on the timeline, a value of -1 is returned.
		 */
		
		public function getFrameLabelEnd( label:String ):int
		{
			if ( this.frame_labels && this.frame_labels[label] )
			{
				return this.frame_labels[label][1];
			}
			else
			{
				return -1;
			}
		}
		
	}

}