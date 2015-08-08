package entities;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;

using flixel.util.FlxSpriteUtil;

class Hud extends FlxTypedGroup<FlxSprite> {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    private var x: Int;
    private var y: Int;

    private var balls: Int;     // From 0 to 3
    private var cash: Float;    // From 0.0 to ~
    private var time: Int;      // From 9 to 18?

    private var ball1: Ball;
    private var ball2: Ball;
    private var ball3: Ball;
    private var background: FlxSprite;
    private var cashIndicator: FlxText;
    private var clock: FlxText;

    public function new(x: Int, y: Int) {
        super();

        this.x = x;
        this.y = y;

        balls = 3;
        cash = 470;
        time = 5;

        background = new FlxSprite().makeGraphic(FlxG.width, 16, FlxColor.GRAY);
        background.x = x;
        background.y = y;
        background.drawRect(0, 0, FlxG.width, 1, FlxColor.WHITE);
        add(background);

        ball1 = new Ball();
        ball1.x = x;
        ball1.y = y;
        add(ball1);

        ball2 = new Ball();
        ball2.x = x + 16;
        ball2.y = y;
        add(ball2);

        ball3 = new Ball();
        ball3.x = x + 32;
        ball3.y = y;
        add(ball3);

        cashIndicator = new FlxText(x + 56, y + 2, 32, cash + "¥");
        add(cashIndicator);

        clock = new FlxText(FlxG.width - 52, y + 2, 48, time + ":00 PM");
        add(clock);

        ball3.setThrown(true);
    }
}
