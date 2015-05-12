package view.components.screens
{

	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.StringFunctions;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import mx.utils.StringUtil;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.settings.PublicSettings;

	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import staticData.*;


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */

	public class LoadingScreen extends Sprite implements iScreen
	{
		static public const DYNAMIC_TA_REF:String = "LoadingScreen";

	 /* 
	  * This is a native display component that appears during the loading of
	  * runtime asset data, ie between levels
	  */
		private var _core:Core;
		private var _bg:Quad;
		private var _showProgress:Boolean;
		private var _label:String;
		private var _stf:TextField;
		private var _quProgress:Quad;
		private var _hexColour:Quad;
		private var _simSloth:Image;
		private var _quTongue:Quad;
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function LoadingScreen(label:String, showProgress:Boolean = true, _hexColour:uint = HexColours.BLACK):void 
		{
			_core = Core.getInstance();
			
			_label = label;
			_showProgress = showProgress;
			_hexColour = _hexColour;
			
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
		}
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			trace(this + " inited");
			
			_bg = new Quad(AppData.deviceResX, AppData.deviceResY, HexColours.NAVY_BLUE)
			addChild(_bg); 
			
			var spSlothHolder:Sprite = new Sprite();
			
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_slothLoader") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_slothLoader", null, 1, 1, null, 0)
			_simSloth = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_slothLoader").getImage();
			_simSloth.x = 0;
			_simSloth.y = 0;
			spSlothHolder.addChild(_simSloth);
			mc = null;
			
			_quTongue = new Quad(60, 10, 0xFF5F7B) 
			_quTongue.x = 227;
			_quTongue.y = 86;
			spSlothHolder.addChild(_quTongue);
			
			if (_label != null)
			{
				_stf = new TextField(340, 190, String(_label).toUpperCase(), AppFonts.FONT_ARIAL, 50, HexColours.WHITE);
				_stf.x =  110
				_stf.y =  190
				_stf.hAlign = HAlign.CENTER;
				_stf.vAlign = VAlign.TOP;
				spSlothHolder.addChild(_stf);
			}
			
			this.addChild(spSlothHolder)
			spSlothHolder.pivotX = spSlothHolder.width / 2;
			spSlothHolder.pivotY = spSlothHolder.height / 2;
			spSlothHolder.x = AppData.deviceResX/2
			spSlothHolder.y =  AppData.deviceResY/2
			
			
			if (DeviceType.type == DeviceType.IPAD)
			{

			}
			else if (DeviceType.type == DeviceType.IPHONE_5)
			{

			}
			else if (DeviceType.type == DeviceType.IPHONE_4)
			{

			}
			//unknown device
			else
			{
				//if smaller then 640
				if (AppData.offsetScaleX < 1)
				{
				spSlothHolder.scaleX = spSlothHolder.scaleY = AppData.offsetScaleX;
				}
				else 
				{
				spSlothHolder.scaleX = spSlothHolder.scaleY = AppData.deviceScaleX;	
				}
			}	
			
			if (_showProgress)
			{
				TweenMax.to(_quTongue, 1, {width:280, yoyo:true, repeat:-1, ease:Linear.easeNone})
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function animateOut():void 
		{
			trace(this + " animateOut");
			TweenLite.to(this, 1,{alpha:0, onComplete:trash})
		}		
		//----o Clean Up function
		private function onRemove(e:Event):void 
		{
			
		}

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		public function trash():void
		{
			trace(this + "trash()");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			TweenMax.killTweensOf(_quTongue);
			this.removeFromParent();


		}
		
		public function updateLabel(label:String):void 
		{
			_stf.text = label.toUpperCase();
		}
		
	}
	
}