package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;

class Hud extends FlxTypedGroup<FlxSprite> {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    private var balls: Int;     // From 0 to 3
    private var cash: Float;    // From 0.0 to ~
    private var time: Int;      // From 9 to 18?

    private var ball1: Ball;
    private var ball2: Ball;
    private var ball3: Ball;

    public function new() {
        super();

        balls = 3;
        cash = 0.0;
        time = 9;

        //makeGraphic(320, 16, FlxColor.BLUE);
        /*loadGraphic(AssetPaths.ball__png, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);*/

        ball1 = new Ball();
        ball1.x = 0;
        ball1.y = 224;
        add(ball1);

        ball2 = new Ball();
        ball2.x = 16;
        ball2.y = 224;
        add(ball2);

        ball3 = new Ball();
        ball3.x = 32;
        ball3.y = 224;
        add(ball3);
    }
}
