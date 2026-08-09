import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

var opponentLoopActive:Bool = false;

var oppDecreaseDuration:Float = 1.0;
var oppWaitDuration:Float = 1.0;
var oppReverseDuration:Float = 1.5;
var oppCancelFadeDuration:Float = 1.5;
var oppReverseTargetAlpha:Float = 0.005;

var oppTween:FlxTween;
var oppTimer:FlxTimer;

function create()
{
    offsetBF();
    offsetOpponent();

    opponent[1].alpha = 0; // for loop
    opponent[2].visible = false;
    player[1].visible = false;
    player[2].visible = false;
    player[3].visible = false;


    opponent[2].animation.finishCallback = function(name:String) {
        if (name == "guitar") {
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                opponent[2].visible = false;
                opponent[0].visible = true;
            });
        }
    };
}

function beatHit(_)
{
    switch(_)
    {
        case 72:
            setOpponentLoop(true);

        case 198:
            setOpponentLoop(false);

        case 200:
            player[0].visible = false;
            player[1].visible = true;

        case 328:
            setOpponentLoop(true);

        case 392:
            setOpponentLoop(false);

        case 456:
            opponent[0].visible = false;
            opponent[2].visible = true;
            opponent[2].playAnim('guitar', true, false);
            player[1].visible = false;
            player[0].visible = true;

        // case 488 handled dynamically (Thank you Trill)

        case 519:
            opponent[2].visible = false; // playtesting hooha

        case 520:
            tweenTo(opponent[0], {alpha: 0}, 5);

        case 532:
            player[0].visible = false;
            player[1].visible = true;

        case 574:
            player[1].visible = false;
            player[2].visible = true;

        case 625:
            player[2].visible = false;
            player[3].visible = true;
            player[3].playAnim('ohnoes', 24, false);

    }
}

function offsetBF()
{
    player[0].cameraOffset.x -= 200;
    player[0].cameraOffset.y -= 50;
    player[1].x -= 20;
    player[1].cameraOffset.x -= 180;
    player[1].cameraOffset.y -= 50;
    player[2].x -= 40;
    player[2].cameraOffset.x -= 160;
    player[2].cameraOffset.y -= 50;
    player[3].x -= 110;
    player[3].y += 5;
    player[3].cameraOffset.x -= 90;
    player[3].cameraOffset.y -= 45;
}

function offsetOpponent()
{
    opponent[0].x += 50;
    opponent[0].y += 40;
    opponent[0].cameraOffset.y += 70;
    opponent[1].x += 30;
    opponent[1].y += 40;
    opponent[1].cameraOffset.y += 70;
    opponent[2].x += 50;
    opponent[2].y += 30;
}

function setOpponentLoop(enable:Bool)
{
    if (opponentLoopActive == enable) return;
    
    opponentLoopActive = enable;

    if (oppTween != null) {
        oppTween.cancel();
        oppTween = null;
    }
    if (oppTimer != null) {
        oppTimer.cancel();
        oppTimer = null;
    }

    if (opponentLoopActive) {
        startOpponentSequence();
    } else if (opponent[1].alpha != 0) {
        oppTween = FlxTween.tween(opponent[1], {alpha: 0.0}, oppCancelFadeDuration);
    }
}

function startOpponentSequence()
{
    if (!opponentLoopActive) return;
        oppTween = FlxTween.tween(opponent[1], {alpha: 1.0}, oppDecreaseDuration, {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween) {
                if (!opponentLoopActive) return;

                oppTimer = new FlxTimer().start(oppWaitDuration, function(tmr:FlxTimer) {
                    if (!opponentLoopActive) return;

                    oppTween = FlxTween.tween(opponent[1], {alpha: oppReverseTargetAlpha}, oppReverseDuration, {
                        onComplete: function(twn2:FlxTween) {
                            if (opponentLoopActive) {
                                oppTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer) {
                                    startOpponentSequence();
                                });
                            }   
                        }
                    });
                });
            }
        });
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}
