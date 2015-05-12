package view.components.ui.screenPanels 
{


	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.NotificationLabel;
	import staticData.HexColours;
	import staticData.Inventory;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SpriteSheets;
	import view.components.screens.SuperScreen;
	import view.components.ui.CreditListItem;
	import view.components.ui.SuperPanel;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class CreditsPanel extends SuperPanel
	{
		private const DYNAMIC_TA_REF:String = "CreditsPanel";

		private var _core:Core;
		private var _simTop:Image;
		private var _simFooter:Image;
		private var _simContent:Image;
		private var _ssplistHolder:Sprite;
		private var _simLogos:Image;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function CreditsPanel() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			
			trace(this + "inited");
			_ssplistHolder = new Sprite();
			var h:int;
			var w:int;
			//-------o
			//top section
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_shortHeader") as MovieClip;
			mc.$mcIcon.gotoAndStop("carlFly")
			h = mc.$mcHeader.height;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_shortHeader", null, 1, 1, null, 0)
			_simTop = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_shortHeader").getImage();
			_simTop.x = 0;
			this.addChild(_simTop);
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_creditsContent") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_creditsContent", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_creditsContent").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			w = _simContent.width;
			
			//-------o
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_creditsContent") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_creditsContent", null, 1, 1, null, 0)
			_simContent = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_creditsContent").getImage();
			_simContent.y = _simTop.y + h;
			this.addChild(_simContent);
			
			
			_ssplistHolder.width = _simContent.width;
			var quFill:Quad = new Quad(w, 100, 0xf1f1f1);
			_ssplistHolder.addChild(quFill);
			//sub text
			var txMaccasTeam:TextField = new TextField(_simContent.width, 50, "MACCA'S TEAM", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.FONT_GREY);
			txMaccasTeam.hAlign = HAlign.CENTER; 
			txMaccasTeam.vAlign = VAlign.TOP;
			txMaccasTeam.x = 0
			txMaccasTeam.y = 10;
			txMaccasTeam.autoSize = TextFieldAutoSize.VERTICAL;
			txMaccasTeam.autoSize = TextFieldAutoSize.VERTICAL;
			_ssplistHolder.addChild(txMaccasTeam);
			_ssplistHolder.y = _simContent.y + (_simContent.height - 5);
			this.addChild(_ssplistHolder)
			
			var ken1:CreditListItem = new CreditListItem(1, "KEN", "For the holiday stories while we were pulling the late shifts");
			ken1.y = txMaccasTeam.y + txMaccasTeam.height+ 15;
			ken1.x = w / 2;
			_ssplistHolder.addChild(ken1)
						
			var mark:CreditListItem = new CreditListItem(3, "MARK", "For saying “yes” and meaning yes even when he said “no”");
			mark.y = ken1.y + ken1.height+ 15;
			mark.x = w / 2;
			_ssplistHolder.addChild(mark)
			
			var renato:CreditListItem = new CreditListItem(4, "RENATO", "For being a living SOW god!!!");
			renato.y = mark.y + mark.height+ 15;
			renato.x = w / 2;
			_ssplistHolder.addChild(renato)
			
			var tx3rdsenseTeam:TextField = new TextField(_simContent.width, 50, "THE 3RDSENSE TEAM", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.FONT_GREY);
			tx3rdsenseTeam.hAlign = HAlign.CENTER; 
			tx3rdsenseTeam.vAlign = VAlign.TOP;
			tx3rdsenseTeam.x = 0
			tx3rdsenseTeam.y = renato.y + renato.height + 20;
			tx3rdsenseTeam.autoSize = TextFieldAutoSize.VERTICAL;
			_ssplistHolder.addChild(tx3rdsenseTeam);
			
			var colin:CreditListItem = new CreditListItem(5, "COLIN", "For good and bad dad jokes");
			colin.y = tx3rdsenseTeam.y + tx3rdsenseTeam.height+ 25;
			colin.x = w / 2;
			_ssplistHolder.addChild(colin)
						
			var john:CreditListItem = new CreditListItem(6, "JOHN", "For all the ones and zeroes");
			john.y = colin.y + colin.height - 10;
			john.x = w / 2;
			_ssplistHolder.addChild(john)
					
			var dean:CreditListItem = new CreditListItem(2, "DEAN", "For having the cutest backend in the office");
			dean.y = john.y + john.height - 10;
			dean.x = w / 2;
			_ssplistHolder.addChild(dean)
			
			var sarah:CreditListItem = new CreditListItem(7, "SARAH", "For her passion for burgers");
			sarah.y = dean.y + dean.height + 20;
			sarah.x = w / 2;
			_ssplistHolder.addChild(sarah)
			
			var steve:CreditListItem = new CreditListItem(8, "STEVE", "For being better than most other Steves");
			steve.y = sarah.y + sarah.height - 10;
			steve.x = w / 2;
			_ssplistHolder.addChild(steve)
			
			
			var ddbTeam:TextField = new TextField(_simContent.width, 50, "DDB TEAM", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.FONT_GREY);
			ddbTeam.hAlign = HAlign.CENTER; 
			ddbTeam.vAlign = VAlign.TOP;
			ddbTeam.x = 0
			ddbTeam.y = steve.y + steve.height + 20;
			ddbTeam.autoSize = TextFieldAutoSize.VERTICAL;
			_ssplistHolder.addChild(ddbTeam);
			
			var michael:CreditListItem = new CreditListItem(9, "MICHAEL", " For helping us reach our beard quota");
			michael.y = ddbTeam.y + ddbTeam.height+ 25;
			michael.x = w / 2;
			_ssplistHolder.addChild(michael)
						
			var lazrus:CreditListItem = new CreditListItem(10, "LAZRUS", "For nothing... no really, nothing");
			lazrus.y = michael.y + michael.height+ 25;
			lazrus.x = w / 2;
			_ssplistHolder.addChild(lazrus)
									
			var david:CreditListItem = new CreditListItem(11, "DAVID", "For his overarching tallness");
			david.y = lazrus.y + lazrus.height - 10;
			david.x = w / 2;
			_ssplistHolder.addChild(david)
			
			var dom:CreditListItem = new CreditListItem(12, "DOM", "For being a typical artiste");
			dom.y = david.y + david.height - 10;
			dom.x = w / 2;
			_ssplistHolder.addChild(dom)
			
			var kevinText:String = "For the slightly ginga tinge, you inspired our echidna";
			if (PublicSettings.LOCATION != "AU")
			kevinText = "For having above average talent to counterbalance an average name";
			var kevin:CreditListItem = new CreditListItem(13, "KEVIN", kevinText);
			kevin.y = dom.y + dom.height - 10;
			kevin.x = w / 2;
			_ssplistHolder.addChild(kevin)
				
			var ramonText:String = "For a good time : 0420 726 187";
			if (PublicSettings.LOCATION != "AU")
			ramonText = "For a good time : 022 195 4619";
			
			var Ramon:CreditListItem = new CreditListItem(14, "RAMON", ramonText);
			Ramon.y = kevin.y + kevin.height+ 15;
			Ramon.x = w / 2;
			_ssplistHolder.addChild(Ramon)
			
			var somphors:CreditListItem = new CreditListItem(15, "SOMPHORS", "For producing something out of nothing");
			somphors.y = Ramon.y + Ramon.height - 10;
			somphors.x = w / 2;
			_ssplistHolder.addChild(somphors)
			
			
			var lisa:CreditListItem = new CreditListItem(16, "LISA", "For being late to meetings");
			lisa.y = somphors.y + somphors.height - 10;
			lisa.x = w / 2;
			_ssplistHolder.addChild(lisa)
									
			var tim:CreditListItem = new CreditListItem(17, "TIM", "For the posh accent");
			tim.y = lisa.y + lisa.height - 10;
			tim.x = w / 2;
			_ssplistHolder.addChild(tim)
			
			var chris:CreditListItem = new CreditListItem(18, "CHRIS", "For coming in at the end and hogging all the glory");
			chris.y = tim.y + tim.height - 10;
			chris.x = w / 2;
			_ssplistHolder.addChild(chris)
			
			var music:TextField = new TextField(_simContent.width, 50, "NUG ZONE MUSIC", AppFonts.FONT_FUTURA_CONDENSED, 30, HexColours.FONT_GREY);
			music.hAlign = HAlign.CENTER; 
			music.vAlign = VAlign.TOP;
			music.x = 0
			music.y = chris.y + chris.height + 40;
			music.autoSize = TextFieldAutoSize.VERTICAL;
			_ssplistHolder.addChild(music);
			
			var link:CreditListItem = new CreditListItem(19, "BENSOUND", "http://www.bensound.com/royalty-free-music", "http://www.bensound.com/royalty-free-music");
			link.y = music.y + music.height+ 25;
			link.x = w / 2;
			_ssplistHolder.addChild(link)
			
			var lastlyText:String = "Lastly, thanks to all the players of the world. We love youse all.";
			if (PublicSettings.LOCATION != "AU")
			lastlyText = "Lastly, thanks to all the players of the world. You’re all ‘O’ for orsome!";
			var lastly:CreditListItem = new CreditListItem(20, "", lastlyText);
			lastly.y = link.y + link.height+ 15;
			lastly.x = w / 2;
			_ssplistHolder.addChild(lastly)
			
			
			//content Area
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_logos") as MovieClip;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_logos", null, 1, 1, null, 0)
			_simLogos = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_logos").getImage();
			_simLogos.x = 100;
			_simLogos.y = lastly.y + lastly.height + 50;
			_ssplistHolder.addChild(_simLogos);
			
			mc = null;

			quFill.height = _ssplistHolder.height + 50;
			
			var textVersion:TextField = new TextField(AppData.deviceResX, 100, PublicSettings.VERSION, AppFonts.FONT_ARIAL, 10, HexColours.BLACK);
			textVersion.hAlign = HAlign.LEFT; 
			textVersion.vAlign = VAlign.TOP;
			textVersion.border = false;
			textVersion.x = 5// Math.floor(Data.deviceScaleX *20);
			textVersion.y = quFill.y + quFill.height - 20;
			textVersion.autoSize = TextFieldAutoSize.VERTICAL;
			_ssplistHolder.addChild(textVersion);
		}

		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
		}
		
		
	}

}