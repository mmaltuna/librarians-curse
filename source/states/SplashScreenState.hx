package states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class SplashScreenState extends FlxState {

    private var duration: Int;
    private var frames: Int;

    override public function create(): Void {
        super.create();

        duration = 3;
        frames = 0;
        add(new FlxText(100, 50, 100, "TwoLegged Studio presents..."));
    }

    override public function update(): Void {
        frames++;
        if (frames == duration * 60)
            FlxG.switchState(new TitleScreenState());
    }
}
