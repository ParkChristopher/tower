package com.chrisp.screens
{
	import com.chrisp.screens.AbstractScreen;
	import com.greensock.core.SimpleTimeline;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.*;
	import treefortress.sound.SoundAS;

	
	/**
	 * Controls operation of the credits screen.
	 * 
	 * @author Chris Park
	 */
	public class CreditsScreen extends FadeScreen
	{
		/** Returns control to the title screen*/
		public var btCreditsReturn	:SimpleButton;
		/** Sends an email. */
		public var btEmail			:SimpleButton;
		/** Personal picture*/
		public var mcMe				:MovieClip;
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the CreditsScreen object.
		 */
		public function CreditsScreen()
		{
			super();
			
			this.mouseEnabled	= true;
			this.mouseChildren	= true;
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Initializes this screen.
		 */
		override public function begin():void
		{
			super.begin();
			
			this.btCreditsReturn.addEventListener(MouseEvent.CLICK, returnClicked);
			this.btEmail.addEventListener(MouseEvent.CLICK, emailClicked);
			
		}
		
		/**
		 * Shows the screen and initializes any properties associated with the screen starting.
		 */
		/* ---------------------------------------------------------------------------------------- */		
		
			override public function show():void
		{
			super.show();
			
			SoundAS.fadeTo("ResultsMusic", 1);
			SoundAS.playLoop("ResultsMusic");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends use of this screen.
		 */
		override public function end():void
		{
			super.end();
			
			this.btCreditsReturn.removeEventListener(MouseEvent.CLICK, returnClicked);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Hides the screen and performs any actions related to the screen ending.
		 */
		override public function hide():void
		{
			super.hide();
			
			SoundAS.fadeTo("ResultsMusic", 0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Opens the local email client with the given address
		 */
		public function emailClicked($e:MouseEvent):void
		{
			SoundAS.playFx("ButtonSound");
			navigateToURL(new URLRequest("mailto:christopherpark@eagles.ewu.edu"), "_blank");
			trace("url call finished");
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Signals for return to the title screen.
		 * 
		 * @param	$e Mouse Event.
		 */
		public function returnClicked($e:MouseEvent):void
		{
			SoundAS.playFx("ButtonSound");
			this.end();
			this.screenCompleteSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

