var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;

var camSwing:Bool = false;
var swingTime:Float = 0;
var swingSpeed:Float = 1;
var swingAmount:Float = 2;

var posTime:Float = 0;
var posSpeed:Float = 2;
var posAmountX:Float = 0.5;
var posAmountY:Float = 0.5;

var gameBop:Float = 0.01;
var hudBop:Float = 0.025;
var fastbop:Bool = false;
var bop:Bool = false;

function postCreate() 
{
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
}

function onCountdown(event) {
   event.cancel();
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

function beatHit(_)
{
    switch(_)
    {
        case 32: 
            bop = true;
            camswingon();

        case 128:
            posAmountX = 1;
            posAmountY = 1;

        case 160:
            posAmountX = 0.5;
            posAmountY = 0.5;

        case 224:
            fastbop = true;
            posAmountX = 1;
            posAmountY = 1;
            posSpeed = 2.5;

        case 352:
            camswingoff();
            bop = false;
            fastbop = false;
    }

    if (bop && !fastbop)
    {
        if (_ % 2 == 0) {
            camGame.zoom += gameBop;
            camHUD.zoom += hudBop;
        }
    }
    else if (bop && fastbop)
    {
        camGame.zoom += gameBop;
        camHUD.zoom += hudBop;
    }

    if (swingEnabled) {
        targetAngle = (targetAngle == 4) ? -4 : 4;
        currentAngle = targetAngle;
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
    
    // Resets internal clock loops so old drift values vanish instantly
    posTime = 0;
    swingTime = 0;
}
