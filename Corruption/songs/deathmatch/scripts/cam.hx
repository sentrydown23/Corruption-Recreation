import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;

var camSwing:Bool = false;
var swingTime:Float = 0;
var swingSpeed:Float = 1;
var swingAmount:Float = 2;

var posTime:Float = 0;
var posSpeed:Float = 1;
var posAmountX:Float = 0.5;
var posAmountY:Float = 0.5;

var gameBop:Float = 0.025;
var hudBop:Float = 0.01;
var fastGameBop:Float = 0.035;
var fastHudBop:Float = 0.015;
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
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 1:
            tweenTo(blackBox, {alpha: 0}, 4);

        case 32:
            camswingon();

        case 64:
            bop = true;

        case 96:
            fastbop = true;
            camswingoff();

        case 124:
            bop = false;

        case 128:
            bop = true;
            fastGameBop += 0.01;
            fastHudBop += 0.01;

        case 156:
            bop = false;

        case 160:
            bop = true;

        case 188:
            bop = false;

        case 192:
            bop = true;
            fastbop = false;
            camswingon();

        case 224:
            bop = false;

        case 226:
            bop = true;

        case 253:
            bop = false;
            camswingoff();

        case 256:
            bop = true;
            hudBop += 0.005;
            gameBop += 0.005;
            camswingon();

        case 286:
            bop = false;

        case 288:
            camswingoff();
            bop = true;
            fastbop = true;
            charswingon();

        case 350:
            charswingoff();

        case 352:
            bop = false;
            camswingon();
            swingSpeed = 2;
        
        case 383:
            camswingoff();

        case 384:
            bop = true;
            charswingon();
        
        case 398:
            charswingoff();

        case 416:
            camswingon();
            fastbop = false;

        case 480:
            fastbop = true;

        case 511:
            camswingoff();

        case 542:
            bop = false;

        case 544:
            camswingon(); 
        
        case 608:
            camswingoff();
            

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

    if (swingEnabled) {
        targetAngle = (targetAngle == 8) ? -8 : 8;
        currentAngle = targetAngle;
    }
}

function update(elapsed:Float)
{
     if (swingEnabled) {
        currentAngle *= 0.95; 
        camGame.angle = currentAngle;
    }

    if (camSwing) {
        swingTime += elapsed * swingSpeed;
        camGame.angle = Math.sin(swingTime) * swingAmount;
        
        // Dynamic position sway running on its own speed and amplitude clock
        posTime += elapsed * posSpeed;
        camGame.scroll.x += Math.sin(posTime) * posAmountX;
        camGame.scroll.y += Math.cos(posTime * 1.5) * posAmountY;
    }
}

function charswingon() {
    swingEnabled = true;
}

function charswingoff() { 
    swingEnabled = false; 
    currentAngle = 0;
    camGame.angle = 0;
}

function camswingon() {
    camSwing = true;
}

function camswingoff() {
    camSwing = false;
    camGame.angle = 0;
    
    posTime = 0;
    swingTime = 0;
}


function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}