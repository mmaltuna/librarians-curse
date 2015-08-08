package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.FlxG;
import flixel.FlxObject;

class Player extends FlxSprite {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    private var speed: Float = 200;

    public function new() {
        super(20, 20);

        loadGraphic("assets/images/char.png", true, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);

        animation.add("u", [4, 5, 6, 7], 4, false);
        animation.add("d", [0, 1, 2, 3], 0, false);
        animation.add("l", [8, 9, 8], 8, false);
        animation.add("r", [10, 11, 10], 10, false);

        drag.x = 1600;
        drag.y = 1600;
    }

    override public function update() : Void {
        movement();
        super.update();
    }

    private function movement(): Void {
        var up: Bool = FlxG.keys.anyPressed(["UP", "W"]);
        var down: Bool = FlxG.keys.anyPressed(["DOWN", "S"]);
        var left: Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
        var right: Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);

        if (up && down) {
            up = false;
            down = false;
        }

        if (left && right) {
            left = false;
            right = false;
        }

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
            }
        }
    }
}
