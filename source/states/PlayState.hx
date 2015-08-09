package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;

import entities.Hud;
import entities.Player;
import entities.Ball;

class PlayState extends FlxState {

	var wallColor : Int = 0xFF226900;
	var counterColor : Int = 0xFF888888;

	var hud: Hud;
	public var player: Player;

	var counter : FlxSprite;
	var walls : FlxGroup;

	public var counterArea : FlxRect;

	override public function create(): Void {

		bgColor = 0xFFFFCB91;

		walls = new FlxGroup();
		walls.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, 24, wallColor));
		walls.add(new FlxSprite(0, 0).makeGraphic(4, FlxG.height, wallColor));
		walls.add(new FlxSprite(FlxG.width - 4, 0).makeGraphic(4, FlxG.height, wallColor));
		walls.add(new FlxSprite(0, FlxG.height - 16).makeGraphic(FlxG.width, 16, wallColor));
		add(walls);

		for (wall in walls) {
			cast(wall, FlxObject).immovable = true;
		}

		counter = new FlxSprite(4, FlxG.height - 38).makeGraphic(76, 12, counterColor);
		counter.immovable = true;
		add(counter);

		counterArea = new FlxRect(4, FlxG.height - 26, 68, 10);

		player = new Player(8, FlxG.height - 24, this);
		add(player);

		hud = new Hud(0, FlxG.height - 16);
		add(hud);

		super.create();
	}

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void {

		FlxG.collide(walls, player);
		FlxG.collide(counter, player);
		FlxG.collide(walls, player.balls);
		FlxG.collide(player.balls);
		FlxG.overlap(player.balls, player, onBallPlayerCollision);

		super.update();
	}

	public function onBallPlayerCollision(ball : Ball, player : Player) : Void {
		if (ball.catchable) {
			ball.kill();
			player.velocity.set(0, 0);
		}
	}
}
