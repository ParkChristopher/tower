package com.chrisp.objects.entities
{
	import com.chrisp.collision.CollisionManager;
	import com.chrisp.collision.GameObjectType;
	import com.chrisp.objects.AbstractGameObject;
	import com.chrisp.objects.items.AbstractItem;
	import com.chrisp.objects.items.Sword;
	import com.greensock.loading.LoaderMax;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	
	//NOTE: Use bActive variable in base class to trigger invulnerability
	/**
	 * Dictates the functionality and information for a hero character
	 * 
	 * @author Chris Park
	 */
	public class Hero extends AbstractEntity
	{
		/** Movement speed of Hero. */
		public var MOVEMENT_SPEED			:Number = 0;
		/** Weapon used to attack by the hero. */
		private var mcSword					:Sword;	
		/** Signals an attack to Game Screen. */
		public var attackSignal				:Signal = new Signal(AbstractItem);
		/** Signals that the hero has died. */
		public var heroDiedSignal			:Signal = new Signal();
		/** Health update signal */
		public var healthUpdateSignal		:Signal = new Signal(Number);
		/** Turns invulnerability off when triggered. */
		public var invulnerabilityTimer		:Timer;
		/** Used to signal a score multiplier reset */
		public var resetMultiplierSignal	:Signal = new Signal();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Hero object.
		 */
		public function Hero()
		{
			super("Hero", 100);
			this._sObjectType = GameObjectType.TYPE_HERO;
			addCollidableType(GameObjectType.TYPE_ENEMY);
			addCollidableType(GameObjectType.TYPE_COLLECTIBLE);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Initializes the hero object.
		 */
		override public function begin():void
		{
			super.begin();
			
			
			
			this.addEventListener(Event.ENTER_FRAME, checkForAction);
			KeyboardManager.instance.addKeyDownListener(KeyCode.RIGHT, attackRight);
			KeyboardManager.instance.addKeyDownListener(KeyCode.LEFT, attackLeft);
			KeyboardManager.instance.addKeyDownListener(KeyCode.UP, attackUp);
			KeyboardManager.instance.addKeyDownListener(KeyCode.DOWN, attackDown);
			
			parseXML();
			
			this.invulnerabilityTimer = new Timer(2000);
			this.invulnerabilityTimer.addEventListener(TimerEvent.TIMER, becomeVulnerable);
			this.bActive = true;
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends and stops this class.
		 */
		override public function end():void
		{
			super.end();
			
			this.removeEventListener(Event.ENTER_FRAME, checkForAction);
			KeyboardManager.instance.removeKeyDownListener(KeyCode.RIGHT, attackRight);
			KeyboardManager.instance.removeKeyDownListener(KeyCode.LEFT, attackLeft);
			KeyboardManager.instance.removeKeyDownListener(KeyCode.UP, attackUp);
			KeyboardManager.instance.removeKeyDownListener(KeyCode.DOWN, attackDown);
			this.invulnerabilityTimer.stop();
			this.invulnerabilityTimer.removeEventListener(TimerEvent.TIMER, becomeVulnerable);
			this.bActive = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Parses relevant information for this object
		 */
		override protected function parseXML():void
		{
			var xConfig:XML = LoaderMax.getContent("xmlConfig");
			this.MOVEMENT_SPEED = Number(xConfig.gameobjects.hero.moveSpeed);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Checks for events from the player.
		 * 
		 * @param	$e	ENTER_FRAME event.
		 */
		public function checkForAction($e:Event):void
		{
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
				moveRight();
				
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
				moveLeft();
				
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				trace("walk");
				//this.gotoAndPlay("walkNorth");
				//this.walkNorth.play();
				moveUp();
			}	
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
				moveDown();
				
			
		}
			
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the player to the right.
		 */
		private function moveRight():void
		{
			if (this.x > stage.stageWidth - (this.width * 0.5))
				return;
				
			this.x += this.MOVEMENT_SPEED;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the player to the left.
		 */
		private function moveLeft():void
		{
			if (this.x - (this.width * 0.5) <= 0)
				return;
				
			this.x -= this.MOVEMENT_SPEED;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the player to the up.
		 */
		private function moveUp():void
		{
			if (this.y - (this.height * 0.5) <= 0)
				return;
			
			this.y -= this.MOVEMENT_SPEED;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the player to the down.
		 */
		private function moveDown():void
		{
			if (this.y > stage.stageHeight - (this.height * 0.5))
				return;
				
			this.y += this.MOVEMENT_SPEED;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Signals and creates a new attack right
		 */
		public function attackRight():void
		{
			this.mcSword = new Sword(this.x, this.y, "right");
			this.attackSignal.dispatch(mcSword);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Signals and creates a new attack left
		 */
		public function attackLeft():void
		{
			this.mcSword = new Sword(this.x, this.y, "left");
			this.attackSignal.dispatch(mcSword);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		/**
		 * Signals and creates a new attack up
		 */
		public function attackUp():void
		{
			this.mcSword = new Sword(this.x, this.y, "up");
			this.attackSignal.dispatch(mcSword);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Signals and creates a new attack down
		 */
		public function attackDown():void
		{
			this.mcSword = new Sword(this.x, this.y, "down");
			this.attackSignal.dispatch(mcSword);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Makes the hero invulnerable
		 */
		public function becomeInvulnerable():void
		{
			this.bActive = false;
			this.invulnerabilityTimer.start();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Makes the hero vulnerable again.
		 */
		public function becomeVulnerable($e:TimerEvent):void
		{
			this.invulnerabilityTimer.reset();
			this.bActive = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Responses to collision with another object.
		 * 
		 * @param	$object AbstractGameObject
		 */
		override public function collidedWith($object:AbstractGameObject):void
		{
			
			if ($object.objectType == GameObjectType.TYPE_ENEMY)
			{
				if (!this.bActive)
					return;
					
				this.nHealth -= $object.nAttackPower;
				this.healthUpdateSignal.dispatch(this.nHealth);
				this.resetMultiplierSignal.dispatch();
				becomeInvulnerable();
				
				if (this.nHealth <= 0)
					this.heroDiedSignal.dispatch();
					
			}
				
			if ($object.objectType == GameObjectType.TYPE_COLLECTIBLE)
			{
				if (!$object.bActive)
					return;
					
				$object.bActive = false;
				this.nHealth += $object.nValue;
				this.healthUpdateSignal.dispatch(this.nHealth);
				CollisionManager.instance.remove($object);
				$object.cleanupSignal.dispatch($object);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}