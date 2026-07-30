var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;
var angleamount:Float = 8;

var camSwing:Bool = false;
var swingTime:Float = 0;
var swingSpeed:Float = 5;
var swingAmount:Float = 2;

var posTime:Float = 0;
var posSpeed:Float = 1;
var posAmountX:Float = 1;
var posAmountY:Float = 1;

var gameBop:Float = 0.01;
var hudBop:Float = 0.025;

var fastbop:Bool = false;
var bop:Bool = false;

camZoomingStrength = 0;

function postCreate() 
{
    defaultDisplayRating = false;
    defaultDisplayCombo = false;
    minDigitDisplay = -1;
    startSong();
    camswingon();
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

function beatHit(curBeat:Int) {
    // Timeline event triggers
    switch(curBeat)
    {
        case 184:
            camswingoff();
            charswingon();

        case 216:
            charswingoff();
    }

    // Standard Bop (Every 2 beats)
    if (bop && !fastbop && curBeat % 2 == 0) {
        camGame.zoom += gameBop;
        camHUD.zoom += hudBop;
    }
    // Fast Bop (Every 1 beat)
    else if (bop && fastbop) {
        camGame.zoom += gameBop + gameBop; // double
        camHUD.zoom += hudBop + hudBop;   // double
    }

    // Character Angle Swing (Triggers on every beat)
    if (swingEnabled) {
        targetAngle = (targetAngle == angleamount) ? -angleamount : angleamount;
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