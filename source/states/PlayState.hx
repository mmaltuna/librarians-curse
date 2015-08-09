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
import flixel.util.FlxRandom;

import entities.Hud;
import entities.Player;
import entities.Ball;

class PlayState extends FlxState {

	static var wallColor : Int = 0xFF226900;
	static var counterColor : Int = 0xFF888888;
	static var shelvesColor : Int = 0xFFFF7D12;

	var hud: Hud;
	public var player: Player;

	var counter : FlxSprite;
	var walls : FlxGroup;

	var shelves : FlxGroup;

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

		shelves = new FlxGroup();
		generateShelves(shelves);
		add(shelves);

		counter = new FlxSprite(4, FlxG.height - 38).makeGraphic(76, 12, counterColor);
		counter.immovable = true;
		add(counter);

		counterArea = new FlxRect(4, FlxG.height - 26, 68, 10);

		player = new Player(8, FlxG.height - 24, this);
		add(player);

		hud = new Hud(0, FlxG.height - 16, this);
		add(hud);

		super.create();
	}

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void {

		FlxG.collide(walls, player);
		FlxG.collide(counter, player);
		FlxG.collide(shelves, player);

		FlxG.collide(walls, player.balls);
		FlxG.collide(shelves, player.balls);
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

	static function generateShelves(shelves : FlxGroup) : Void {

		var offsetX : Int = 16;
		var offsetY : Int = 48;

		var xx : Int = offsetX + FlxRandom.intRanged(-4, 4);
		var yy : Int = 0;

		var numShelves : Int = FlxRandom.intRanged(0, 4);

		for (i in 0...numShelves)
		{
			yy = offsetY + FlxRandom.intRanged(0, 8);

			var shelf : FlxSprite = new FlxSprite(xx, yy).makeGraphic(getShelfWidth(), getShelfHeight(), shelvesColor);
			shelf.immovable = true;
			shelves.add(shelf);

			xx += Std.int(shelf.width + getAlleyWidth(numShelves));
		}
	}

	static function getShelfWidth() : Int {
		var baseWidth : Int = 24;
		var widthFactor : Float = 0.2;

		return baseWidth + FlxRandom.intRanged(Std.int(-baseWidth * widthFactor), Std.int(baseWidth * widthFactor));
	}

	static function getShelfHeight() : Int {
		var baseHeight : Int = 48;
		var heightFactor : Float = 0.2;

		return baseHeight + FlxRandom.intRanged(Std.int(-baseHeight * heightFactor), Std.int(baseHeight * heightFactor));
	}

	static function getAlleyWidth(numShelves : Int) : Int {
		var alleyWidth : Int = Std.int((FlxG.width - 32) / numShelves - 24);
		var alleyFactor : Float = 0.2;

		return alleyWidth + FlxRandom.intRanged(Std.int(-alleyWidth * alleyFactor), Std.int(alleyWidth * alleyFactor));
	}
}
