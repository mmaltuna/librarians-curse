package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;

class TitleScreenState extends FlxState
{

	private var newGameButton: FlxButton;
	private var continueButton: FlxButton;

	override public function create(): Void {
		super.create();
		add(new FlxText(100, 50, 100, "Librarian's Curse").screenCenter(true, false));

		newGameButton = new FlxButton(160, 80, "New Game", clickNewGame);
		continueButton = new FlxButton(160, 100, "Continue", null);

		add(newGameButton);
		add(continueButton);

		newGameButton.screenCenter(true, false);
		continueButton.screenCenter(true, false);
	}

	override public function destroy(): Void {
		super.destroy();

		newGameButton = FlxDestroyUtil.destroy(newGameButton);
		continueButton = FlxDestroyUtil.destroy(continueButton);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(): Void {
		super.update();
	}

	public function clickNewGame(): Void {
		FlxG.switchState(new PlayState());
	}
}
