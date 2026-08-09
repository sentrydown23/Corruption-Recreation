import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var opponentHidden:Bool = false;

function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camGame];
    add(blackBox);
}

function postCreate()
{
    iconP1.setIcon("bf-frostbite");
    iconP2.setIcon("monster-frostbite");
    camHUD.alpha = 0;
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 4:
            tweenTo(blackBox, {alpha: 0}, 2);

        case 16:
            tweenTo(camHUD, {alpha: 1}, 1);
            blackBox.visible = false;

        case 210:
            blackBox.visible = true;
            blackBox.alpha = 1;

        case 212:
            setToMiddleScroll(1.5);
            tweenHUD(true);
            tweenTo(blackBox, {alpha: 0}, 2);

        case 216:
            blackBox.alpha = 0;
            blackBox.visible = false;

        case 272:
            blackBox.visible = true;
            blackBox.alpha = 1;

        case 276:
            tweenTo(blackBox, {alpha: 0}, 2);
            tweenHUD(false);
            resetStrumlines(1.0);
            
        case 284:
            blackBox.alpha = 0;
            blackBox.visible = false;

        case 340:
            blackBox.alpha = 1;
            blackBox.visible = true;

        case 342:
            blackBox.alpha = 0;
            blackBox.visible = false;
    }
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

function onNoteCreation(event) {
    if (event.strumLine == strumLines.members[0] && opponentHidden) {
        event.note.alpha = 0;
    }
}


function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}

function tweenHUD(hide:Bool)
{
    if (hide)
    {
        tweenTo(healthBar, {alpha: 0}, 1);
        tweenTo(healthBarBG, {alpha: 0}, 1);
        tweenTo(scoreTxt, {alpha: 0}, 1);
        tweenTo(missesTxt, {alpha: 0}, 1);
        tweenTo(accuracyTxt, {alpha: 0}, 1);
        tweenTo(iconP1, {alpha: 0}, 1);
        tweenTo(iconP2, {alpha: 0}, 1);
    }
    else
    {
        tweenTo(healthBar, {alpha: 1}, 1);
        tweenTo(healthBarBG, {alpha: 1}, 1);
        tweenTo(scoreTxt, {alpha: 1}, 1);
        tweenTo(missesTxt, {alpha: 1}, 1);
        tweenTo(accuracyTxt, {alpha: 1}, 1);
        tweenTo(iconP1, {alpha: 1}, 1);
        tweenTo(iconP2, {alpha: 1}, 1);
    }
}