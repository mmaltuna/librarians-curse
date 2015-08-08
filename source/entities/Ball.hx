package entities;

import flixel.util.FlxAngle;
using flixel.util.FlxSpriteUtil;

import states.PlayState;

class Ball extends Entity
{
	public var catchable : Bool;

	public function new(X : Float, Y : Float, World : PlayState) {
		super(X, Y, World);

		loadGraphic("assets/images/ball.png");
		setSize(8, 8);
		offset.set(4, 4);
	}

	public function init(X : Float, Y : Float, Alpha : Float, Speed : Float) : Void {
		
		x = X;
		y = Y;

		FlxAngle.rotatePoint(Speed, 0, 0, 0, Alpha, velocity);

		elasticity = 0.4;

		trace(drag);
		drag.set(50, 50);

		catchable = false;
	}

	override public function update() : Void
	{
		if (!catchable) {
			if (!overlaps(world.player))
				catchable = true;
		}

		super.update();
	}
}