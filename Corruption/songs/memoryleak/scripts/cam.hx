var speedLines:FunkinSprite;

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
    blackBox.alpha = 0;

    whiteBox = new FlxSprite(0, 0);
    whiteBox.makeGraphic(5000, 5000, 0xFFFFFFFF);
    whiteBox.screenCenter();
    whiteBox.scrollFactor.set(0, 0);
    whiteBox.cameras = [camHUD];
    add(whiteBox);
    whiteBox.alpha = 1;


    speedLines = new FunkinSprite(0, 0);
    speedLines.loadGraphic(Paths.image('stages/screen/memoryleak/line'));
    speedLines.frames = Paths.getSparrowAtlas('stages/screen/memoryleak/line');
    speedLines.animation.addByPrefix('line', 'speedLines', 24, true);
    speedLines.animation.play('line');
    speedLines.setGraphicSize(FlxG.width, FlxG.height);
    speedLines.updateHitbox();
    speedLines.cameras = [camHUD];
    speedLines.alpha = 0;
    add(speedLines);
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

function onSongStart()
{
    camGame.shake(0.00075, 30);
    hideHUD();
}

function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 26:
            FlxTween.tween(whiteBox, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});

        case 400:
            camGame.shake(0.0017, 0.5);

        case 407:
            FlxTween.tween(FlxG.camera.scroll, {y: -3350}, 3.5, {ease: FlxEase.quadInOut});
            FlxTween.tween(camFollow, {y: -3350}, 3.5, {ease: FlxEase.quadInOut});
            FlxTween.tween(speedLines, {alpha: 0.8}, 1, {ease: FlxEase.quadIn});

        case 770:
            FlxTween.tween(speedLines, {alpha: 0.3}, 0.1, {ease: FlxEase.quadIn});
            showHUD();

        case 784:
            bop = true;

        case 912:
            fastbop = true;

        case 1022:
            setToMiddleScroll(1.5);

        case 1040:
            bop = false;
            fastbop = false;

        case 1296:
            bop = true;
            resetStrumlines(1.0);

        case 1424:
            fastbop = true;

        case 1662:
            bop = false;
            fastbop = false;

        case 1670:
            hideHUDTween();

        case 1680:
            FlxTween.tween(speedLines, {alpha: 0}, 0.1, {ease: FlxEase.quadIn});
            showHUD();

        case 1918:
            setToMiddleScroll(1.5);

        case 2046:
            resetStrumlines(1.0);
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

function setToMiddleScroll(duration:Float) {
    opponentHidden = true;
    var opponentStrum = strumLines.members[0];
    var playerStrum = strumLines.members[1];

    if (opponentStrum != null && playerStrum != null) {
        for (receptor in opponentStrum.members) {
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                FlxTween.tween(receptor, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            }
        }

        for (note in opponentStrum.notes.members) {
            if (note != null) {
                FlxTween.globalManager.cancelTweensOf(note);
                FlxTween.tween(note, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            }
        }

        for (i in 0...playerStrum.members.length) {
            var receptor = playerStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                var targetX = 412 + (i * 112); 
                FlxTween.tween(receptor, {x: targetX}, duration, {ease: FlxEase.quadOut});
            }
        }
    }
}

function resetStrumlines(duration:Float) {
    opponentHidden = false;
    var opponentStrum = strumLines.members[0];
    var playerStrum = strumLines.members[1];

    if (opponentStrum != null && playerStrum != null) {
        for (i in 0...opponentStrum.members.length) {
            var receptor = opponentStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                FlxTween.tween(receptor, {alpha: 1, x: 92 + (i * 112)}, duration, {ease: FlxEase.quadOut});
            }
        }

        for (note in opponentStrum.notes.members) {
            if (note != null) {
                FlxTween.globalManager.cancelTweensOf(note);
                FlxTween.tween(note, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            }
        }

        for (i in 0...playerStrum.members.length) {
            var receptor = playerStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                FlxTween.tween(receptor, {x: 732 + (i * 112)}, duration, {ease: FlxEase.quadOut});
            }
        }
    }
}