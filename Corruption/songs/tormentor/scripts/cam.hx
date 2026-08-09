var gameBop:Float = 0.01;
var hudBop:Float = 0.025;
var fastbop:Bool = false;
var bop:Bool = false;

camZoomingStrength = 0;

function create()
{
    // not needed
}

function postCreate() {
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script

    hideHUD();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 16:
            bop = true;
            fastbop = true;
            showHUD();

        case 192:
            gameBop = 0.02;
            hudBop = 0.035;

        case 208:
            gameBop = 0.01;
            hudBop = 0.025;

        case 288:
            bop = false;
            fastbop = false;

        case 292:
            hideHUDTween();
        
        case 320:
            camGame.alpha = 0;
            camHUD.alpha = 0;
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

function hideHUD()
{
    iconP1.visible = false;
    iconP2.visible = false;
    healthBar.visible = false;
    healthBarBG.visible = false;
    scoreTxt.visible = false;
    missesTxt.visible = false;
    accuracyTxt.visible = false;
    cpuStrums.visible = false;
    playerStrums.visible = false;

    iconP1.alpha = 0;
    iconP2.alpha = 0;
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    scoreTxt.alpha = 0;
    missesTxt.alpha = 0;
    accuracyTxt.alpha = 0;

    new FlxTimer().start(0.5, function(tmr:FlxTimer) {
        cpuStrums.forEach(function(strum) {
            strum.alpha = 0;
        });

        playerStrums.forEach(function(strum) {
            strum.alpha = 0;
        });
    });
    
}
    
function showHUD()
{
    iconP1.visible = true;
    iconP2.visible = true;
    healthBar.visible = true;
    healthBarBG.visible = true;
    scoreTxt.visible = true;
    missesTxt.visible = true;
    accuracyTxt.visible = true;
    cpuStrums.visible = true;
    playerStrums.visible = true;

    var hudElements:Array<Dynamic> = [
        iconP1,
        iconP2,
        healthBar,
        healthBarBG,
        scoreTxt,
        missesTxt,
        accuracyTxt
    ];

    for (elem in hudElements) {
        FlxTween.tween(elem, {alpha: 1}, 1.0, {ease: FlxEase.circOut});
    }

    cpuStrums.forEach(function(strum) {
        FlxTween.tween(strum, {alpha: 1}, 1.0, {ease: FlxEase.circOut});
    });

    playerStrums.forEach(function(strum) {
        FlxTween.tween(strum, {alpha: 1}, 1.0, {ease: FlxEase.circOut});
    });
}
    
function hideHUDTween()
{
    var hudElements:Array<Dynamic> = [
        iconP1,
        iconP2,
        healthBar,
        healthBarBG,
        scoreTxt,
        missesTxt,
        accuracyTxt
    ];

    for (elem in hudElements) {
        FlxTween.tween(elem, {alpha: 0}, 1.0, {ease: FlxEase.circOut});
    }

    cpuStrums.forEach(function(strum) {
        FlxTween.tween(strum, {alpha: 0}, 1.0, {ease: FlxEase.circOut});
    });

    playerStrums.forEach(function(strum) {
        FlxTween.tween(strum, {alpha: 0}, 1.0, {ease: FlxEase.circOut});
    });
}