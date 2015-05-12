package view.components.ui 
{

	import com.adobe.utils.NativeText;
	import com.flashspeaks.events.CountdownEvent;
	import com.flashspeaks.utils.CountdownTimer;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.StringFunctions;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.utils.StringTools;
	import flash.display.Bitmap;
	import flash.events.FocusEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormatAlign;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import staticData.AppFonts;

	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;

	import view.components.screens.SuperScreen;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class FormField extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "FormField";
		
		public static const STATE_ON:String = "stateOn";
		public static const STATE_OFF:String = "stateOff";
		static public const STATE_ERROR:String = "stateError";
		
		static public const TYPE_MIXED_TEXT:String = "mixedText";
		static public const TYPE_NAME:String = "name";
		static public const TYPE_FIRST_NAME:String = "firstName";
		static public const TYPE_LAST_NAME:String = "lastName";
		static public const TYPE_EMAIL:String = "email";
		static public const TYPE_PHONE:String = "phone";
		static public const TYPE_POSTCODE:String = "postcode";
		static public const TYPE_CONFIRMATION:String = "confirmation";
		static public const TYPE_OPTION_LIST:String = "optionList";
		static public const TYPE_PASSWORD:String = "password";
		static public const TYPE_NONE:String = "none";
		
		private var taRef:String;
		private var _core:Core;

		private var _smcFormField:starling.display.MovieClip;
		
		private var _isToggleOn:Boolean;
		private var _isRequired:Boolean;
		private var _defaultState:String;
		
		
		private var _callBack:Function;
		private var _label:String;
		private var _navGroup:Object;
		private var _tt:TrueTouch;
		private var _value:String;
		private var _simFormField:Image;
		private var _isOptionList:Boolean;
		private var _type:String;
		private var _mirrorField:FormField;
		private var _defaulLabel:String;
		private var isDefault:Boolean = false;
		private var _st:CustomStageText;
		private var _keyBoardType:String;
		private var _stageText:StageText;
		private var viewPort:Rectangle;
		private var _globalContext:Sprite;
		private var _showOnActivate:Boolean;
		private var _xOffset:int;
		private var _yOffset:Number;
		private var _w:Number;
		private var _h:Number;
		private var _swearCheck:Boolean;
		private var _lastErrorMsg:String;
		public var isValid:Boolean;
		public var active:Boolean = true;
		
		public var dataClass:Class;
		public var dataProperty:*;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function FormField(dynamicVariant:int, defaultLabel:String, keyBoardType:String = SoftKeyboardType.CONTACT, type:String = TYPE_MIXED_TEXT, mirrorField:FormField = null, dataReference:* = null, swearCheck:Boolean = false ) 
		{
			
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			_swearCheck = swearCheck

			_defaulLabel = defaultLabel;

			_value = label;
			_keyBoardType = keyBoardType;
			
			_type = type;
			_mirrorField = mirrorField;
			
			_xOffset = 40;
			_yOffset = 40;
			taRef = "TA_checkBox" + dynamicVariant;
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
		
			_stageText = new StageText();
			_tt = new TrueTouch();
			

			if (_defaultState == null)
			_defaultState = STATE_OFF;
			
			if (_label == null)
			_label = _defaulLabel;
			
			
			if (dataClass != null)
			{
				
				if (dataClass[dataProperty] != null && dataProperty != "password")
				_label = dataClass[dataProperty];
				
			
			}
			
			
			changeState(_defaultState, _label)
			
			addStageText();
			

		}

		public function changeState(newState:String, label:String):void 
		{
			trace(this + "changeState(" + newState + "," + label + ")");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, taRef);
			
			var mcField:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_formField") as MovieClip;

			
			var statusBar:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_fieldStatusBar") as MovieClip;
			mcField.addChild(statusBar);
			
			if (newState == STATE_OFF)
			{
				//mcField.$mcText.gotoAndStop("input");
				statusBar.gotoAndStop("off");
				_value = label;
			}
			else if (newState == STATE_ON)
			{
				//mcField.$mcText.gotoAndStop("input");
				statusBar.gotoAndStop("on");
				_value = label;
			}			
			else if (newState == STATE_ERROR)
			{
				_stageText.color = HexColours.RED;
				statusBar.gotoAndStop("error");
				_value = label;
			}	
			
			//if option list, set different text colour style
			if (_type == TYPE_OPTION_LIST)
			{
				mcField.$mcArrow.visible = true;
			}
			else
			{
			mcField.$mcArrow.visible = false;
			}
			
			
			if (label == null)
			label = defaulLabel;
			

			_stageText.text = label;
			
			TexturePack.createFromMovieClip(mcField, DYNAMIC_TA_REF, taRef, null, 1, 1, null, 0)
			_simFormField = TexturePack.getTexturePack(DYNAMIC_TA_REF, taRef).getImage();
			
			this.addChild(_simFormField);
			
			mcField = null;
			statusBar = null;

		}
		
		private function addStageText():void 
		{
			_stageText.color = 0x7E7E7E;
			_stageText.autoCorrect = false;
			_stageText.editable = true;
			_stageText.fontFamily = "Futura Std Medium";
			_stageText.fontSize = AppData.offsetScaleX * 26;
			if (PublicSettings.PLATFORM == "ANDROID")
			_stageText.fontSize = AppData.offsetScaleX * 28;
			
			if(dataClass != null)
			_stageText.text = _label;
			else
			_stageText.text = _defaulLabel;
			
			_stageText.textAlign = TextFormatAlign.LEFT;
			_stageText.returnKeyLabel = ReturnKeyLabel.DEFAULT;
			_stageText.softKeyboardType = _keyBoardType;
			
			if(_globalContext == null)
			_globalContext = Sprite(this.parent);

			setViewPort();
									
		    _stageText.viewPort = viewPort;	
			
			
			AppData.arrStageTextInstanes.push(this);
			
			if (_showOnActivate == false)
			_stageText.stage = Starling.current.nativeStage;
			

			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
			_stageText.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true)
			_stageText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true)
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved)
		}
		
		private function setViewPort():void 
		{
			
			if(AppData.offsetScaleX < 1)
			viewPort = new Rectangle((AppData.offsetScaleX * this.x) + _globalContext.x + (AppData.offsetScaleX * 40), (AppData.offsetScaleX * this.y) + _globalContext.y + (AppData.offsetScaleX * 20), this.width - (AppData.offsetScaleX * 40), 50)
			else if (AppData.offsetScaleX > 1)
			viewPort = new Rectangle((AppData.deviceScaleX * this.x) + _globalContext.x + (AppData.deviceScaleX * 40), (AppData.deviceScaleX * this.y) + _globalContext.y + (AppData.deviceScaleX * 20), (AppData.deviceScaleX * 530) - (AppData.deviceScaleX * 40) , AppData.deviceScaleX *50)
			else
			viewPort = new Rectangle(this.x + _globalContext.x + 40, this.y + _globalContext.y + 20, this.width - 40, 50)
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			if(_stageText.hasEventListener(FocusEvent.FOCUS_IN))
			_stageText.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			
			if(_stageText.hasEventListener(FocusEvent.FOCUS_OUT))
			_stageText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			_stageText.color = 0x7E7E7E;
			if (_stageText.text == "")
			_stageText.text = _defaulLabel;
			
			_value = _stageText.text;
			
			if(dataClass != null)
			dataClass[dataProperty] = _value;
			
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			//if (!active)
			//return;
			
			_stageText.color = HexColours.FONT_GREY;
			
			if (_stageText.text == _defaulLabel  || (_lastErrorMsg != null && _stageText.text == _lastErrorMsg))
			_stageText.text = "";
			
		}

		private function onUpdate(e:Event):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, onUpdate)
			setViewPort();
			_stageText.viewPort = viewPort;	
			
		}
		

		//===========================================o
		//-- Confirmation event of Modal UI or Option List
		//===========================================o
		public function callBack_confirm(text:String = null):void
		{
			
			isValid = false;
			var errorMsg:String;
			
			if (text == "null" || text == null)
			return;
			
			
			trace("_defaulLabel :" + _defaulLabel);
			if (!_isRequired && text == _defaulLabel)
			{
				isValid = true;
				changeState(STATE_OFF, defaulLabel);
				//changeState(STATE_ON, text);
				return;
			}
			
			if (_type == TYPE_OPTION_LIST)
			{
				isValid	= true
			}else
			{
				switch(_type)
				{
					
					//---------------------------o	
					
					case TYPE_NONE:
					isValid = true;
					break;
					
					//---------------------------o	
					
					case TYPE_MIXED_TEXT:
					break;
					
					//---------------------------o		
					
					case TYPE_NAME:
					if (StringFunctions.validateName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text)
					errorMsg = "*You have not entered a name";
					else
					errorMsg = "*Please enter a valid name"

					break;
					
					//---------------------------o		
					
					case TYPE_FIRST_NAME:
					if (StringFunctions.validateName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text)
					errorMsg = "*Do you even know your name?"; //errorMsg = "*Please enter a first name";
					else
					errorMsg = "*Do you even know your name?"// errorMsg = "*Please enter a valid first name"
					

					break;
										
					//---------------------------o		
					
					case TYPE_LAST_NAME:
					if (StringFunctions.validateName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text)
					errorMsg = "*Add your surname stranger?";//errorMsg = "*Please enter a last name";
					else
					errorMsg = "*Add your surname stranger?"

					break;
					
					//---------------------------o	
					
					case TYPE_EMAIL:
					if (_mirrorField != null)
					{
						if (text == _mirrorField.value) 
						{
							isValid = true;
						}
						else if(_mirrorField.value == _mirrorField.defaulLabel || _mirrorField.value == _mirrorField.label)
						{
							if (text == defaulLabel)
							{
							isValid = true;
							isDefault = true;
							}
							else
							{
								isValid = false;
								errorMsg = "*Emails do not match";
							}
							
						}
						else
						{
							errorMsg = "*We need your email addy again";//errorMsg = "Emails do not match";
						}
						
						
						
					}
					else
					{
						if (StringFunctions.validateEmail(text))
						isValid = true;
						else
						errorMsg = "*Hello? What’s your email addy?";//errorMsg = "Please enter a valid email";
					}
					break;
					
					//---------------------------o	
					
					case TYPE_PHONE:
					if (StringFunctions.validatePhoneNumber(text) && text != _defaulLabel)	
					isValid = true;
					else if(_defaulLabel == text)
					errorMsg = "*Add your ph. number dude"; //errorMsg = "*Please enter a phone number";
					else
					errorMsg = "*Add your ph. number dude"; //errorMsg = "*Please enter a valid phone number"
					

					break;
					
					//---------------------------o		
					
				case TYPE_POSTCODE:
					

						if (StringFunctions.validateAusPostcode(text) && text != _defaulLabel)	
						isValid = true;
						else if(_defaulLabel == text)
						errorMsg = "*What’s your hood’s postcode?";//errorMsg = "*Please enter a postcode";
						else
						errorMsg = "*What’s your hood’s postcode?" //errorMsg = "Please enter a valid postcode"
					
					
					break;
					
					//---------------------------o	
					
					case TYPE_PASSWORD:
					if (_mirrorField != null)
					{
						if (text == _mirrorField.value) 
						{
						isValid = true;
						}
						else if(_mirrorField.value == _mirrorField.defaulLabel)
						{
						isValid = true;
						isDefault = true;
						}
						else
						{
						errorMsg = "Passwords do not match"; //errorMsg = "Passwords do not match";
						}
					}
					else
					{
						if (StringFunctions.validatePassword(text) && text != _defaulLabel)		
						isValid = true;	
						else if(_defaulLabel == text)
						errorMsg = "*Keep calm and add a password";//errorMsg = "*Please enter a password";
						else
						errorMsg = "*6 chars incl. 1 numb required";
						//errorMsg = "*Use letters and numbers only";
					}
					break;
					
					//---------------------------o	
	
					
				}
					
					var arrWordsInText:Array = text.toLowerCase().split(" ");
				
					if (_swearCheck)
					{
						for (var i:int = 0; i < arrWordsInText.length; i++) 
						{
							if (AppData.badWords.indexOf(arrWordsInText[i]) != -1)
							{
								isValid = false;
								errorMsg = "Foul Mouth Fail!";
							}
						}
	
					}
				
				
				
			  //TODO Field Error handling here, add a _type value to this field
			  //if email
			  //if name
			  //if password
			  
			  
			}
			
			_lastErrorMsg = errorMsg;
			
			if (isDefault)
			changeState(STATE_OFF, defaulLabel);
			else if(isValid)
			changeState(STATE_ON, text);
			else
			changeState(STATE_ERROR, errorMsg);
			
			
			
		}
		
		public function reset():void {
		_defaulLabel	
		}
		
		//===========================================o
		//-- Cancel event of Modal UI or Option List
		//===========================================o		
		private function callBack_cancel():void
		{
			
		}
		

		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			
			_stageText.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_stageText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			_tt.trash();
			this.removeFromParent();
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function get defaulLabel():String 
		{
			return _defaulLabel;
		}
		
		public function get isRequired():Boolean 
		{
			return _isRequired;
		}
		
		public function set isRequired(value:Boolean):void 
		{
			_isRequired = value;
		}
		
		public function get defaultState():String 
		{
			return _defaultState;
		}
		
		public function set defaultState(value:String):void 
		{
			_defaultState = value;
		}
		
		public function get st():CustomStageText 
		{
			return _st;
		}
		
		public function set st(value:CustomStageText):void 
		{
			_st = value;
		}
		
		public function get stageText():StageText 
		{
			return _stageText;
		}
		
		public function set stageText(value:StageText):void 
		{
			_stageText = value;
		}
		
		public function get showOnActivate():Boolean 
		{
			return _showOnActivate;
		}
		
		public function set showOnActivate(value:Boolean):void 
		{
			_showOnActivate = value;
		}
		
		public function get globalContext():Sprite 
		{
			return _globalContext;
		}
		
		public function set globalContext(value:Sprite):void 
		{
			_globalContext = value;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		
		
	}

}