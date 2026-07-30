var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;
var angleamount:Float = 4;

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

function stepHit(curStep:Int) {
    // 2 steps offset: Convert current step into beat decimal (e.g. step 2 = beat 0.5, step 6 = beat 1.5)
    var curBeat:Int = Math.floor((curStep - 2) / 4);

    // Timeline event triggers (Mapped to the 2-step offset beat)
    if ((curStep - 2) % 4 == 0) {
        switch(curBeat)
        {
            case 10:
                bop = true;

            case 41:
                fastbop = true;

            case 57:
                charswingon();

            case 74:
                fastbop = false;
                charswingoff();

            case 121:
                fastbop = true;
                camswingon();

            case 161:
                fastbop = false;
                camswingoff();

            case 177:
                charswingon();

            case 194:
                fastbop = true;
                camswingon();
                charswingoff();

            case 242:
                fastbop = false;
                camswingoff();
                bop = false;
        }
    }

    if ((curStep - 2) % 4 == 0) {
        // Standard Bop (Every 2 beats / 8 steps)
        if (bop && !fastbop && (curStep - 2) % 8 == 0) {
            camGame.zoom += gameBop;
            camHUD.zoom += hudBop;
        }
        // Fast Bop (Every 1 beat / 4 steps)
        else if (bop && fastbop) {
            camGame.zoom += gameBop + gameBop; // double
            camHUD.zoom += hudBop + hudBop; // double
        }

        // Character Angle Swing (Triggers on the offset beat)
        if (swingEnabled) {
            targetAngle = (targetAngle == angleamount) ? -angleamount : angleamount;
            currentAngle = targetAngle;
        }
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