package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import entities.Hud;

class PlayState extends FlxState {
	private var hud: Hud;

	override public function create(): Void {
		hud = new Hud();
		add(hud);

		super.create();
	}

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void {
		super.update();
	}
}
