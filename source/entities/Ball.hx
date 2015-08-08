package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Ball extends FlxSprite {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    private var thrown: Bool;

    public function new() {
        super(0, 0);

        thrown = false;
        loadGraphic("assets/images/ball.png", 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);
    }

    public override function draw(): Void {
        if (thrown) {
            loadGraphic("assets/images/no-ball.png", 16, 16);
        } else {
            loadGraphic("assets/images/ball.png", 16, 16);
        }
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);

        super.draw();
    }

    public function setThrown(isThrown: Bool): Void {
        thrown = isThrown;
    }
}
