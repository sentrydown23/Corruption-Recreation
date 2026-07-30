import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var sunset:Array<FlxSprite> = [];
var bglimo:Array<FlxSprite> = [];


function postCreate() {
    sunset.push(skyBG1);
    sunset.push(skyBG2);
    sunset.push(skyBG3);

    bglimo.push(bgLimo1);
    bglimo.push(bgLimo2);

    for (spr in sunset) {
        spr.alpha = 0;
    }

    for (spr in bglimo) {
        spr.alpha = 0;
    }

    switch(SONG.meta.name)
    {
        case "matricidal":
            sunset[0].alpha = 1;
            bglimo[0].alpha = 1;

        case "milk":
            sunset[1].alpha = 1;
            bglimo[0].alpha = 1;

        case "schizophrenzy":
            sunset[2].alpha = 1;
            bglimo[1].alpha = 1;
    }
}

function beatHit(_) {
    switch(_)
    {
        case 176:
            if (SONG.meta.name == "milk") {
                tweenTo(sunset[1], {alpha: 0}, 3.0);
                tweenTo(bglimo[0], {alpha: 0}, 3.0);
                tweenTo(limo, {alpha: 0}, 3.0); // the limo the characters are standing on
            }
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}