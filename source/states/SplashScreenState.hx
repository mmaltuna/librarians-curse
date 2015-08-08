package states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

using flixel.util.FlxSpriteUtil;

class SplashScreenState extends FlxState {

    private var duration: Int;  // SplashScreen duration in seconds
    private var frames: Int;

    override public function create(): Void {
        super.create();

        duration = 2;
        frames = 0;
        add(new FlxText(100, 70, 150, "CHRINOS JAPAN CORP.").screenCenter(true, false));
        add(new FlxText(100, 90, 75, "presents...").screenCenter(true, false));
    }

    override public function update(): Void {
        frames++;
        if (frames == duration * 60)
            FlxG.switchState(new TitleScreenState());
    }
}
