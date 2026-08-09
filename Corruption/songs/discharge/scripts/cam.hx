var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;

var camSwing:Bool = false;
var swingTime:Float = 0;
var swingSpeed:Float = 3;
var swingAmount:Float = 0;

var posTime:Float = 0;
var posSpeed:Float = 0.5;
var posAmountX:Float = 0.5;
var posAmountY:Float = 0.5;

var opponentHidden:Bool = false;

var photo:FlxSprite = new FlxSprite();

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
    blackBox.alpha = 0;
    blackBox.cameras = [camGame];
    add(blackBox);

    photo.loadGraphic(Paths.image("stages/screen/discharge/photo"));
    photo.scale.set(0.9, 0.9);
    photo.updateHitbox();
    photo.screenCenter();
    photo.angle = -20;
    photo.alpha = 0;
    photo.cameras = [camHUD];
    add(photo);
}

function postCreate() {
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script


    iconP1.alpha = 0;
    iconP2.alpha = 0;
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    scoreTxt.alpha = 0;
    missesTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    cpuStrums.visible = false;
    byebyeStrums();
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function stepHit(_)
{
    switch(_)
    {
        case 3524:
            FlxTween.tween(photo, {alpha: 1}, 1, {ease: FlxEase.linear});
            FlxTween.tween(photo.scale, {x: 1, y: 1}, 0.5);
            FlxTween.tween(photo, {angle: 0}, 0.5);

        case 3538:
            FlxTween.tween(photo, {alpha: 0.5}, 0.5, {ease: FlxEase.linear});

        case 3546:
            FlxTween.tween(photo, {alpha: 0}, 0.2, {ease: FlxEase.linear});

        case 3550:
            tweenTo(blackBox, {alpha: 0}, 0.2);
    }
}

function beatHit(_)
{
    switch(_)
    {
        case 4:
            // tweenTo(blackBox, {alpha: 0}, 2);

        case 88:
            bop = true;

        case 232:
            bop = false;

        case 288:
            bop = true;

        case 320:
            fastbop = true;

        case 347:
            fastbop = false;
            bop = false;

        case 352:
            cpuStrums.visible = true;
            byebyeStrums(false, 1.0, 1.5);
            hudTween(false, 1.0);
            bop = true;
            fastbop = true;

        case 444:
            fastbop = false;

        case 448:
            fastbop = true;

        case 476:
            fastbop = false;

        case 480:
            hudTween(true, 1.0);

        case 512:
            fastbop = true;

        case 544:
            hudTween(false, 1.0);
            fastbop = false;

        case 640:
            gameBop = 0.02;
            hudBop = 0.035;

        case 736:
            camswingon();

        case 738:
            swingAmount = 0.5;

        case 798:
            camswingoff();
            bop = false;

        case 800:
            camswingon();
            swingAmount = 0.8;
            posSpeed = 1.0;
            bop = true;
            fastbop = true;

        case 862:
            camswingoff();
            fastbop = false;

        case 872:
            bop = false;

        case 880:
            tweenTo(blackBox, {alpha: 1}, 0.2);
            byebyeStrums(false, 0, 0.2);
            byebyeStrums(true, 0, 0.2);

        case 888:
            byebyeStrums(false, 1, 0.2);
            byebyeStrums(true, 1, 0.2);
            bop = true;
            gameBop = 0.01;
            hudBop = 0.025;

        case 952:
            bop = false;

        case 956:
            bop = true;

        case 974:
            hudTween(true, 1.0);

        case 1014:
            hudTween(false, 1.0);

        case 1056:
            bop = false;

        case 1080:
            tweenTo(iconP1, {alpha: 0}, 0.5);
            tweenTo(iconP2, {alpha: 0}, 0.5);
            tweenTo(healthBar, {alpha: 0}, 0.5);
            tweenTo(healthBarBG, {alpha: 0}, 0.5);
            tweenTo(accuracyTxt, {alpha: 0}, 0.5);
            tweenTo(missesTxt, {alpha: 0}, 0.5);
            tweenTo(scoreTxt, {alpha: 0}, 0.5);
            tweenTo(camGame, {alpha: 0}, 0.5);
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

function byebyeStrums(isPlayer:Bool = false, targetAlpha:Float = 0, duration:Float = 1.0)
{   
    var targetStrums = isPlayer ? playerStrums : cpuStrums;  

    targetStrums.forEach(function(strum) {
        FlxTween.globalManager.completeTweensOf(strum);
        FlxTween.tween(strum, {alpha: targetAlpha}, duration);
    });
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
    
    // Resets internal clock loops so old drift values vanish instantly
    posTime = 0;
    swingTime = 0;
}

function hudTween(isOut:Bool = false, duration:Float = 0.5)
{
    var alphaVal:Float = isOut ? 0 : 1.0; 
    
    tweenTo(iconP1, {alpha: alphaVal}, duration);
    tweenTo(iconP2, {alpha: alphaVal}, duration);
    tweenTo(healthBar, {alpha: alphaVal}, duration);
    tweenTo(healthBarBG, {alpha: alphaVal}, duration);
    tweenTo(accuracyTxt, {alpha: alphaVal}, duration);
    tweenTo(missesTxt, {alpha: alphaVal}, duration);
    tweenTo(scoreTxt, {alpha: alphaVal}, duration);
}

function onNoteCreation(event) {
    if (event.strumLine == strumLines.members[0] && opponentHidden) {
        event.note.alpha = 0;
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}