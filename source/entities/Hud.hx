package entities;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;

using flixel.util.FlxSpriteUtil;

import states.PlayState;

class Hud extends FlxTypedGroup<FlxSprite> {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    private var world : PlayState;

    private var x: Int;
    private var y: Int;

    private var cash: Float;    // From 0.0 to ~
    private var time: Int;      // From 9 to 18?

    private var balls: Array<HudBall>;
    private var background: FlxSprite;
    private var cashIndicator: FlxText;
    private var clock: FlxText;

    public function new(x: Int, y: Int, World: PlayState) {
        
        super();

        this.x = x;
        this.y = y;

        this.world = World;

        cash = 470;
        time = 5;

        background = new FlxSprite().makeGraphic(FlxG.width, 16, FlxColor.GRAY);
        background.x = x;
        background.y = y;
        background.drawRect(0, 0, FlxG.width, 1, FlxColor.WHITE);
        add(background);

        balls = new Array<HudBall>();
        for (i in 0...3) {
            var ball = new HudBall();
            ball.x = x + i*16;
            ball.y = y;
            balls.push(ball);
            add(ball);                        
        }

        cashIndicator = new FlxText(x + 56, y + 2, 32, cash + "¥");
        add(cashIndicator);

        clock = new FlxText(FlxG.width - 52, y + 2, 48, time + ":00 PM");
        add(clock);

        balls[2].setThrown(true);
    }

    override public function update() : Void {

        var availableBalls : Int = world.player.balls.countDead();

        for (i in 0...availableBalls) {
            balls[i].setThrown(false);
        }

        for (i in availableBalls...balls.length) {
            balls[i].setThrown(true);
        }

        super.update();
    }
}
