package entities;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;

import states.PlayState;

enum CurseState { HIDDEN; HIDING; APPEARING; STEALING; }

class Curse extends Entity {

    public static inline var TRANSPARENT_BG: Int = 0xFFFF00FF;

    static var timeToAppear : Float = 1;        // Seconds to appear
    static var timeToDisappear : Float = 0.2;   // Seconds to disappear
    static var timeToSteal : Float = 1;         // Seconds to steal again
    static var amountToSteal : Float = 100;     // Yens to steal each time
    static var stepsToAppear : Int = 12;

    var state : CurseState;
    var stealingTimer : FlxTimer;
    var showingTimer : FlxTimer;

    public function new(x : Float, y : Float, world : PlayState) {
        super(x, y, world);

        state = CurseState.HIDDEN;

        loadGraphic("assets/images/curse.png", false, 16, 16);
        replaceColor(TRANSPARENT_BG, FlxColor.TRANSPARENT);
    }

    override public function update() : Void {
        switch (state) {
            case CurseState.HIDDEN:
                if (!world.player.inCounter())
                    startsAppearing();

            case CurseState.HIDING:
                if (showingTimer.loopsLeft == 0)
                    state = CurseState.HIDDEN;

            case CurseState.APPEARING:
                if (showingTimer.loopsLeft == 0) {
                    state = CurseState.STEALING;
                    if (stealingTimer != null)
                        stealingTimer.start(timeToSteal, onStealing, 0);
                    else
                        stealingTimer = new FlxTimer(timeToSteal, onStealing, 0);
                }

                if (world.player.inCounter())
                    startsHiding();

            case CurseState.STEALING:
                if (world.player.inCounter())
                    startsHiding();
        }
    }

    private function startsHiding() : Void {
        state = CurseState.HIDING;

        if (stealingTimer != null)
            stealingTimer.cancel();

        if (showingTimer != null) {
            var loopsLeft = showingTimer.loopsLeft;
            showingTimer.start(timeToDisappear / (stepsToAppear - loopsLeft), onHiding, stepsToAppear - loopsLeft);
        } else {
            showingTimer = new FlxTimer(timeToDisappear / stepsToAppear, onHiding, stepsToAppear);
        }
    }

    private function startsAppearing() : Void {
        state = CurseState.APPEARING;

        if (showingTimer != null) {
            var loopsLeft = showingTimer.loopsLeft;
            showingTimer.start(timeToAppear / (stepsToAppear - loopsLeft), onShowing, stepsToAppear - loopsLeft);
        } else {
            showingTimer = new FlxTimer(timeToAppear / stepsToAppear, onShowing, stepsToAppear);
        }
    }

    private function onShowing(timer: FlxTimer) : Void {
        y--;
    }

    private function onHiding(timer: FlxTimer) : Void {
        y++;
    }

    private function onStealing(timer: FlxTimer) : Void {
        world.hud.steal(amountToSteal);
    }
}
