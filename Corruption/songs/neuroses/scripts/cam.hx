var gameBop:Float = 0.01;
var hudBop:Float = 0.025;
var fastbop:Bool = false;
var bop:Bool = false;

camZoomingStrength = 0;

function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camGame];
    add(blackBox);
    blackBox.alpha = 0;
}

function postCreate() {
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 40:
            bop = true;

        case 64:
            bop = false;

        case 72:
            bop = true;
            fastbop = true;

        case 136:
            fastbop = false;

        case 200:
            gameBop = 0.02;
            hudBop = 0.045;

        case 232:
            fastbop = true;

        case 296:
            fastbop = false;
            gameBop = 0.01;
            hudBop = 0.025;

        case 328:
            gameBop = 0.02;
            hudBop = 0.045;

        case 360:
            fastbop = true;

        case 392:
            fastbop = false;

        case 456:
            fastbop = true;
            gameBop = 0.01;
            hudBop = 0.025;

        case 520:
            tweenTo(iconP2, {alpha: 0}, 5);

            cpuStrums.forEach(function(strum) {
                tweenTo(strum, {alpha: 0}, 5);
            });

            bop = false;
            fastbop = false;

        case 620:
            tweenTo(camHUD, {alpha: 0}, 2);
            doIconBop = false;
            

        case 636:
            tweenTo(blackBox, {alpha: 1}, 1);
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
        camGame.zoom += gameBop;
        camHUD.zoom += hudBop;
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}