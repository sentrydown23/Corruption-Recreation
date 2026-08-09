var screenParts:Array<FlxSprite> = [];
var dischargeParts:Array<FlxSprite> = [];

function postCreate()
{
    screenParts.push(bg);
    screenParts.push(bg2);
    screenParts.push(tv);

    dischargeParts.push(bg3);
    dischargeParts.push(mountains);
    dischargeParts.push(rock1);
    dischargeParts.push(rock2);
    dischargeParts.push(platform);

    screenParts[1].alpha = 0; 
    // discharge bg is BEHIND everything already so theres no need to hide them

}

function beatHit(_)
{
    switch(_)
    {
        case 200:
            tweenTo(screenParts[1], {alpha: 1}, 2);

        case 296:
            tweenTo(screenParts[1], {alpha: 0}, 1);

        case 312:
            tweenTo(screenParts[1], {alpha: 1}, 0.5);

        case 519:
            screenParts[0].alpha = 0;

        case 520:
            for (spr in screenParts) {
                tweenTo(spr, {alpha: 0}, 5);
            }
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}