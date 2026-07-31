var gameBop:Float = 0.02;
var hudBop:Float = 0.03;
var bop:Bool = false;

function postCreate() 
{
    defaultDisplayRating = false;
    defaultDisplayCombo = false;
    minDigitDisplay = -1;
    // startSong(); 
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    if (_ == 33) {
        bop = true;
    }
    
    if (bop) {
        if (_ % 2 == 0) {
        camGame.zoom += gameBop;
        camHUD.zoom += hudBop;
        }
    }
}