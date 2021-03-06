package com.chrisp.objects.items
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.chrisp.collision.CollisionManager;
	import com.chrisp.collision.GameObjectType;
	import com.chrisp.objects.AbstractGameObject;
	import com.natejc.utils.StageRef;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.loading.LoaderMax;
	import treefortress.sound.SoundAS;
	
	/**
	 * Dicatates behavior of the hero's sword attack
	 * 
	 * @author Chris Park
	 */
	public class Sword extends AbstractItem
	{
		/** Direction of travel. */
		public var sDirection			:String;
		/** Movement speed of the sword.*/
		public var MOVEMENT_SPEED			:Number = 0;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Sword object.
		 */
		public function Sword($startX:Number, $startY:Number, $direction:String)
		{
			super("sword");
			
			this._sObjectType = GameObjectType.TYPE_WEAPON;
			addCollidableType(GameObjectType.TYPE_ENEMY);
			
			this.x = $startX;
			this.y = $startY;
			//this.nAttackPower = 8;
			this.sDirection = $direction;
			rotate();
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Initializes the hero's sword.
		 */
		override public function begin():void
		{
			super.begin();
			
			parseXML();
			this.bActive = true;
			this.movementTimer = new Timer(30);
			this.movementTimer.addEventListener(TimerEvent.TIMER, move);
			this.movementTimer.start();
			
			SoundAS.playFx("SwordThrowSound", 1);
			
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Cleans up the hero's sword.
		 */
		override public function end():void
		{
				super.end();
				this.movementTimer.stop();
				this.movementTimer.removeEventListener(TimerEvent.TIMER, move);
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Parses relevant information for this object
		 */
		override protected function parseXML():void
		{
			var xConfig:XML = LoaderMax.getContent("xmlConfig");
			this.MOVEMENT_SPEED = Number(xConfig.gameobjects.sword.moveSpeed);
			this.nAttackPower = Number(xConfig.gameobjects.sword.attackPower);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Rotates the sword to point in the direction it travels.
		 */
		public function rotate():void
		{
			if (sDirection == "right")
				this.rotation += 90;
				
			if (sDirection == "left")
				this.rotation -= 90;
			
			if (sDirection == "down")
				this.rotation += 180;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Handles movement of the sword across the screen.
		 * 
		 * @param $e	TimerEvent.
		 */
		public function move($e:TimerEvent):void
		{	
			if (this.sDirection == "right")
			{
				if (this.x > StageRef.stage.stageWidth)
				{
					this.bActive = false;
					CollisionManager.instance.remove(this);
					this.cleanupSignal.dispatch(this);
					return;
				}
				
				this.x += MOVEMENT_SPEED;
			}
			
			if (this.sDirection == "left")
			{
				if (this.x < 0)
				{
					this.bActive = false;
					CollisionManager.instance.remove(this);
					this.cleanupSignal.dispatch(this);
					return;
				}
				
				this.x -= MOVEMENT_SPEED;
			}
			
			if (this.sDirection == "up")
			{
				if (this.y < 0)
				{
					this.bActive = false;
					CollisionManager.instance.remove(this);
					this.cleanupSignal.dispatch(this);
					return;
				}
				
				this.y -= MOVEMENT_SPEED;
			}
			
			if (this.sDirection == "down")
			{
				if (this.y > StageRef.stage.stageHeight)
				{
					this.bActive = false;
					CollisionManager.instance.remove(this);
					this.cleanupSignal.dispatch(this);
					return;
				}
				
				this.y += MOVEMENT_SPEED;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Responses to collision with another object.
		 * 
		 * @param	$object AbstractGameObject.
		 */
		override public function collidedWith($object:AbstractGameObject):void
		{
			if ($object.objectType == GameObjectType.TYPE_ENEMY)
			{	
				if(!this.bActive)
					return;
				
				$object.nHealth -= this.nAttackPower;
				TweenLite.to($object, .1, { tint:0xffffff } );
				TweenLite.to($object, .2, { removeTint:true } );
				
				
				if ($object.nHealth <= 0)
				{
					SoundAS.playFx("GhostDeathSound");
					$object.bActive = false;
					CollisionManager.instance.remove($object);
					$object.cleanupSignal.dispatch($object);
				}
				
				this.bActive = false;
				CollisionManager.instance.remove(this);
				this.cleanupSignal.dispatch(this);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

