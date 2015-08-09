package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;

using flixel.util.FlxSpriteUtil;

import states.PlayState;

class Player extends Entity {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    var MaxBalls : Int = 3;
    var speed: Float = 100;
    var shootPower : Float = 300;
    var shootDelayTime: Float = 0.15;
    var angleDelta : Float = 5;
    var playerWidth : Float = 12;
    var playerHeight : Float = 8;

    public var balls: FlxTypedGroup<Ball>;

    var state: State;
    var timer: FlxTimer;
    var alreadyShot: Bool;
    var shootAngle : Float;

    var targetHud : FlxSprite;
    var arrowLength : Float = 12;
    var arrowOffset : Float = 6;

    var pointer : FlxSprite;

    public function new(X : Float, Y : Float, World : PlayState) {
        super(X, Y, World);

        loadGraphic("assets/images/char.png", true, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);

        setSize(playerWidth, playerHeight);
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

        targetHud = new FlxSprite(x + playerWidth/2 - arrowLength - arrowOffset,
            y + playerHeight/2 - arrowLength - arrowOffset).makeGraphic(48, 48, 0x00000000);
        world.add(targetHud);

        shootAngle = 270;

        state = State.Movement;
    }

    override public function update() : Void {

        switch (state) {
            case State.Movement:
                hideTargetHud();

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

                    drawTargetHud();

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

    function getShootingOffset() : FlxPoint {
        return new FlxPoint(getMidpoint().x, y-6);
    }

    function shoot() : Void {

        var offset : FlxPoint = getShootingOffset();

        var ball : Ball = balls.getFirstDead();
        ball.revive();
        ball.init(Std.int(offset.x), Std.int(offset.y), shootAngle, shootPower);
    }

    function handleShooting() : Void {

        if (inCounter() && FlxG.keys.anyJustPressed(["A", "Z"]) && balls.getFirstDead() != null) {
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
        }

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
        } else {

            if (inCounter()) {
                animation.play("u");
                animation.paused = true;
            }

        } 
    }

    private function drawTargetHud() : Void {
        
        hideTargetHud();

        targetHud.x = getShootingOffset().x - arrowLength - arrowOffset;
        targetHud.y = getShootingOffset().y - arrowLength - arrowOffset;

        var cos : Float = Math.cos(shootAngle * (Math.PI/180));
        var sin : Float = Math.sin(shootAngle * (Math.PI/180));

        var boxOffset : Float = arrowOffset + arrowLength; // half of the bounding box side
        var offsetX : Float = cos * arrowOffset;
        var offsetY : Float = sin * arrowOffset;
        var targetX : Float = offsetX + cos * arrowLength;
        var targetY : Float = offsetY + sin * arrowLength;

        FlxSpriteUtil.drawLine(targetHud, boxOffset + offsetX, boxOffset + offsetY, boxOffset + targetX,
            boxOffset + targetY, { color: 0xFFAA11AA, thickness: 1});
    }

    private function hideTargetHud() : Void {
        FlxSpriteUtil.fill(targetHud, 0x00000000);
    }

    public function inCounter() : Bool {
        return world.counterArea.containsFlxPoint(this.getMidpoint());
    }

    public static function angleLerp(Angle : Float, Delta : Float) : Float
    {
        Angle += Delta;
        return Math.min(360, Math.max(180, Angle));
    }
}

enum State { Movement; Shooting; }
