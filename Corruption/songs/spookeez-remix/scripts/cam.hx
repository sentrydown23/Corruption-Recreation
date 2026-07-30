var swingEnabled:Bool = false;
var currentAngle:Float = 0;
var targetAngle:Float = 0;

var gameBop:Float = 0.01;
var hudBop:Float = 0.025;
var fastbop:Bool = false;

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

function update()
{
     if (swingEnabled) {
        currentAngle *= 0.95; 
        camGame.angle = currentAngle;
    }
}

function beatHit(_)
{
    if (!fastbop)
    {
        if (_ % 2 == 0) {
            camGame.zoom += gameBop;
            camHUD.zoom += hudBop;
        }
    }
    else if (fastbop)
    {
        camGame.zoom += gameBop;
        camHUD.zoom += hudBop;
    }

    switch(_)
    {
        case 48:
            charswingon();

        case 80: 
            charswingoff();

        case 112:
            charswingon();

        case 144: 
            charswingoff();
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
