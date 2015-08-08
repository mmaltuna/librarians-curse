package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Ball extends FlxSprite {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    public function new() {
        super(0, 0);

        loadGraphic(AssetPaths.ball__png, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);
    }
}
