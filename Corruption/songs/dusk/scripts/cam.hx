// --- HALF-STEP SYSTEM VARIABLES ---
var lastHalfStep:Int = -1;

// --- CONFIGURATION SETTINGS ---
var bop:Bool = false;
var shakeBeat:Int = 1; 
var gameBop:Float = 0.035; 
var hudBop:Float = 0.045;   
var flashSprite:FlxSprite;

camZoomingStrength = 0;

function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camHUD];
    add(blackBox);

    new FlxTimer().start(0.1, function(tmr:FlxTimer) {
        flashSprite = new FlxSprite(0, 0);
        flashSprite.loadGraphic(Paths.image("stages/stage2/dusk/endtext"));
        // Force the sprite to fill the entire screen
        flashSprite.setGraphicSize(FlxG.width, FlxG.height);
        flashSprite.updateHitbox(); 

        flashSprite.cameras = [camHUD]; 
        flashSprite.alpha = 0;
        add(flashSprite);
    });
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

function stepHit(_)
{
    switch(_)
    {
        case 2:
            tweenTo(blackBox, {alpha: 0}, 1);

        case 129:
            bop = true;
        case 385:
            bop = false;
        case 577:
            bop = true;
            gameBop = 0.015; 
            hudBop = 0.025;  

        case 640:
            gameBop = 0.035;
            hudBop = 0.025;

        case 769:
            gameBop = 0.045; 
            hudBop = 0.025;  

        case 1153:
            byebyeHUD();
            bop = false;

        case 1160:
            tweenTo(flashSprite, {alpha: 1}, 0.5);
            new FlxTimer().start(2.0, function(timer:FlxTimer) {
                tweenTo(flashSprite, {alpha: 0.0}, 1, {ease: FlxEase.expoOut});
            });
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}

function update(elapsed:Float) { // whole song is half a step off so this is necessary
    var currentHalfStep:Int = Math.floor((curStepFloat - 0.5) * 2);

    if (currentHalfStep > lastHalfStep) {
        lastHalfStep = currentHalfStep;
        
        var actualStep:Float = (currentHalfStep / 2) + 0.5;
        
        var equivalentBeat:Float = actualStep / 4;

        if (equivalentBeat % shakeBeat == 0) {
            
            if (bop) {
                camGame.zoom += gameBop;
                if (camHUD != null) {
                    camHUD.zoom += hudBop;
                }
            }
        }
    }
}

function byebyeHUD()
{
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    scoreTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    missesTxt.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;
    cpuStrums.visible = false;
    playerStrums.visible = false;
}
