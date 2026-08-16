var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;

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
    blackBox.cameras = [camHUD];
    add(blackBox);
}

function postCreate() 
{
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    
    bop = true;
}



function update()
{
     if (swingEnabled) {
        currentAngle *= 0.95; 
        camGame.angle = currentAngle;
    }
}

function beatHit(_)
{
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

    switch(_)
    {
        case 1:
            tweenTo(blackBox, {alpha: 0}, 5);

        case 64:
            fastbop = true;
            charswingon();

        case 96:
            charswingoff();
            fastbop = false;

        case 128:
            fastbop = true;
            charswingon();
        
        case 192:
            charswingoff();
            fastbop = false;

        case 256:
            fastbop = true;
            charswingon();

        case 320:
            charswingoff();
            fastbop = false;
            bop = false;
            tweenTo(blackBox, {alpha: 1}, 5);
    }

    if (swingEnabled) {
        targetAngle = (targetAngle == 6) ? -6 : 6;
        currentAngle = targetAngle;
    }
}

function charswingon() {
    swingEnabled = true;
    fastbop = true;
}

function charswingoff() { 
    swingEnabled = false; 
    fastbop = false;
    currentAngle = 0;
    camGame.angle = 0;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}