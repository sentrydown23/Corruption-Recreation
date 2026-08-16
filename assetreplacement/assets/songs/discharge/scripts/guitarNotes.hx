var currentSkinPath:String = "game/notes/default"; 

var struns:FlxSprite = new FlxSprite(34, 0);

function create()
{
    struns.loadGraphic(Paths.image("stages/screen/discharge/struns"));
    struns.scale.set(0.93, 1);
    struns.updateHitbox();
    struns.alpha = 0.001;
    struns.cameras = [camHUD];
    insert(0, struns);
}

function postCreate()
{
    rebuildStrumLine(strumLines.members[1]);
}

function stepHit(curStep:Int) {
    if (curStep == 1025) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 1248) {
        currentSkinPath = "game/notes/guitar";
        rebuildStrumLine(strumLines.members[1]);
    }

    if (curStep == 1264) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 1.0);
        });
        tweenTo(struns, {alpha: 1}, 1.0);
    }

    if (curStep == 1408) {
        currentSkinPath = "game/notes/default";
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
        tweenTo(struns, {alpha: 0}, 0.5);
    }
    if (curStep == 1520) {
        rebuildStrumLine(strumLines.members[1], true);
    }
    if (curStep == 1902) {
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 1912) {
        cpuStrums.visible = false;
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 1952) {
        currentSkinPath = "game/notes/guitar";
        rebuildStrumLine(strumLines.members[1]);
    }
    if (curStep == 2036) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 1.0);
        });
        tweenTo(struns, {alpha: 1}, 1.0);
    }
    if (curStep == 2164) {
        currentSkinPath = "game/notes/default";
        struns.alpha = 0;
        rebuildStrumLine(strumLines.members[1], true);
    }

    if (curStep == 2168) {
        cpuStrums.visible = true;
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 0.5);
        });
    }

    if (curStep == 2928) {
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 2934) {
        cpuStrums.visible = false;
    }
    if (curStep == 3328) {
        cpuStrums.visible = true;
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 0.5);
        });
    }
    if (curStep == 3870) {
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 3876) {
        cpuStrums.visible = false;
    }
    if (curStep == 3896) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 3920) {
        currentSkinPath = "game/notes/guitar";
        rebuildStrumLine(strumLines.members[1]);
    }

    if (curStep == 3942) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 1.0);
        });
        tweenTo(struns, {alpha: 1}, 1.0);
    }

    if (curStep == 4018) {
        cpuStrums.visible = true;
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 1}, 0.5);
        });
    }

    if (curStep == 4014) {
        currentSkinPath = "game/notes/default";
        tweenTo(struns, {alpha: 0}, 1.0);
        rebuildStrumLine(strumLines.members[1], true);
    }

    if(curStep == 4248) {
        playerStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
        cpuStrums.forEach(function(strum) {
            tweenTo(strum, {alpha: 0}, 0.5);
        });
    }
    if (curStep == 4272) {
        playerStrums.visible = false;
        cpuStrums.visible = false;
    }
}

function onNoteCreation(e) {
    if (e.strumLine == strumLines.members[1]) {
        e.sprite = currentSkinPath;
    }
}

function onStrumCreation(e) {
    if (e.strumLine == strumLines.members[1]) {
        e.sprite = currentSkinPath;
    }

    if (currentSkinPath == "game/notes/guitar") {
        byebyeStrums(true);
    }
    
    if (currentSkinPath == "game/notes/default") {
        byebyeStrumsbutnormal(true);
    }
}

function byebyeStrums(isPlayer:Bool = false)
{   
    var targetStrums = isPlayer ? playerStrums : cpuStrums;  

    targetStrums.forEach(function(strum) {
        strum.alpha = 0;
    });

    for (i in 0...playerStrums.members.length) {
        var receptor = playerStrums.members[i];
        if (receptor != null) {
            FlxTween.globalManager.cancelTweensOf(receptor);
            var targetX = 465 + (i * 112); 
            FlxTween.tween(receptor, {x: targetX}, 0.001, {ease: FlxEase.quadOut});
        }
    }
}

function byebyeStrumsbutnormal(isPlayer:Bool = false)
{   
        var targetStrums = isPlayer ? playerStrums : cpuStrums;  
    
        targetStrums.forEach(function(strum) {
            strum.alpha = 0;
        });
}

function rebuildStrumLine(strumLine, shouldAnim:Bool = false) {
    if (strumLine == null) return;

    // 1. Completely remove and destroy old receptors from the rendering group
    for (strum in strumLine.members) {
        if (strum != null) {
            strumLine.remove(strum, true);
            strum.destroy();
        }
    }
    strumLine.members = [];

    // 2. Rebuild the 4 arrows manually with intro animation set to false
    for (i in 0...4) {
        // Parameters: index, animPrefix, spritePath, playIntroAnimation
        // We set playIntroAnimation to false to force instant generation
        var newStrum = strumLine.createStrum(i, null, currentSkinPath, shouldAnim);
        
        if (newStrum != null) {
            // Push it back into the StrumLine group array natively
            strumLine.add(newStrum);
        }
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}

function setToMiddleScroll(duration:Float) {
    var playerStrum = strumLines.members[1];
}

function resetStrumlines(duration:Float) {
    var playerStrum = strumLines.members[1];

    for (i in 0...playerStrum.members.length) {
        var receptor = playerStrum.members[i];
        if (receptor != null) {
            FlxTween.globalManager.cancelTweensOf(receptor);
            FlxTween.tween(receptor, {x: 732 + (i * 112)}, duration, {ease: FlxEase.quadOut});
        }
    }
}
