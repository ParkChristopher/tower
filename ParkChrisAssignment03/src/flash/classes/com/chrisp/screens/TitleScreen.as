package com.chrisp.screens
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * Controls the game flow and transitions between screens.
	 * 
	 * @author Chris Park
	 */
	public class TitleScreen extends AbstractScreen
	{
		public var btPlay 			:SimpleButton;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function TitleScreen()
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
			this.visible = true;
			this.btPlay.addEventListener(MouseEvent.CLICK, playClicked);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends use of this screen.
		 */
		override public function end():void
		{
			this.visible = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Signals that the play button has been clicked.
		 * 
		 * @param	$e		MouseEvent.
		 */
		private function playClicked($e:MouseEvent):void
		{
			this.screenCompleteSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
	}
}