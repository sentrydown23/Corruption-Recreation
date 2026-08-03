var gameBop:Float = 0.01;
var hudBop:Float = 0.025;
var fastGameBop:Float = 0.015;
var fastHudBop:Float = 0.045;
var fastbop:Bool = false;
var bop:Bool = false;

camZoomingStrength = 0;

function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camHUD];
    add(blackBox);
}

function postCreate() 
{
    defaultDisplayRating = false;
    defaultDisplayCombo = false;
    minDigitDisplay = -1;
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 4:
            tweenTo(blackBox, {alpha: 0}, 7);

        case 33:
            bop = true;
        case 96:
            fastbop = true;

        case 160:
            fastbop = false;
            gameBop = 0.015;
            hudBop = 0.030;

        case 224:
            fastbop = true;

        case 352:
            bop = false;
            tweenTo(blackBox, {alpha: 1}, 5);
    }

    if (!fastbop && bop)
    {
        if (_ % 2 == 0) {
            camGame.zoom += gameBop;
            camHUD.zoom += hudBop;
        }
    }
    else if (fastbop && bop)
    {
        camGame.zoom += fastGameBop;
        camHUD.zoom += fastHudBop;
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}