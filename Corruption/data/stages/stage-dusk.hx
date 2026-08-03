import flixel.util.FlxTimer;

var bgParts:Array<FlxSprite> = [];

function postCreate()
{
    bgParts.push(bg);
    bgParts.push(stageFront);
    bgParts.push(stageCurtains);

    eyes.alpha = 0;
}

function beatHit(_)
{
    switch(_)
    {
        case 159:
            for (spr in bgParts) {
                tweenTo(spr, {alpha: 0}, 0.5);
            }

        case 191: 
            for (spr in bgParts) {
                tweenTo(spr, {alpha: 1}, 0.2);
            }
    }
}

function stepHit(_)
{
    switch(_)
    {
        case 1153:
            for (spr in bgParts) {
                spr.alpha = 0;
            }
            eyes.alpha = 1;

            new FlxTimer().start(0.2, function(timer:FlxTimer) {
                tweenTo(eyes, {alpha: 0.0}, 1, {ease: FlxEase.expoOut});
            });
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}