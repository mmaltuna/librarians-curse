package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import entities.Hud;
import entities.Player;

class PlayState extends FlxState {
	private var hud: Hud;
	private var player: Player;

	override public function create(): Void {
		hud = new Hud(0, 224);
		add(hud);

		player = new Player();
		add(player);

		super.create();
	}

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void {
		super.update();
	}
}
