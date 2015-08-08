package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;

using flixel.util.FlxSpriteUtil;

import states.PlayState;

class Player extends Entity {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    var MaxBalls : Int = 3;
    var speed: Float = 100;
    var shootDelayTime: Float = 0.15;
    var angleDelta : Float = 5;

    public var balls: FlxTypedGroup<Ball>;

    var state: State;
    var timer: FlxTimer;
    var alreadyShot: Bool;
    var shootAngle : Float;

    var arrow : FlxSprite;

    var pointer : FlxSprite;

    public function new(X : Float, Y : Float, World : PlayState) {
        super(X, Y, World);

        loadGraphic("assets/images/char.png", true, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);

        setSize(12, 8);
        offset.set(2, 8);

        animation.add("u", [4, 5, 6, 7], 10, true);
        animation.add("d", [0, 1, 2, 3], 10, true);
        animation.add("l", [8, 9, 8, 9], 10, true);
        animation.add("r", [10, 11, 10, 11], 10, true);

        drag.x = 1600;
        drag.y = 1600;

        timer = new FlxTimer();

        balls = new FlxTypedGroup<Ball>(MaxBalls);
        for (i in 0...MaxBalls) {
            var ball : Ball = new Ball(x, y, world);
            ball.kill();
            balls.add(ball);
        }
        world.add(balls);

        arrow = new FlxSprite(x, y).makeGraphic(48, 48, 0x00000000);
        // world.add(arrow);
        pointer = new FlxSprite(x, y).makeGraphic(1, 1, 0xFFA111A1);
        world.add(pointer);

        shootAngle = 90;

        state = State.Movement;
    }

    override public function update() : Void {

        switch (state) {
            case State.Movement:
                // Handle movement
                movement();

                // Handle shooting
                handleShooting();

                color = 0xFFFFFFFF;
            
            case State.Shooting:

                if (!alreadyShot) {

                    if (FlxG.keys.anyPressed(["LEFT"])) {
                        shootAngle = angleLerp(shootAngle, -angleDelta);
                    } else if (FlxG.keys.anyPressed(["RIGHT"])) {
                        shootAngle = angleLerp(shootAngle, angleDelta);
                    }

                    drawArrow();

                    if (FlxG.keys.anyJustReleased(["A", "Z"])) {
                        // Shoot
                        shoot();

                        color = 0xFF0000FF;

                        timer.start(shootDelayTime, function(_t:FlxTimer){
                            alreadyShot = true;
                            state = State.Movement;
                        });

                    } else if (FlxG.keys.anyJustPressed(["DOWN"])) {
                        state = State.Movement;
                    }

                    color = 0xFFFF0000;
                }
        }

        super.update();
    }

    function shoot() : Void {

        var offsetX : Float = getMidpoint().x;
        var offsetY : Float = y - 6;

        var ball : Ball = balls.recycle(Ball);
        ball.init(offsetX, offsetY, shootAngle, 200);
    }

    function handleShooting() : Void {

        if (inCounter() && FlxG.keys.anyJustPressed(["A", "Z"])) {
            state = State.Shooting;
            alreadyShot = false;
        }

    }

    private function movement(): Void {
        var up: Bool = FlxG.keys.anyPressed(["UP"]);
        var down: Bool = FlxG.keys.anyPressed(["DOWN"]);
        var left: Bool = FlxG.keys.anyPressed(["LEFT"]);
        var right: Bool = FlxG.keys.anyPressed(["RIGHT"]);

        if (up && down) {
            up = false;
            down = false;
        }

        if (left && right) {
            left = false;
            right = false;
        }

        animation.paused = true;

        if (up || down || left || right) {
            var angle: Float = 0;
            if (up) {
                angle = -90;
                if (left) angle -= 45;
                if (right) angle += 45;

                facing = FlxObject.UP;
            } else if (down) {
                angle = 90;
                if (left) angle += 45;
                if (right) angle -= 45;

                facing = FlxObject.DOWN;
            } else if (left) {
                angle = 180;
                facing = FlxObject.LEFT;
            } else if (right) {
                angle = 0;
                facing = FlxObject.RIGHT;
            }

            FlxAngle.rotatePoint(speed, 0, 0, 0, angle, velocity);

            if (velocity.x != 0 || velocity.y != 0) {
                switch (facing) {
                    case FlxObject.UP:
                        animation.play("u");
                    case FlxObject.DOWN:
                        animation.play("d");
                    case FlxObject.LEFT:
                        animation.play("l");
                    case FlxObject.RIGHT:
                        animation.play("r");
                }

                animation.paused = false;
            }
        }
    }

    private function drawArrow() : Void {
        var offsetLength : Float = 4;
        var arrowLength : Float = 12;
        var cos : Float = Math.cos(shootAngle * (Math.PI/180));
        var sin : Float = Math.sin(shootAngle * (Math.PI/180));
        var offsetX : Float = getMidpoint().x + cos * offsetLength;
        var offsetY : Float = getMidpoint().y + sin * offsetLength;
        var targetX : Float = offsetX + cos * arrowLength;
        var targetY : Float = offsetY + sin * arrowLength;

        // FlxSpriteUtil.drawLine(arrow, offsetX, offsetY, targetX, targetY, { color: 0xFFAA11AA, thickness: 1});
        // arrow.draw();
        pointer.x = targetX;
        pointer.y = targetY;
    }

    public function inCounter() : Bool {
        return world.counterArea.containsFlxPoint(this.getMidpoint());
    }

    public static function angleLerp(Angle : Float, Delta : Float) : Float
    {
        Angle += Delta;

        if (Angle >= 360)
            Angle = Angle - 360;
        else if (Angle < 0)
            Angle = 360 + Angle;

        trace(Angle);

        return Angle;
    }
}

enum State { Movement; Shooting; }
